import java.util.Properties
import java.io.FileInputStream


plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

val localProperties = Properties()
val localPropertiesFile = rootProject.projectDir.resolve("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { 
        localProperties.load(it) 
    }
}

android {
    namespace = "com.heeyun.hangangbus"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.heeyun.hangangbus"
        minSdk = 24
        targetSdk = 36
        versionCode = 11
        versionName = "1.0"
        
        // Manifest 에러 해결용
        addManifestPlaceholders(mapOf("applicationName" to "android.app.Application"))
        manifestPlaceholders["KAKAO_APP_KEY"] = localProperties.getProperty("KAKAO_APP_KEY") ?: ""
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }
}

dependencies {
    // ⚠️ 직접 JAR 파일이나 버전을 적는 대신, 
    // 프로젝트 수준에서 이미 정의된 플러그인을 통해 라이브러리를 가져와야 합니다.
    implementation("org.jetbrains.kotlin:kotlin-stdlib")
}

// ✅ 이 부분이 핵심입니다! 
// Flutter 엔진과 플러그인들을 프로젝트에 연결해주는 자동 설정입니다.
flutter {
    source = "../.."
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }
}
