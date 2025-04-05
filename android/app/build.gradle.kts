plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ✅ Firebase plugin
}

android {
    namespace = "com.example.lifelink"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "25.2.9519653"


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
    applicationId = "com.example.lifelink"
    minSdk = 21
    targetSdk = 34
    versionCode = 1
    versionName = "1.0"

    manifestPlaceholders["MAPS_API_KEY"] = project.findProperty("MAPS_API_KEY") as String
}


    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
