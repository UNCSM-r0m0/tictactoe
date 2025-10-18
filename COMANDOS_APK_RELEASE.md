# 📦 Comandos para Generar APK Release

## 🚀 Proceso Completo (Paso a Paso)

### 1️⃣ Limpiar el Proyecto

```bash
flutter clean
```

**¿Qué hace?** Elimina archivos de compilación anteriores.

---

### 🔧 **SOLUCIÓN: Error de Kotlin Daemon al compilar Release**

Si obtienes un error como:

```
Daemon compilation failed: null
Could not close incremental caches
this and base files have different roots
```

**Sigue estos pasos:**

#### **Opción 1: Limpieza Completa (Recomendado)**

```bash
# 1. Limpiar Flutter
flutter clean

# 2. Limpiar Gradle (ejecutar en PowerShell)
cd android
./gradlew clean
cd ..

# 3. Eliminar caché de compilación
Remove-Item -Recurse -Force build

# 4. Eliminar caché de Gradle (opcional pero efectivo)
Remove-Item -Recurse -Force android\.gradle

# 5. Eliminar caché del plugin audioplayers
Remove-Item -Recurse -Force build\audioplayers_android

# 6. Obtener dependencias
flutter pub get

# 7. Compilar
flutter build apk --release
```

#### **Opción 2: Limpieza Rápida**

```bash
# Limpiar todo y recompilar
flutter clean && flutter pub get && flutter build apk --release
```

#### **Opción 3: Si persiste el error**

```bash
# 1. Limpiar caché completo de Flutter
flutter clean

# 2. Limpiar caché de Pub
flutter pub cache clean

# 3. Invalidar caché de Gradle
cd android
./gradlew cleanBuildCache
cd ..

# 4. Recompilar
flutter pub get
flutter build apk --release
```

---

### 2️⃣ Obtener Dependencias

```bash
flutter pub get
```

**¿Qué hace?** Descarga e instala todas las dependencias del proyecto.

---

### 3️⃣ Generar APK Universal (Recomendado)

```bash
flutter build apk --release
```

**¿Qué hace?** Genera un APK que funciona en todos los dispositivos Android.
**Resultado:** `build/app/outputs/flutter-apk/app-release.apk` (~42 MB)

---

### 4️⃣ Generar APKs por Arquitectura (Opcional - Más Pequeños)

```bash
flutter build apk --split-per-abi --release
```

**¿Qué hace?** Genera 3 APKs separados, uno para cada arquitectura.
**Resultado:**

- `app-arm64-v8a-release.apk` (~15 MB) - Dispositivos modernos
- `app-armeabi-v7a-release.apk` (~13 MB) - Dispositivos antiguos
- `app-x86_64-release.apk` (~17 MB) - Emuladores/Tablets

---

### 5️⃣ Verificar APKs Generados

```bash
dir build\app\outputs\flutter-apk\*.apk
```

**¿Qué hace?** Muestra la lista de APKs generados con su tamaño.

---

## ⚡ COMANDO RÁPIDO TODO EN UNO

```bash
flutter clean && flutter pub get && flutter build apk --release && flutter build apk --split-per-abi --release
```

---

## 📋 Comandos Adicionales Útiles

### Verificar Estado del Proyecto

```bash
flutter doctor
```

### Ver Tamaño Detallado del APK

```bash
flutter build apk --release --analyze-size
```

### Generar APK con Ofuscación (Más Seguro)

```bash
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

### Generar App Bundle para Google Play (Mejor que APK)

```bash
flutter build appbundle --release
```

---

## 📱 Instalar APK en Dispositivo Conectado

### Instalar APK Universal

```bash
adb install build\app\outputs\flutter-apk\app-release.apk
```

### Instalar APK Específico (ARM64)

```bash
adb install build\app\outputs\flutter-apk\app-arm64-v8a-release.apk
```

---

## 🗂️ Ubicación de los APKs

Todos los APKs se generan en:

```
D:\WORKSPACES\FLUTTER\tictactoe\build\app\outputs\flutter-apk\
```

Archivos generados:

- ✅ `app-release.apk` - APK universal (usar este para distribución general)
- ✅ `app-arm64-v8a-release.apk` - Para Samsung, Pixel, OnePlus, etc.
- ✅ `app-armeabi-v7a-release.apk` - Para dispositivos antiguos
- ✅ `app-x86_64-release.apk` - Para emuladores

---

## 🎯 Recomendaciones

### Para Distribución Directa (APK)

1. Usa el **APK universal** (`app-release.apk`)
2. Funciona en todos los dispositivos
3. Más fácil de compartir

### Para Google Play Store

1. Usa **App Bundle** en lugar de APK:
   ```bash
   flutter build appbundle --release
   ```
2. Google Play optimiza automáticamente para cada dispositivo
3. Usuarios descargan menos datos

### Para Usuarios Avanzados

1. Ofrece los APKs por arquitectura
2. Usuarios descargan versiones más pequeñas
3. Mejor experiencia de descarga

---

## 🔒 Firmar APK (Para Publicación)

Si necesitas firmar el APK para Google Play:

1. Crear keystore:

```bash
keytool -genkey -v -keystore ~/tictactoe-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias tictactoe
```

2. Configurar en `android/key.properties`

3. Compilar APK firmado:

```bash
flutter build apk --release
```

---

## ✅ Checklist Pre-Compilación

Antes de generar el APK de release, verifica:

- [ ] Todas las funcionalidades funcionan correctamente
- [ ] No hay errores de linter: `flutter analyze`
- [ ] Las pruebas pasan: `flutter test`
- [ ] El ícono de la app está configurado
- [ ] El splash screen se ve bien
- [ ] La versión está actualizada en `pubspec.yaml`
- [ ] El nombre de la app es correcto en `AndroidManifest.xml`

---

## 🎮 Tu Proyecto Actual

**Nombre:** Tic Tac Toe  
**Package:** com.r0lm0.tictactoe  
**Versión:** 1.0.0  
**Tamaño APK:** ~42 MB (universal), ~15 MB (ARM64)

**Características:**
✅ Juego vs IA (3 dificultades)
✅ Modo 2 jugadores
✅ Sistema de estadísticas con SQLite
✅ Splash screen premium
✅ Ícono optimizado para circular
✅ UI responsiva y moderna

---

## 🚨 Solución de Problemas

### Error: "Gradle task assembleRelease failed"

```bash
flutter clean
flutter pub get
flutter build apk --release
```

### APK muy grande

```bash
flutter build apk --split-per-abi --release
```

### Verificar firma del APK

```bash
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk
```

---

## 📞 Comandos de Ayuda

```bash
flutter build apk --help        # Ver todas las opciones de build
flutter doctor -v               # Diagnóstico completo
flutter pub outdated            # Ver paquetes desactualizados
```

---

## 🎉 ¡Listo!

Después de ejecutar estos comandos, tus APKs estarán listos para:

- ✅ Compartir con amigos
- ✅ Subir a Google Play Store
- ✅ Distribuir en tu sitio web
- ✅ Testing en dispositivos reales

**¡Tu Tic Tac Toe Premium está listo para el mundo! 🎮✨**
