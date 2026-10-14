import json
import os

# List of ARB files to update
arb_files = [
    'lib/l10n/app_tr.arb',
    'lib/l10n/app_en.arb',
    'lib/l10n/app_de.arb',
    'lib/l10n/app_es.arb',
    'lib/l10n/app_fr.arb',
    'lib/l10n/app_it.arb',
    'lib/l10n/app_ja.arb',
    'lib/l10n/app_ko.arb',
    'lib/l10n/app_pt.arb',
    'lib/l10n/app_ru.arb',
    'lib/l10n/app_zh.arb',
    'lib/l10n/app_ar.arb',
]

base_path = r'C:\Users\mehmet\Downloads\Yeni klasor26'

for arb_file in arb_files:
    full_path = os.path.join(base_path, arb_file)
    if not os.path.exists(full_path):
        print(f'Skipping {arb_file} (not found)')
        continue
    
    with open(full_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Parse JSON (ARB is JSON with some special keys)
    try:
        data = json.loads(content)
    except json.JSONDecodeError as e:
        print(f'Error parsing {arb_file}: {e}')
        continue
    
    updated = False
    
    # Update modaYarismasiSkor
    if 'modaYarismasiSkor' in data:
        old_val = data['modaYarismasiSkor']
        if '/ 5' in old_val:
            data['modaYarismasiSkor'] = old_val.replace('/ 5', '/ 10')
            updated = True
            print(f'{arb_file}: modaYarismasiSkor updated')
    
    # Update modaYarismasiSoru
    if 'modaYarismasiSoru' in data:
        old_val = data['modaYarismasiSoru']
        if '/ 5' in old_val:
            data['modaYarismasiSoru'] = old_val.replace('/ 5', '/ 10')
            updated = True
            print(f'{arb_file}: modaYarismasiSoru updated')
    
    # Update modaYarismasiYeniYarin
    if 'modaYarismasiYeniYarin' in data:
        old_val = data['modaYarismasiYeniYarin']
        if '5 soru' in old_val or '5 soruluk' in old_val:
            new_val = old_val.replace('5 soru', '10 soru').replace('5 soruluk', '10 soruluk')
            data['modaYarismasiYeniYarin'] = new_val
            updated = True
            print(f'{arb_file}: modaYarismasiYeniYarin updated')
    
    if updated:
        # Write back with proper formatting
        with open(full_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f'{arb_file}: SAVED')
    else:
        print(f'{arb_file}: No changes needed')

print('ARB update complete!')