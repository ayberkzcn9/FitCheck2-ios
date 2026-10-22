import io
p = r'D:\indirilenler\Yeni klasor43\lib\screens\bugun_ekrani.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

# Yatay raf: sabit 106 px yukseklik, metin %200 buyutuldugunde etiket
# tasardi. Yukseklik metin olcegine gore hesaplansin.
eski = """        SizedBox(
          height: 106,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: parcalar.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final parca = parcalar[i];
              return SizedBox(
                width: 96,"""
yeni = """        // Yukseklik sabit degil: metin olcegi buyudugunde (erisilebilirlik
        // ayari %200) etiket de buyur, raf da ona gore uzasin.
        Builder(
          builder: (context) {
            final metinOlcegi = MediaQuery.textScalerOf(context).scale(12);
            final rafYuksekligi = 76 + metinOlcegi * 1.4 + AppSpacing.xs * 2;
            return SizedBox(
          height: rafYuksekligi,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: parcalar.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final parca = parcalar[i];
              return SizedBox(
                width: 96,"""
if s.count(eski) != 1:
    raise SystemExit('eslesme: %d' % s.count(eski))
s = s.replace(eski, yeni)

# Kapanis parantezlerini duzelt: ListView'in kapanisi ve SizedBox'in kapanisi.
eski2 = """                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }"""
yeni2 = """                  ],
                ),
              );
            },
          ),
        );
          },
        ),
      ],
    );
  }"""
if s.count(eski2) != 1:
    raise SystemExit('kapanis: %d' % s.count(eski2))
s = s.replace(eski2, yeni2)
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
