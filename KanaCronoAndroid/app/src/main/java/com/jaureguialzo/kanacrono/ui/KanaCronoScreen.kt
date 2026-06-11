package com.jaureguialzo.kanacrono.ui

import android.content.Context
import android.speech.tts.TextToSpeech
import android.util.Log
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.jaureguialzo.kanacrono.data.Fuente
import com.jaureguialzo.kanacrono.data.Nivel
import com.jaureguialzo.kanacrono.data.Silabario

/**
 * Carga la fuente cursiva Kyokasho desde assets (como YuKyo-Medium en iOS).
 */
@Composable
private fun getKyokashoFontFamily(): FontFamily {
    return FontFamily(
        Font(
            path = "fonts/kyokasho.ttf",
            assetManager = LocalContext.current.assets,
            weight = FontWeight.Medium
        )
    )
}

/**
 * Helper para resolver strings de recursos por nombre (bypass del R class en AGP 9.0).
 */
private fun Context.getStringByName(name: String): String {
    val resId = resources.getIdentifier(name, "string", packageName)
    return if (resId != 0) getString(resId) else "[$name]"
}

/**
 * Pantalla principal de KanaCrono.
 * Adaptativa: portrait (vertical) y landscape (horizontal).
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun KanaCronoScreen(
    viewModel: KanaCronoViewModel = viewModel()
) {
    val context = LocalContext.current

    // Settings state
    var showSettings by remember { mutableStateOf(false) }

    KanaCronoContent(
        viewModel = viewModel,
        context = context,
        showSettings = showSettings,
        onShowSettingsChange = { showSettings = it }
    )

    // Settings bottom sheet
    if (showSettings) {
        ModalBottomSheet(
            onDismissRequest = { showSettings = false },
            dragHandle = { SettingsDragHandle() }
        ) {
            val getString: (String) -> String = { context.getStringByName(it) }
            SettingsContent(
                getString = getString,
                viewModel = viewModel,
                onDismiss = { showSettings = false }
            )
        }
    }
}

@Composable
private fun SettingsDragHandle() {
    Box(
        modifier = Modifier
            .padding(top = 12.dp)
            .size(36.dp, 4.dp)
            .clip(RoundedCornerShape(2.dp))
            .background(MaterialTheme.colorScheme.outlineVariant),
        contentAlignment = Alignment.Center
    ) {}
}

@Composable
private fun KanaCronoContent(
    viewModel: KanaCronoViewModel,
    context: android.content.Context,
    showSettings: Boolean,
    onShowSettingsChange: (Boolean) -> Unit
) {
    val width = context.resources.displayMetrics.widthPixels.toFloat()
    val height = context.resources.displayMetrics.heightPixels.toFloat()
    val isLandscape = width > height

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(androidx.compose.ui.graphics.Color.White)
            .padding(horizontal = 16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = if (isLandscape) Arrangement.SpaceEvenly else Arrangement.Center
    ) {
        // Timer bar (top in both orientations)
        TimerBar(viewModel = viewModel)

        Spacer(modifier = if (isLandscape) Modifier.weight(1f) else Modifier.height(8.dp))

        // Main content: Kana + Romaji
        if (isLandscape) {
            // Landscape: side by side (como iOS portrait en landscape)
            Row(
                horizontalArrangement = Arrangement.spacedBy(16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                KanaDisplay(viewModel = viewModel)
                RomajiDisplay(viewModel = viewModel)
            }
        } else {
            // Portrait: stacked (como iOS portrait en portrait)
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                KanaDisplay(viewModel = viewModel)
                RomajiDisplay(viewModel = viewModel)
            }
        }

        Spacer(modifier = if (isLandscape) Modifier.weight(1f) else Modifier.height(8.dp))

        // Settings button (bottom)
        val getString: (String) -> String = { context.getStringByName(it) }
        SettingsButton(onClick = { onShowSettingsChange(true) }, getString = getString)
    }

    // Audio playback when kana changes and audio is enabled
    var lastSpokenKana by remember { mutableStateOf<String?>(null) }

    LaunchedEffect(viewModel.audioKanaToSpeak, lastSpokenKana) {
        val kana = viewModel.audioKanaToSpeak
        if (kana != null && kana != lastSpokenKana) {
            try {
                var ttsObj: TextToSpeech? = null

                ttsObj = TextToSpeech(context) { status ->
                    if (status == TextToSpeech.SUCCESS) {
                        val result = ttsObj!!.setLanguage(java.util.Locale.JAPANESE)
                        if (result != TextToSpeech.LANG_MISSING_DATA &&
                            result != TextToSpeech.LANG_NOT_SUPPORTED) {
                            ttsObj!!.setSpeechRate(0.5f) // AVSpeechUtteranceMinimumSpeechRate
                            ttsObj!!.speak(kana, TextToSpeech.QUEUE_FLUSH, null, "")
                        }
                    }
                }

                lastSpokenKana = kana

                // Shutdown after speaking (short delay)
                android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                    ttsObj!!.stop()
                    ttsObj!!.shutdown()
                }, 1500)
            } catch (e: Exception) {
                Log.e("KanaCrono", "Audio error", e)
            }
        }
    }
}

// MARK: - Timer Bar (como Reloj en iOS)

@Composable
private fun TimerBar(viewModel: KanaCronoViewModel) {
    val time = viewModel.timeRemaining
    val running = viewModel.timerRunning

    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceEvenly,
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Play/Pause button (como en iOS)
        IconButton(
            onClick = { viewModel.toggleTimerRunning() },
            modifier = Modifier.size(40.dp)
        ) {
            Icon(
                imageVector = if (running) Icons.Default.Pause else Icons.Default.PlayArrow,
                contentDescription = if (running) "Pause" else "Play",
                tint = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.size(28.dp)
            )
        }

        // Timer display (tap to reveal all)
        Text(
            text = "$time",
            fontSize = 36.sp,
            fontWeight = FontWeight.Medium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.clickable(onClick = {
                viewModel.revelarTodoTemporal()
            })
        )

        // Next/Skip button (como forward.fill en iOS)
        IconButton(
            onClick = { viewModel.avanzarKana() },
            modifier = Modifier.size(40.dp)
        ) {
            Icon(
                imageVector = Icons.Default.SkipNext,
                contentDescription = "Next",
                tint = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.size(28.dp)
            )
        }
    }
}

// MARK: - Kana Display (como Kana en iOS)

@Composable
private fun KanaDisplay(viewModel: KanaCronoViewModel) {
    val kana = viewModel.kana
    val visible = viewModel.verKana || viewModel.verKanaTemporal

    val screenWidth = LocalContext.current.resources.displayMetrics.widthPixels.toFloat()
    val screenHeight = LocalContext.current.resources.displayMetrics.heightPixels.toFloat()

    // Size: 66% of the smaller screen dimension, capped to leave room for romaji (como iOS)
    val size = if (screenWidth > screenHeight) {
        (screenHeight * 0.66).dp.coerceAtMost(280.dp)
    } else {
        (screenWidth * 0.66).dp.coerceAtMost(280.dp)
    }

    val isDark = LocalContext.current.isDarkTheme()

    Box(
        modifier = Modifier
            .size(size)
            .clip(RoundedCornerShape(10.dp))
            .background(
                color = if (isDark) androidx.compose.ui.graphics.Color(0xFF3F628C)
                        else androidx.compose.ui.graphics.Color(0xFFFFCC00)
            )
            .alpha(if (visible) 1f else 0f)
            .clickable(onClick = {
                if (viewModel.todoVisible()) {
                    viewModel.reiniciarReloj()
                    viewModel.nuevoKana()
                } else {
                    viewModel.revelarKanaTemporal()
                }
            }),
        contentAlignment = Alignment.Center
    ) {
        Text(
            text = kana,
            fontFamily = if (viewModel.fuenteSeleccionada == Fuente.cursiva) getKyokashoFontFamily() else null,
            fontSize = 100.sp,
            fontWeight = FontWeight.Medium,
            color = MaterialTheme.colorScheme.onSurface,
        )
    }
}

// MARK: - Romaji Display (como Romaji en iOS)

@Composable
private fun RomajiDisplay(viewModel: KanaCronoViewModel) {
    val romaji = viewModel.romaji
    val visible = viewModel.verRomaji || viewModel.verRomajiTemporal

    val screenWidth = LocalContext.current.resources.displayMetrics.widthPixels.toFloat()
    val screenHeight = LocalContext.current.resources.displayMetrics.heightPixels.toFloat()

    // Size: 66% of the smaller screen dimension, capped to leave room for romaji (como iOS)
    val size = if (screenWidth > screenHeight) {
        (screenHeight * 0.66).dp.coerceAtMost(280.dp)
    } else {
        (screenWidth * 0.66).dp.coerceAtMost(280.dp)
    }

    val isDark = LocalContext.current.isDarkTheme()

    Box(
        modifier = Modifier
            .size(size)
            .clip(RoundedCornerShape(10.dp))
            .background(
                color = if (isDark) androidx.compose.ui.graphics.Color(0xFFFFCC00)
                        else androidx.compose.ui.graphics.Color(0xFF3F628C)
            )
            .alpha(if (visible) 1f else 0f)
            .clickable(onClick = {
                if (viewModel.todoVisible()) {
                    viewModel.reiniciarReloj()
                    viewModel.nuevoKana()
                } else {
                    viewModel.revelarRomajiTemporal()
                }
            }),
        contentAlignment = Alignment.Center
    ) {
        Text(
            text = romaji,
            fontSize = 50.sp,
            color = MaterialTheme.colorScheme.onSurface,
        )
    }
}

// MARK: - Settings Button (como BotonAjustes en iOS)

@Composable
private fun SettingsButton(onClick: () -> Unit, getString: (String) -> String) {
    IconButton(
        onClick = onClick,
        modifier = Modifier.padding(bottom = 16.dp)
    ) {
        Icon(
            imageVector = Icons.Default.Settings,
            contentDescription = getString("settings_close"),
            tint = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.size(28.dp)
        )
    }
}

// MARK: - Settings Content (como Settings en iOS)

@Composable
private fun SettingsContent(
    getString: (String) -> String,
    viewModel: KanaCronoViewModel,
    onDismiss: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp)
    ) {
        // Syllabary section (como Selectores en iOS)
        Text(
            text = getString("settings_syllabary"),
            style = MaterialTheme.typography.titleSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(vertical = 8.dp)
        )

        SyllabarySelector(getString = getString, viewModel = viewModel)

        Spacer(modifier = Modifier.height(16.dp))

        // Font section (como SelectorFuente en iOS)
        Text(
            text = getString("settings_font"),
            style = MaterialTheme.typography.titleSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(vertical = 8.dp)
        )

        FontSelector(getString = getString, viewModel = viewModel)

        Spacer(modifier = Modifier.height(16.dp))

        // Visibility section (como OpcionesVisibilidad en iOS)
        Text(
            text = getString("settings_visibility"),
            style = MaterialTheme.typography.titleSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(vertical = 8.dp)
        )

        VisibilityOptions(getString = getString, viewModel = viewModel)

        Spacer(modifier = Modifier.height(16.dp))

        // Timer section (como StepperSegundos en iOS)
        Text(
            text = getString("settings_time"),
            style = MaterialTheme.typography.titleSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(vertical = 8.dp)
        )

        TimerStepper(getString = getString, viewModel = viewModel)

        Spacer(modifier = Modifier.height(24.dp))

        // Close button (como en iOS Settings)
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.End
        ) {
            TextButton(onClick = onDismiss) {
                Icon(
                    imageVector = Icons.Default.Close,
                    contentDescription = getString("settings_close"),
                    tint = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}

@Composable
private fun SyllabarySelector(
    getString: (String) -> String,
    viewModel: KanaCronoViewModel
) {
    var selectedSilabario by remember { mutableStateOf(viewModel.silabarioSeleccionado) }
    var selectedNivel by remember { mutableStateOf(viewModel.nivelSeleccionado) }

    Column {
        // Syllabary selector (como SegmentedPickerStyle en iOS)
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            Silabario.allValues.forEach { silabario ->
                SimpleSegmentedButton(
                    modifier = Modifier.weight(1f),
                    selected = silabario == selectedSilabario,
                    onClick = {
                        selectedSilabario = silabario
                        viewModel.setSilabarioSeleccionado(silabario)
                    }
                ) {
                    Text(
                        text = when (silabario) {
                            Silabario.hiragana -> getString("syllabary_hiragana")
                            Silabario.katakana -> getString("syllabary_katakana")
                        },
                        style = MaterialTheme.typography.bodyMedium
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(8.dp))

        // Level selector (como SegmentedPickerStyle en iOS)
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            // Always show basic, diacritics, and digraphs
            Nivel.basico.let { nivel ->
                SimpleSegmentedButton(
                    modifier = Modifier.weight(1f),
                    selected = nivel == selectedNivel,
                    onClick = {
                        selectedNivel = nivel
                        viewModel.setNivelSeleccionado(nivel)
                    }
                ) {
                    Text(getString("level_basic"), style = MaterialTheme.typography.bodyMedium)
                }
            }

            Nivel.tenten.let { nivel ->
                SimpleSegmentedButton(
                    modifier = Modifier.weight(1f),
                    selected = nivel == selectedNivel,
                    onClick = {
                        selectedNivel = nivel
                        viewModel.setNivelSeleccionado(nivel)
                    }
                ) {
                    Text(getString("level_tenten"), style = MaterialTheme.typography.bodyMedium)
                }
            }

            Nivel.compuestos.let { nivel ->
                SimpleSegmentedButton(
                    modifier = Modifier.weight(1f),
                    selected = nivel == selectedNivel,
                    onClick = {
                        selectedNivel = nivel
                        viewModel.setNivelSeleccionado(nivel)
                    }
                ) {
                    Text(getString("level_compuestos"), style = MaterialTheme.typography.bodyMedium)
                }
            }

            // Extra level only for katakana (como iOS)
            if (selectedSilabario == Silabario.katakana) {
                Nivel.extra.let { nivel ->
                    SimpleSegmentedButton(
                        modifier = Modifier.weight(1f),
                        selected = nivel == selectedNivel,
                        onClick = {
                            selectedNivel = nivel
                            viewModel.setNivelSeleccionado(nivel)
                        }
                    ) {
                        Text(getString("level_extra"), style = MaterialTheme.typography.bodyMedium)
                    }
                }
            }
        }
    }
}

@Composable
private fun FontSelector(
    getString: (String) -> String,
    viewModel: KanaCronoViewModel
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        Fuente.allValues.forEach { fuente ->
            SimpleSegmentedButton(
                modifier = Modifier.weight(1f),
                selected = fuente == viewModel.fuenteSeleccionada,
                onClick = { viewModel.setFuenteSeleccionada(fuente) }
            ) {
                Text(
                    text = when (fuente) {
                        Fuente.normal -> getString("font_normal")
                        Fuente.cursiva -> getString("font_cursive")
                    },
                    style = MaterialTheme.typography.bodyMedium
                )
            }
        }
    }
}

@Composable
private fun VisibilityOptions(
    getString: (String) -> String,
    viewModel: KanaCronoViewModel
) {
    Column {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceEvenly
        ) {
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Switch(
                    checked = viewModel.verKana,
                    onCheckedChange = { viewModel.setVerKana(it) }
                )
                Text(getString("visibility_kana"), style = MaterialTheme.typography.labelSmall)
            }

            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Switch(
                    checked = viewModel.verRomaji,
                    onCheckedChange = { viewModel.setVerRomaji(it) }
                )
                Text(getString("visibility_romaji"), style = MaterialTheme.typography.labelSmall)
            }

            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Switch(
                    checked = viewModel.audioEnabled,
                    onCheckedChange = { viewModel.setAudioEnabled(it) }
                )
                Text(getString("visibility_audio"), style = MaterialTheme.typography.labelSmall)
            }
        }
    }
}

@Composable
private fun TimerStepper(
    getString: (String) -> String,
    viewModel: KanaCronoViewModel
) {
    val currentSeconds = viewModel.segundos

    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.Center,
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Decrement button
        IconButton(
            onClick = { viewModel.setSegundos(currentSeconds - 1) },
            enabled = currentSeconds > 1,
            modifier = Modifier.size(40.dp)
        ) {
            Text(
                text = "−",
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold,
                color = if (currentSeconds > 1) MaterialTheme.colorScheme.onSurface else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f)
            )
        }

        // Timer value display with localized suffix
        Text(
            text = "$currentSeconds${getString("time_suffix")}",
            fontSize = 18.sp,
            fontWeight = FontWeight.Medium,
            modifier = Modifier.padding(horizontal = 16.dp)
        )

        // Increment button
        IconButton(
            onClick = { viewModel.setSegundos(currentSeconds + 1) },
            enabled = currentSeconds < 60,
            modifier = Modifier.size(40.dp)
        ) {
            Text(
                text = "+",
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold,
                color = if (currentSeconds < 60) MaterialTheme.colorScheme.onSurface else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f)
            )
        }
    }
}

/**
 * Simple segmented button that doesn't require a row scope.
 * Uses .weight(1f) in Row for proper horizontal distribution.
 */
@Composable
private fun SimpleSegmentedButton(
    modifier: Modifier = Modifier,
    selected: Boolean,
    onClick: () -> Unit,
    content: @Composable () -> Unit
) {
    val shape = RoundedCornerShape(8.dp)

    Box(
        modifier = modifier
            .height(40.dp)
            .clip(shape)
            .background(if (selected) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.surfaceVariant)
            .clickable(onClick = onClick)
            .padding(horizontal = 8.dp, vertical = 4.dp),
        contentAlignment = Alignment.Center
    ) {
        content()
    }
}

// MARK: - Helper extension

private fun android.content.Context.isDarkTheme(): Boolean {
    return resources.configuration.uiMode and android.content.res.Configuration.UI_MODE_NIGHT_MASK ==
            android.content.res.Configuration.UI_MODE_NIGHT_YES
}
