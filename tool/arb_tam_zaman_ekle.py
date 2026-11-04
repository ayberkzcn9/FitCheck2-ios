# -*- coding: utf-8 -*-
"""12 ARB dosyasina 'tam zamanli bildirim' metinlerini ekler."""
import io, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib\l10n'

M = {
    'tr': [
        "Tam Zamanlı Bildirim",
        "Bildirimlerin tam seçtiğin saatte gelmesi için Android'de 'Alarms & reminders' iznini ver.",
        "Tam zamanlı bildirimler açık.",
    ],
    'en': [
        "Exact-time notifications",
        "Allow 'Alarms & reminders' on Android so notifications arrive exactly at the time you chose.",
        "Exact-time notifications are on.",
    ],
    'it': [
        "Notifiche a orario esatto",
        "Consenti 'Alarms & reminders' su Android per ricevere le notifiche esattamente all'ora scelta.",
        "Le notifiche a orario esatto sono attive.",
    ],
    'es': [
        "Notificaciones a la hora exacta",
        "Permite 'Alarms & reminders' en Android para recibirlas exactamente a la hora que elijas.",
        "Las notificaciones a la hora exacta están activadas.",
    ],
    'zh': [
        "准时通知",
        "在 Android 上允许'Alarms & reminders'，通知就会在你选择的时间准时送达。",
        "准时通知已开启。",
    ],
    'ar': [
        "إشعارات في الوقت المحدد",
        "اسمح بـ «Alarms & reminders» على أندرويد لتصلك الإشعارات في الوقت الذي تختاره بالضبط.",
        "تم تفعيل الإشعارات في الوقت المحدد.",
    ],
    'fr': [
        "Notifications à l'heure exacte",
        "Autorisez « Alarms & reminders » sur Android pour recevoir les notifications exactement à l'heure choisie.",
        "Les notifications à l'heure exacte sont activées.",
    ],
    'de': [
        "Benachrichtigungen zur genauen Uhrzeit",
        "Erlaube unter Android „Alarms & reminders“, damit Benachrichtigungen genau zur gewählten Zeit eintreffen.",
        "Benachrichtigungen zur genauen Uhrzeit sind aktiv.",
    ],
    'pt': [
        "Notificações à hora exata",
        "Permite 'Alarms & reminders' no Android para as notificações chegarem exatamente à hora escolhida.",
        "As notificações à hora exata estão ativas.",
    ],
    'ja': [
        "正確な時刻の通知",
        "選んだ時刻ちょうどに届くように、Android で「Alarms & reminders」を許可してください。",
        "正確な時刻の通知が有効になりました。",
    ],
    'ko': [
        "정확한 시간 알림",
        "선택한 시간에 정확히 받으려면 Android에서 'Alarms & reminders'를 허용하세요.",
        "정확한 시간 알림이 켜졌어요.",
    ],
    'ru': [
        "Уведомления точно вовремя",
        "Разрешите «Alarms & reminders» на Android, чтобы уведомления приходили ровно в выбранное время.",
        "Уведомления точно вовремя включены.",
    ],
}

ANAHTARLAR = ['bildirimTamZamanAyar', 'bildirimTamZamanAciklama', 'bildirimTamZamanAcik']
KOSU = 'bildirimIzinGerekliUyari'


def kaçış(s):
    return s.replace('\\', '\\\\').replace('"', '\\"')


for dil, metinler in M.items():
    yol = os.path.join(KOK, 'app_%s.arb' % dil)
    s = io.open(yol, encoding='utf-8', newline='').read()

    if ANAHTARLAR[0] in s:
        print('%-4s zaten var, atlandi' % dil)
        continue

    satirler = s.splitlines(True)
    hedef = None
    for i, l in enumerate(satirler):
        if '"%s"' % KOSU in l:
            hedef = i
            break

    if hedef is None:
        print('%-4s HATA: %s bulunamadi' % (dil, KOSU))
        continue

    satir = satirler[hedef]
    if not satir.rstrip().endswith(','):
        satirler[hedef] = satir.rstrip() + ',\n'
        satir = satirler[hedef]

    girinti = satir[:len(satir) - len(satir.lstrip())]
    yeni = []
    for anahtar, deger in zip(ANAHTARLAR, metinler):
        yeni.append('%s"%s": "%s",\n' % (girinti, anahtar, kaçış(deger)))

    satirler[hedef + 1:hedef + 1] = yeni
    io.open(yol, 'w', encoding='utf-8', newline='').write(''.join(satirler))
    print('%-4s eklendi: %s' % (dil, ', '.join(ANAHTARLAR)))
