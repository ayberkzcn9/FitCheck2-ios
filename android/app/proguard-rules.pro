# ============================================================
# FITCHECK - R8 / PROGUARD KURALLARI
# ============================================================
#
# ⚠️  Buraya genişletilmiş "keep" kuralları EKLEMEYİN.
#
#     Örnek (YANLIŞ):
#         -keep class com.google.firebase.** { *; }
#         -keep class com.google.android.gms.** { *; }
#         -keep class kotlin.** { *; }
#
#     Bu tür kurallar R8'in kod daraltma (shrink) ve karartma
#     (obfuscation) yapmasını engeller; Play Console'daki
#     "Optimizasyon / Kod karartma / Daraltma" yüzdelerini düşürür.
#
#     Şu bileşenler gereken ProGuard kurallarını kendi AAR'ları
#     içinde (consumer rules) zaten taşır:
#       • Flutter embedding  (flutter_proguard_rules.pro otomatik eklenir)
#       • Firebase (Auth, Firestore, Storage, Analytics, Messaging)
#       • Google Play Services / AdMob / User Messaging Platform
#       • AndroidX (Lifecycle, Room, WorkManager, Startup, Play Core)
#       • Kotlin stdlib ve MLKit
#
#     Varsayılan "proguard-android-optimize.txt" dosyası da şunları korur:
#       • @androidx.annotation.Keep ile işaretli sınıf ve üyeler
#       • native <methods>, View setter'ları, Activity onClick metotları
#       • enum values()/valueOf() ve Parcelable CREATOR alanları
#
#     Not: flutter_local_notifications veri modelleri @Keep ile
#     işaretli olduğundan Gson reflection'ı otomatik olarak güvendedir.
# ============================================================


# ------------------------------------------------------------
# Build uyarılarını sustur (optimizasyonu etkilemez)
# ------------------------------------------------------------
-dontwarn io.flutter.plugin.**
-dontwarn com.google.android.play.core.**
-dontwarn java.lang.invoke.**
-dontwarn java.time.**


# ------------------------------------------------------------
# Reflection / serileştirme (Gson, Firestore, Room) için
# gerekli sınıf metadata'sı
# ------------------------------------------------------------
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod


# ------------------------------------------------------------
# ROOM
# Room, veritabanı implementasyonunu (<Ad>_Impl) ismiyle yükler.
# Sadece RoomDatabase türevleri korunur; kütüphanenin geri kalanı
# daraltılır ve karartılır.
# ------------------------------------------------------------
-keep class * extends androidx.room.RoomDatabase { *; }


# ------------------------------------------------------------
# R8 FULL MODE DESTEK
# Sadece gerekli minimum reflection korumaları
# ------------------------------------------------------------
# Firebase Auth/Firestore entry points
-keep class com.google.firebase.auth.FirebaseAuth { *; }
-keep class com.google.firebase.firestore.FirebaseFirestore { *; }
-keep class com.google.firebase.analytics.FirebaseAnalytics { *; }
