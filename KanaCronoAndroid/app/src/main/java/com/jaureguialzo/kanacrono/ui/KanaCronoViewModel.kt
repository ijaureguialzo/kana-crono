package com.jaureguialzo.kanacrono.ui

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import com.jaureguialzo.kanacrono.data.Fuente
import com.jaureguialzo.kanacrono.data.Nivel
import com.jaureguialzo.kanacrono.data.Silabario
import com.jaureguialzo.kanacrono.data.tuplasKana
import java.util.Locale
import java.util.Timer

/**
 * ViewModel principal de KanaCrono.
 * Réplica exacta de la lógica de ViewModel.swift iOS.
 */
class KanaCronoViewModel : ViewModel() {

    // MARK: - Estado principal (como @Published en iOS)
    var kana: String by mutableStateOf("きゅ")

    var romaji: String by mutableStateOf("kyu")

    // MARK: - Ajustes (como @AppStorage en iOS)
    // Usamos backing fields + getters/setters para evitar colisión JVM con setters de var by
    private var _segundos: Int by mutableStateOf(5)
    val segundos: Int get() = _segundos

    private var _silabarioSeleccionado: Silabario by mutableStateOf(Silabario.hiragana)
    val silabarioSeleccionado: Silabario get() = _silabarioSeleccionado

    private var _nivelSeleccionado: Nivel by mutableStateOf(Nivel.basico)
    val nivelSeleccionado: Nivel get() = _nivelSeleccionado

    private var _fuenteSeleccionada: Fuente by mutableStateOf(Fuente.normal)
    val fuenteSeleccionada: Fuente get() = _fuenteSeleccionada

    private var _verKana: Boolean by mutableStateOf(true)
    val verKana: Boolean get() = _verKana

    private var _verRomaji: Boolean by mutableStateOf(true)
    val verRomaji: Boolean get() = _verRomaji

    private var _audioEnabled: Boolean by mutableStateOf(false)
    val audioEnabled: Boolean get() = _audioEnabled

    // MARK: - Estado temporal (como @Published var en iOS)
    private var _verKanaTemporal: Boolean by mutableStateOf(false)
    val verKanaTemporal: Boolean get() = _verKanaTemporal

    private var _verRomajiTemporal: Boolean by mutableStateOf(false)
    val verRomajiTemporal: Boolean get() = _verRomajiTemporal

    // MARK: - Timer
    var timeRemaining: Int by mutableIntStateOf(5)

    var timerRunning: Boolean by mutableStateOf(true)

    // MARK: - Audio event (canal simple para notificar TTS)
    var audioKanaToSpeak: String? by mutableStateOf(null)

    private var timer: Timer? = null
    private var kanaAnterior: String? = null

    init {
        kanaAleatorio()
        timeRemaining = segundos
        iniciarReloj() // Arranca automáticamente como en iOS
    }

    // MARK: - Lógica de visibilidad (como todosOff en iOS)
    private fun todosOff(): Boolean {
        return !verKana && !verRomaji && !audioEnabled
    }

    /**
     * Comprueba si todo es visible (kana + romaji).
     */
    fun todoVisible(): Boolean {
        return (verKana || verKanaTemporal) && (verRomaji || verRomajiTemporal)
    }

    // MARK: - Selección aleatoria (como kanaAleatorio en iOS)
    private fun kanaAleatorio() {
        val resultado = tuplasKana(cantidad = 1, silabarioSeleccionado, nivelSeleccionado)
        val nuevoKana = resultado[0].first
        val nuevoRomaji = resultado[0].second

        if (nuevoKana != kanaAnterior) {
            kana = nuevoKana
            romaji = nuevoRomaji
            kanaAnterior = nuevoKana
        } else {
            // Fallback: acepta cualquier valor si no encuentra uno distinto
            kana = nuevoKana
            romaji = nuevoRomaji
        }
    }

    // MARK: - Timer (como en iOS)
    fun pararReloj() {
        timer?.cancel()
        timer = null
    }

    fun iniciarReloj() {
        pararReloj()
        timer = Timer("kanacrono-timer", false)
        val task = object : java.util.TimerTask() {
            override fun run() {
                if (timerRunning) {
                    if (timeRemaining > 0) {
                        timeRemaining--
                        // Al llegar a 0, revelar kana y romaji temporalmente (como iOS)
                        if (timeRemaining == 0) {
                            _verKanaTemporal = true
                            _verRomajiTemporal = true
                        }
                    } else {
                        timeRemaining = segundos
                        nuevoKana()
                    }
                }
            }
        }
        timer!!.scheduleAtFixedRate(task, 1000, 1000)
    }

    fun reiniciarReloj() {
        pararReloj()
        timeRemaining = segundos
        iniciarReloj()
    }

    // MARK: - Audio (como leerKana en iOS)
    private fun leerKana() {
        if (audioEnabled) {
            audioKanaToSpeak = kana
        } else {
            audioKanaToSpeak = null
        }
    }

    // MARK: - Acciones principales (como nuevoKana en iOS)
    fun nuevoKana() {
        _verKanaTemporal = false
        _verRomajiTemporal = false
        kanaAleatorio()
        audioKanaToSpeak = null // Reset audio event

        // Leer audio si está activado
        leerKana()
    }

    // MARK: - Gestión de ajustes (como didSet en iOS)
    fun setSilabarioSeleccionado(nuevo: Silabario) {
        val anterior = silabarioSeleccionado
        _silabarioSeleccionado = nuevo

        // Si cambiamos a hiragana y estábamos en extra, bajar a compuestos
        if (nuevo == Silabario.hiragana && nivelSeleccionado == Nivel.extra) {
            setNivelSeleccionado(Nivel.compuestos)
        }

        reiniciarReloj()
        nuevoKana()
    }

    fun setNivelSeleccionado(nuevo: Nivel) {
        _nivelSeleccionado = nuevo
        reiniciarReloj()
        nuevoKana()
    }

    fun setFuenteSeleccionada(nuevo: Fuente) {
        _fuenteSeleccionada = nuevo
    }

    fun setVerKana(nuevo: Boolean) {
        _verKana = nuevo
        _verKanaTemporal = nuevo

        if (todosOff()) {
            setVerRomaji(true)
            setAudioEnabled(true)
        }
    }

    fun setVerRomaji(nuevo: Boolean) {
        _verRomaji = nuevo
        _verRomajiTemporal = nuevo

        if (todosOff()) {
            setVerKana(true)
            setAudioEnabled(true)
        }
    }

    fun setAudioEnabled(nuevo: Boolean) {
        _audioEnabled = nuevo
        _verKanaTemporal = verKana

        if (todosOff()) {
            setVerKana(true)
            setVerRomaji(true)
        }
    }

    fun setSegundos(nuevo: Int) {
        val antiguo = segundos
        _segundos = nuevo.coerceIn(1, 60)

        if (segundos != antiguo) {
            reiniciarReloj()
        }
    }

    fun toggleTimerRunning() {
        if (timerRunning) {
            pararReloj()
            timerRunning = false
        } else {
            timerRunning = true
            iniciarReloj()
        }
    }

    fun avanzarKana() {
        reiniciarReloj()
        nuevoKana()
    }

    fun revelarKanaTemporal() {
        _verKanaTemporal = true
    }

    fun revelarRomajiTemporal() {
        _verRomajiTemporal = true
    }

    fun revelarTodoTemporal() {
        _verKanaTemporal = true
        _verRomajiTemporal = true
    }

    // MARK: - Cleanup
    override fun onCleared() {
        super.onCleared()
        pararReloj()
    }
}
