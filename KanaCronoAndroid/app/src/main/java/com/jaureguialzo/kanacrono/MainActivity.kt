package com.jaureguialzo.kanacrono

import android.os.Bundle
import android.view.View
import android.widget.RadioGroup
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {

    var kana = "きゅ"
    var romaji = "kyu"

    private lateinit var etiquetaKana: TextView
    private lateinit var etiquetaRomaji: TextView
    private lateinit var silabario: RadioGroup
    private lateinit var nivel: RadioGroup

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        etiquetaKana = findViewById(R.id.etiquetaKana)
        etiquetaRomaji = findViewById(R.id.etiquetaRomaji)
        silabario = findViewById(R.id.silabarioRadioGroup)
        nivel = findViewById(R.id.nivelRadioGroup)

        nuevoKana()

        silabario.setOnCheckedChangeListener { _, _ -> nuevoKana() }
        nivel.setOnCheckedChangeListener { _, _ -> nuevoKana() }
    }

    fun botonSiguiente(view: View) {
        nuevoKana()
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
