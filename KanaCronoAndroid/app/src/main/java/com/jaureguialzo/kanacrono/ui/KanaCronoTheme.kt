package com.jaureguialzo.kanacrono.ui

import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext

/**
 * Tema de Compose que replica los colores exactos del iOS.
 * Light: Fondo #FFCC00, Acento #3F628C
 * Dark: Fondo #3F628C, Acento #FFCC00
 */

// Colores exactos del iOS (Fondo.colorset y AccentColor.colorset)
private val KanaFondoLight = Color(0xFFFFCC00)  // #FFCC00
private val KanaAccentLight = Color(0xFF3F628C)  // #3F628C
private val KanaFondoDark = Color(0xFF3F628C)    // #3F628C (dark mode)
private val KanaAccentDark = Color(0xFFFFCC00)   // #FFCC00 (dark mode)

private val LightColorScheme = lightColorScheme(
    primary = KanaAccentLight,
    secondary = KanaFondoLight,
    tertiary = KanaAccentLight,

    // Background: el fondo de la app es del color "Fondo"
    background = KanaFondoLight,
    surface = KanaFondoLight,

    // On colors
    onPrimary = Color.White,
    onSecondary = Color.Black,
    onTertiary = Color.White,
    onBackground = Color.Black,
    onSurface = Color.Black,

    // Surface variants for UI elements
    surfaceVariant = KanaAccentLight.copy(alpha = 0.15f),
    outlineVariant = KanaAccentLight.copy(alpha = 0.3f),

    // Error (no se usa pero necesario)
    error = Color(0xFFB3261E),
    onError = Color.White,
)

private val DarkColorScheme = darkColorScheme(
    primary = KanaFondoDark,
    secondary = KanaAccentDark,
    tertiary = KanaFondoDark,

    // Background: el fondo de la app es del color "Fondo" dark
    background = KanaFondoDark,
    surface = KanaFondoDark,

    // On colors (invertidos en dark mode)
    onPrimary = Color.Black,
    onSecondary = Color.White,
    onTertiary = Color.Black,
    onBackground = Color.White,
    onSurface = Color.White,

    // Surface variants for UI elements
    surfaceVariant = KanaAccentDark.copy(alpha = 0.15f),
    outlineVariant = KanaAccentDark.copy(alpha = 0.3f),

    // Error
    error = Color(0xFFFFB4AB),
    onError = Color.Black,
)

/**
 * Tema principal de KanaCrono para Jetpack Compose.
 */
@Composable
fun KanaCronoTheme(
    darkTheme: Boolean = android.content.res.Configuration.UI_MODE_NIGHT_YES == LocalContext.current.resources.configuration.uiMode and android.content.res.Configuration.UI_MODE_NIGHT_MASK,
    content: @Composable () -> Unit
) {
    val colorScheme = if (darkTheme) DarkColorScheme else LightColorScheme

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography(),
        content = content
    )
}
