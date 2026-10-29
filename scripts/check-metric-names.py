#!/usr/bin/env python3
"""Check every metric name in modules/*/defaults.tf against the REST API names on Microsoft Learn.

Run from the repo root: python3 scripts/check-metric-names.py
Needs network access. Known intentional mismatches (disk burst/queue metrics) are listed below.
"""
import sys
import re,glob,urllib.request,os
base="https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/"
cache={}
def rest_names(ns):
    slug="microsoft-"+ns.lower().split('/',1)[0].replace("microsoft.","").replace(".","-")+"-"+ns.lower().split('/',1)[1].replace("/","-")+"-metrics"
    if slug in cache: return cache[slug]
    try:
        t=urllib.request.urlopen(base+slug).read().decode()
        rows=re.findall(r'<tr>\s*<td>(.*?)</td>\s*<td><code>(.*?)</code></td>',t,re.S)
        d={}
        for disp,rest in rows:
            d[rest]=re.sub(r'<[^>]+>',' ',disp).split()[0] if disp else ''
        cache[slug]=(slug,d)
    except Exception as e:
        cache[slug]=(slug,None)
    return cache[slug]
bad=[]
KNOWN={('disk','queue_depth'),('disk','burst_bps_credits'),('disk','burst_io_credits')}
for f in sorted(glob.glob("modules/*/defaults.tf")):
    m=f.split('/')[1]
    s=open(f).read()
    mt=re.search(r'metric_namespace\s*=\s*"([^"]+)"',s)
    blocks=re.findall(r'^\s{4}(\w+)\s*=\s*\{(.*?)^\s{4}\}',s.split("metrics = {",1)[-1].split("# Resolve")[0].split("selected_profile")[0],re.S|re.M)
    for key,body in blocks:
        n=re.search(r'^\s*name\s*=\s*"([^"]+)"',body,re.M)
        ns=re.search(r'namespace\s*=\s*"([^"]+)"',body)
        if not n: continue
        nsv=(ns.group(1) if ns else (mt.group(1) if mt else None))
        if not nsv:
            print(m,key,"NO NAMESPACE"); bad.append((m,key)); continue
        slug,d=rest_names(nsv)
        name=n.group(1)
        if d is None:
            print(f"{m}:{key}: {name} -- page not found {slug}"); bad.append((m,key))
        elif name not in d:
            if (m,key) not in KNOWN: bad.append((m,key))
            alt=[r for r,disp in d.items() if disp.lower()==name.lower() or r.lower()==name.lower()]
            print(f"{m}:{key}: {name} NOT A REST NAME ({nsv})"+(f" -> maybe {alt}" if alt else ""))
print(f"{len(bad)} unexpected mismatch(es) or failed lookup(s)")
sys.exit(1 if bad else 0)
