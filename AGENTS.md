# AGENTS.md — KanaCrono

## Descripción general

KanaCrono es una aplicación para practicar los silabarios japoneses (hiragana y katakana). Muestra un carácter kana y su lectura en rōmaji de forma aleatoria, cambiando automáticamente cada cierto número de segundos. Está disponible en el [App Store](https://apps.apple.com/es/app/kanacrono/id1545750188) y en [Google Play](https://play.google.com/store/apps/details?id=com.jaureguialzo.kanacrono).

## Estructura del repositorio

```
kana-crono/
├── KanaCrono/          # Aplicación iOS (SwiftUI) — referencia de funcionalidad y diseño
├── KanaCronoAndroid/   # Aplicación Android (Kotlin, Views) — desactualizada, pendiente de renovación
└── artwork/            # Recursos gráficos (icono, paleta de color)
```

## Plataforma de referencia: iOS (`KanaCrono/`)

La aplicación iOS es la versión canónica. Cualquier nueva funcionalidad o corrección debe implementarse primero aquí.

### Tecnología

- **Lenguaje:** Swift
- **UI:** SwiftUI
- **Patrón:** MVVM — `ViewModel.swift` es el único `ObservableObject`, inyectado como `@EnvironmentObject` en toda la jerarquía de vistas.
- **Persistencia de ajustes:** `@AppStorage` (UserDefaults).
- **Audio:** `AVSpeechSynthesizer` con voz `ja-JP`.
- **Localización:** inglés (`en`) y español (`es`) mediante `.strings` y `.stringsdict`.

### Estructura de ficheros iOS

```
KanaCrono/KanaCrono/
├── KanaCronoApp.swift          # Punto de entrada (@main), instancia ViewModel
├── ContentView.swift           # Vista principal, adaptativa (portrait/landscape)
├── ViewModel.swift             # Estado global: kana actual, temporizador, ajustes
├── Silabarios.swift            # Datos de los silabarios y lógica de selección aleatoria
├── Settings.swift              # Pantalla de ajustes (sheet modal)
├── Componentes/
│   ├── Kana.swift              # Muestra el carácter kana; tap para revelar o avanzar
│   ├── Romaji.swift            # Muestra la lectura en rōmaji
│   ├── Reloj.swift             # Temporizador con botones pausa y siguiente
│   ├── BotonAjustes.swift      # Botón que abre Settings
│   ├── Selectores.swift        # Pickers de silabario y nivel
│   ├── SelectorFuente.swift    # Picker de fuente (Normal / Cursiva)
│   ├── OpcionesVisibilidad.swift  # Toggles Kana / Rōmaji / Audio
│   └── StepperSegundos.swift   # Stepper para el intervalo del temporizador
└── Fuentes/
    └── Kyokasho.ttc            # Fuente cursiva japonesa (YuKyo-Medium)
```

### Datos de los silabarios (`Silabarios.swift`)

Los kana están organizados en diccionarios `[String: String]` (kana → rōmaji):

| Constante             | Contenido                         | Entradas |
|-----------------------|-----------------------------------|----------|
| `hiragana_basico`     | Hiragana básico                   | 46       |
| `hiragana_tenten`     | Hiragana con diacríticos          | 25       |
| `hiragana_compuestos` | Hiragana compuesto (dígrafos)     | 33       |
| `katakana_basico`     | Katakana básico                   | 46       |
| `katakana_tenten`     | Katakana con diacríticos          | 25       |
| `katakana_compuestos` | Katakana compuesto (dígrafos)     | 33       |
| `katakana_extra`      | Katakana para sonidos extranjeros | 19       |

Los niveles son acumulativos: `tenten` incluye `basico`; `compuestos` incluye `basico` + `tenten`. El nivel `extra` solo existe para katakana. La función `tuplasKana(cantidad:_:nivel:)` devuelve tuplas `(kana, romaji)` sin repetición de lectura.

### Lógica de visibilidad

- Los ajustes `verKana`, `verRomaji` y `audio` controlan qué se muestra y si se lee en voz alta.
- Al tocar el kana o el rōmaji cuando alguno está oculto, se revelan temporalmente (`verKanaTemporal`, `verRomajiTemporal`) hasta el siguiente cambio.
- Si los tres ajustes se desactivaran simultáneamente, la lógica de `todosOff()` fuerza al menos dos activados.
- Al llegar a 0, el temporizador también revela kana y rōmaji antes de cambiar.

### Comportamiento del temporizador

- Cuenta regresiva en segundos (1–60, por defecto 5).
- Botón pausa/play y botón de avance manual.
- Cambiar de silabario o nivel reinicia el temporizador y genera un nuevo kana.
- Al avanzar, siempre se genera un kana distinto al anterior.

---

## Plataforma Android (`KanaCronoAndroid/`)

> **Estado: desactualizada.** La versión Android está muy por detrás en funcionalidad y diseño respecto a iOS. No realizar cambios en esta plataforma hasta que se aborde su renovación completa.

- **Lenguaje:** Kotlin
- **UI:** Android Views (XML layouts), `AppCompatActivity`
- **Arquitectura:** lógica en `MainActivity.kt`, sin separación MVVM
- **Diferencias funcionales respecto a iOS:**
  - No tiene nivel `extra` (solo básico, diacríticos y dígrafos)
  - No tiene selector de fuente
  - Los ajustes no se persisten entre sesiones
  - UI basada en `RadioGroup`, `Switch` y `NumberPicker` en lugar de componentes SwiftUI equivalentes

---

## Compilación y verificación

Antes de crear un commit con cambios en el código, compilar la plataforma afectada y confirmar que no hay errores ni advertencias nuevas.

### iOS

```bash
xcodebuild -project KanaCrono/KanaCrono.xcodeproj \
           -scheme KanaCrono \
           -destination 'generic/platform=iOS' \
           build
```

La salida debe terminar con `** BUILD SUCCEEDED **`.

### Android

```bash
cd KanaCronoAndroid && ./gradlew assembleDebug
```

La salida debe terminar con `BUILD SUCCESSFUL`.

---

## Convenciones del proyecto

- Los identificadores de código están en **español** (p. ej. `silabarioSeleccionado`, `segundos`, `verKana`).
- Las cadenas de localización usan claves en **inglés en mayúsculas** (p. ej. `"SETTINGS_TITLE"`, `"LEVEL_BASIC"`).
- Los ficheros de idioma son `en.lproj` (inglés) y `es.lproj` (español); ambos deben mantenerse sincronizados al añadir cadenas.
- Cada componente SwiftUI incluye su propio `PreviewProvider` con un `_CustomPreview` que inyecta `ViewModel()` manualmente.
- No hay tests unitarios activos; solo existe el scaffolding de `KanaCronoUITests`.
