package com.jaureguialzo.kanacrono

import android.os.Bundle
import android.view.View
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import java.util.*

class MainActivity : AppCompatActivity() {

    var kana = "きゅ"
    var romaji = "kyu"

    private lateinit var etiquetaKana: TextView
    private lateinit var etiquetaRomaji: TextView
    private lateinit var etiquetaSegundos: TextView
    private lateinit var silabario: RadioGroup
    private lateinit var nivel: RadioGroup
    private lateinit var verKana: Switch
    private lateinit var verRomaji: Switch
    private lateinit var pickerSegundos: NumberPicker

    private lateinit var timer: Timer
    private var segundos = 5
    private var timeRemaining = 5
    private var timerRunning = true

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        etiquetaKana = findViewById(R.id.etiquetaKana)
        etiquetaRomaji = findViewById(R.id.etiquetaRomaji)
        etiquetaSegundos = findViewById(R.id.etiquetaSegundos)
        silabario = findViewById(R.id.silabarioRadioGroup)
        nivel = findViewById(R.id.nivelRadioGroup)
        verKana = findViewById(R.id.switchKana)
        verRomaji = findViewById(R.id.switchRomaji)
        pickerSegundos = findViewById(R.id.pickerSegundos)

        nuevoKana()

        silabario.setOnCheckedChangeListener { _, _ ->
            siguienteKana()
        }
        nivel.setOnCheckedChangeListener { _, _ ->
            siguienteKana()
        }
        verKana.setOnCheckedChangeListener { _, isChecked ->
            if (isChecked)
                etiquetaKana.alpha = 1.0F
            else
                etiquetaKana.alpha = 0.0F
        }
        verRomaji.setOnCheckedChangeListener { _, isChecked ->
            if (isChecked)
                etiquetaRomaji.alpha = 1.0F
            else
                etiquetaRomaji.alpha = 0.0F
        }

        val tiempos = arrayOf("1", "2", "3", "5", "10", "15", "20", "30", "45", "60")

        pickerSegundos.minValue = 0
        pickerSegundos.maxValue = tiempos.size - 1
        pickerSegundos.displayedValues = tiempos
        pickerSegundos.wrapSelectorWheel = false
        pickerSegundos.value = tiempos.indexOfFirst {
            it == segundos.toString()
        }

        pickerSegundos.setOnValueChangedListener { _, _, newVal ->
            segundos = tiempos[newVal].toInt()
            siguienteKana()
        }

        timeRemaining = segundos
        iniciarReloj()
    }

    fun iniciarReloj() {

        etiquetaSegundos.text = "${timeRemaining}"

        timer = Timer()

        // REF: https://stackoverflow.com/a/46144839
        timer.schedule(object : TimerTask() {
            override fun run() {
                runOnUiThread(object : TimerTask() {
                    override fun run() {
                        if (timerRunning) {
                            if (timeRemaining > 0) {
                                timeRemaining -= 1
                            } else {
                                timeRemaining = segundos
                                nuevoKana()
                            }
                            etiquetaSegundos.text = "${timeRemaining}"
                        }
                    }
                })
            }
        }, 1000, 1000)
    }

    fun pararReloj() {
        timer.cancel()
    }

    fun botonSiguiente(view: View) {
        siguienteKana()
    }

    private fun siguienteKana() {
        nuevoKana()
        timeRemaining = segundos
        etiquetaSegundos.text = "${timeRemaining}"
        if (timerRunning) {
            pararReloj()
            iniciarReloj()
        }
    }

    fun botonPausa(view: View) {
        val boton = view as ImageButton

        if (timerRunning) {
            pararReloj()
            timerRunning = false
            boton.setImageResource(android.R.drawable.ic_media_play)
        } else {
            iniciarReloj()
            timerRunning = true
            boton.setImageResource(android.R.drawable.ic_media_pause)
        }
    }

    fun nuevoKana() {
        val aleatorio = tuplaKana(silabarioSeleccionado(), nivelSeleccionado())
        etiquetaKana.text = aleatorio.first
        etiquetaRomaji.text = aleatorio.second
    }

    fun silabarioSeleccionado(): Silabario {
        return when (silabario.checkedRadioButtonId) {
            R.id.radioButtonHiragana -> Silabario.hiragana
            R.id.radioButtonKatakana -> Silabario.katakana
            else -> Silabario.hiragana
        }
    }

    fun nivelSeleccionado(): Nivel {
        return when (nivel.checkedRadioButtonId) {
            R.id.radioButtonBasico -> Nivel.basico
            R.id.radioButtonDiacriticos -> Nivel.tenten
            R.id.radioButtonDigrafos -> Nivel.compuestos
            else -> Nivel.basico
        }
    }
}
