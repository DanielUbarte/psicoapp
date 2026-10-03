# PSICOAPP 🧠📱❤️

> **“Conoce tu mente. Cuida de ti.”**

**PSICOAPP** es una aplicación móvil de bienestar emocional y educación psicológica desarrollada con **Flutter y Dart**, utilizando los principios de diseño de **Material 3**. 

Permite a los usuarios registrar sus emociones, llevar un diario emocional, realizar retos de autoestima de 7 días, acceder a una caja de herramientas de autocuidado, consultar artículos de psicoeducación, utilizar un modo SOS de emergencia y revisar su progreso personal.

---

> ⚠️ **Aviso Importante**: PSICOAPP es una herramienta educativa y de bienestar emocional. No realiza diagnósticos psicológicos y no sustituye la atención de psicólogos, psiquiatras u otros profesionales de salud mental.

---

## 🛠️ Tecnologías

* **Flutter & Dart** (Base de código única para Android e iOS)
* **Material 3** para diseño visual moderno y limpio
* **SharedPreferences** para almacenamiento local seguro de datos
* **Intl** para formateo de fechas en español
* Preparado para integración futura con **Firebase Authentication**, **Cloud Firestore** y **In-App Purchases**.

---

## 📁 Estructura del Proyecto

```text
psicoapp/
├── android/                   # Archivos nativos para Android
├── ios/                       # Archivos nativos para iOS
├── lib/
│   ├── main.dart              # Punto de entrada de la aplicación
│   ├── models/                # Clases de modelos Dart (User, EmotionEntry, Challenge, Tool, Article)
│   ├── screens/               # Pantallas completas de la aplicación (Splash, Login, Register, Home, etc.)
│   ├── widgets/               # Widgets reutilizables (Logo, CustomButton, EmotionCard, ToolCard, etc.)
│   ├── services/              # Servicios de datos y lógica de negocio (StorageService, AuthService)
│   ├── theme/                 # Tema global Material 3 y paleta de colores (AppTheme)
│   └── utils/                 # Constantes y utilidades del proyecto
├── pubspec.yaml               # Configuración de dependencias
└── README.md                  # Documentación del proyecto
```

---

## 🚀 Requisitos e Instalación

### 1. Clonar o abrir el proyecto
Abre el proyecto desde **Visual Studio** o VS Code en la carpeta `psicoapp`.

### 2. Instalar dependencias
En la terminal integrada, ejecuta:

```bash
flutter pub get
```

---

## 📱 Ejecutar en Android (desde Windows / macOS / Linux)

Para ejecutar la aplicación en Android:

1. Inicia un emulador de Android desde Android Studio o conecta un dispositivo Android físico con depuración USB habilitada.
2. Ejecuta:

```bash
flutter run
```

---

## 🍎 Ejecutar en iOS (Compatibilidad Multiplataforma)

El código Dart de PSICOAPP es **100% multiplataforma** y no depende de funciones exclusivas de Android.

### Requisitos para compilar iOS:
* **Sistema Operativo**: macOS.
* **Herramientas de Desarrollo**: Xcode e iOS SDK.
* **Simulador**: Simulador de iPhone o dispositivo Apple físico.

### Instrucciones para ejecutar en iOS (desde macOS):
1. Abre la terminal en macOS dentro de la carpeta `psicoapp`.
2. Ejecuta `flutter pub get`.
3. Inicia el simulador de iOS:
   ```bash
   open -a Simulator
   ```
4. Ejecuta la aplicación:
   ```bash
   flutter run
   ```
5. Para compilar y firmar la versión de distribución para App Store, se requiere la cuenta de desarrollador de Apple en Xcode.

---

## ✨ Funciones Actuales

1. **Splash Screen (`SplashScreen`)**: Pantalla de bienvenida con el logo de PSICOAPP (🧠+📱+❤️), animación suave y redirección automática según sesión activa.
2. **Inicio de sesión (`LoginScreen`)**: Autenticación simulada local con validaciones de formulario y recuperación de contraseña.
3. **Crear cuenta (`RegisterScreen`)**: Registro de nuevos usuarios con validaciones de campos y casilla obligatoria de aceptación de políticas.
4. **Política de privacidad (`PrivacyPolicyScreen`)**: Detalle completo sobre el manejo confidencial de registros emocionales y el aviso de exención médica.
5. **Pantalla de inicio (`HomeScreen`)**: Dashboard principal con tarjeta de bienvenida personalizada y selector interactivo de emociones (Feliz, Tranquilo/a, Triste, Enojado/a, Ansioso/a, Neutral).
6. **Registro de emoción (`EmotionScreen`)**: Selector de intensidad (1 a 5), preguntas guía ("¿Qué ocurrió?", "¿Qué pensaste?", "¿Qué hiciste?") y sugerencias de herramientas.
7. **Diario emocional (`JournalScreen`)**: Historial cronológico de registros con visualización detallada, eliminación y opción de agregar entradas.
8. **Retos psicológicos (`ChallengesScreen`)**: 🌱 **Reto de 7 Días de Autoestima** con seguimiento interactivo, barra de progreso y celebración al completar 🏆.
9. **Caja de herramientas (`ToolsScreen`)**: 5 herramientas interactivas guiadas (Respiración 4-4-4 con temporizador animado, regulación de enojo, círculo de control, espacio de catarsis y pausas de enfoque).
10. **PsicoEduca (`PsychoEducationScreen`)**: Artículos educativos por categorías (Ansiedad, Autoestima, Emociones, Estrés, Asertividad, Relaciones y Hábitos), buscador por palabras clave y tarjetas de "Mito vs. Realidad".
11. **Modo SOS emocional (`SosModal`)**: Botón flotante 🆘 **SOS** accesible en pantallas principales para desescalada rápida de crisis y referencias a líneas de apoyo telefónico.
12. **Perfil (`ProfileScreen`)**: Datos del usuario, resumen estadístico, cambios de contraseña, consulta de políticas, cierre de sesión y eliminación completa de cuenta.
13. **PSICOAPP Premium (`PremiumScreen`)**: Comparativa de planes (Gratuito vs. Premium) e interfaz de suscripción preparada para compras in-app.

---

## 🧪 Verificación de Código

Para verificar que el proyecto no contiene advertencias ni errores de síntaxis o compilación:

```bash
flutter analyze
```
