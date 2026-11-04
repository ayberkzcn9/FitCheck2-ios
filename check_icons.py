import re,glob,sys
cnt={}
for f in glob.glob('lib/**/*.dart',recursive=True):
    try:
        s=open(f,encoding='utf-8').read()
        for m in re.finditer(r'Icons\.([A-Za-z0-9_]+)',s):
            n=m.group(1)
            cnt[n]=cnt.get(n,0)+1
    except: pass
legacy={n:c for n,c in cnt.items() if not n.endswith(('_rounded','_outlined','_sharp','_two_tone'))}
if legacy:
    print('NON-ROUNDED/OUTLINED:')
    for n,c in sorted(legacy.items()): print('  %s: %d' % (n,c))
else:
    print('All icons use standard variants OK')