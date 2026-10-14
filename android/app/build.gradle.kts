import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    // 🔥 Firebase Google Services Eklentisi
    id("com.google.gms.google-services")
}

// 🔑 key.properties dosyasını okuma ayarları
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.fitcheck2.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // 🔥 Desugaring desteği
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.fitcheck2.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // 🔥 MultiDex desteği
        multiDexEnabled = true 
    }

    // 🔐 Gerçek imzalama konfigürasyonu
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            // 💥 "release" imzası bağlandı
            signingConfig = signingConfigs.getByName("release")
            
            // 🛠️ R8 / ProGuard Çökme Önleyici Ayarlar (S23 gibi yeni cihazlar için zırh)
            isMinifyEnabled = true
            isShrinkResources = true
            
            // 🚀 R8 Full Mode - daha agresif optimizasyon ve karartma
            // Dikkat: reflection kullanan kodlar için test gerekir
            // proguardFiles'e "-android:full" eklenir
            
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

// 🔥 Desugaring kütüphanesi bağımlılığı
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}