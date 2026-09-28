#!/usr/bin/env python3
"""Regenerate the per-module tables in docs/thresholds.md from the module code.

Reads profiles.tf, defaults.tf and main.tf of every module under modules/
(except base) and rewrites everything below the GENERATED marker in
docs/thresholds.md. Run from the repository root:

    pip install python-hcl2
    python3 scripts/gen-thresholds.py
"""
import glob
import os
import re
import sys

import hcl2

DOC = "docs/thresholds.md"
MARKER = "<!-- GENERATED: tables below are written by scripts/gen-thresholds.py -->"

# Display names; a new module must be added here.
TITLES = {
    "aks": "AKS", "appgateway": "Application Gateway", "appservice": "App Service",
    "containerapp": "Container App", "cosmosdb": "Cosmos DB", "disk": "Managed Disk",
    "eventhub": "Event Hub Namespace", "expressroute": "ExpressRoute Circuit",
    "firewall": "Azure Firewall", "function": "Function App", "keyvault": "Key Vault",
    "lb": "Load Balancer", "mysql": "MySQL Flexible Server",
    "postgresql": "PostgreSQL Flexible Server", "redis": "Redis Cache",
    "servicebus": "Service Bus Namespace", "sqldb": "Azure SQL Database",
    "sqlmi": "SQL Managed Instance", "storage": "Storage Account",
    "vm": "Virtual Machine", "vmss": "Virtual Machine Scale Set", "vpngw": "VPN Gateway",
}
OPS = {"GreaterThan": ">", "LessThan": "<", "GreaterThanOrEqual": ">=", "LessThanOrEqual": "<="}


def clean(s):
    return str(s).strip('"')


def fmt(v):
    if v is None:
        return "-"
    if isinstance(v, float) and v.is_integer():
        v = int(v)
    return str(v)


def load_module(path):
    locals_ = {}
    for name in ("profiles.tf", "defaults.tf"):
        with open(os.path.join(path, name)) as fh:
            for block in hcl2.load(fh).get("locals", []):
                locals_.update(block)

    def resolve(expr):
        expr = clean(expr)
        m = re.fullmatch(r"\$\{local\.metrics\.(\w+)\.(\w+)\}", expr)
        if m:
            return clean(locals_["metrics"][m.group(1)][m.group(2)])
        if expr == "${local.metric_namespace}":
            return clean(locals_["metric_namespace"])
        return expr

    alerts = {}
    with open(os.path.join(path, "main.tf")) as fh:
        resources = hcl2.load(fh).get("resource", [])
    for res in resources:
        for rtype, instances in res.items():
            if clean(rtype) != "azurerm_monitor_metric_alert":
                continue
            for body in instances.values():
                criteria = body["criteria"][0] if isinstance(body["criteria"], list) else body["criteria"]
                ref = re.search(r"resolved\.(\w+)\.(warning|critical)_threshold", str(criteria["threshold"]))
                if not ref:
                    sys.exit(f"{path}: cannot map alert {clean(body['name'])} to a metric")
                key, level = ref.groups()
                suffix = re.sub(r"^\$\{var\.resource_name\}-", "", clean(body["name"]))
                entry = alerts.setdefault(key, {"levels": set()})
                entry["levels"].add(level)
                entry.update(
                    suffix=re.sub(r"-(warn|crit)$", "", suffix),
                    namespace=resolve(criteria["metric_namespace"]),
                    metric=resolve(criteria["metric_name"]),
                    aggregation=resolve(criteria["aggregation"]),
                    operator=resolve(criteria["operator"]),
                )
    return locals_, alerts


def render(module, locals_, alerts):
    std, crit = locals_["profiles"]["standard"], locals_["profiles"]["critical"]
    namespaces = sorted({a["namespace"] for a in alerts.values()})
    lines = [
        f"### {TITLES[module]} (`{module}`)",
        "",
        f"Namespace: `{'`, `'.join(namespaces)}`",
        "",
        "| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |",
        "|---|---|---|---|---|---|---|---|",
    ]
    for key in locals_["metrics"]:
        s, c, a = std[key], crit[key], alerts[key]

        def pair(p):
            warn = p.get("warning_threshold") if "warning" in a["levels"] else None
            return f"{fmt(warn)} / {fmt(p.get('critical_threshold'))}"

        s_on, c_on = s.get("enabled", True), c.get("enabled", True)
        label = f"`{key}`"
        if s_on != c_on:
            label += f" (standard {'on' if s_on else 'off'}, critical {'on' if c_on else 'off'})"
        elif not s_on:
            label += " (off)"
        window = fmt(s["window_minutes"])
        if s["window_minutes"] != c["window_minutes"]:
            window = f"{fmt(s['window_minutes'])} / {fmt(c['window_minutes'])}"
        lines.append(
            f"| {label} | `{a['suffix']}` | {a['metric']} | {a['aggregation']} | "
            f"{OPS.get(a['operator'], a['operator'])} | {window} | {pair(s)} | {pair(c)} |"
        )
    return "\n".join(lines) + "\n"


def main():
    modules = sorted(os.path.basename(p.rstrip("/")) for p in glob.glob("modules/*/"))
    modules = [m for m in modules if m != "base"]
    missing = [m for m in modules if m not in TITLES]
    if missing:
        sys.exit(f"add a display name to TITLES for: {', '.join(missing)}")

    sections = [render(m, *load_module(f"modules/{m}")) for m in sorted(modules, key=lambda m: TITLES[m].lower())]

    with open(DOC) as fh:
        head = fh.read().split(MARKER)[0]
    with open(DOC, "w") as fh:
        fh.write(head + MARKER + "\n\n" + "\n".join(sections))
    print(f"wrote {len(sections)} module tables to {DOC}")


if __name__ == "__main__":
    main()
