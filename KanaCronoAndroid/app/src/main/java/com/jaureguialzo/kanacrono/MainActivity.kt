package com.jaureguialzo.kanacrono

import android.os.Bundle
import android.view.View
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {

    var kana = "きゅ"
    var romaji = "kyu"

    private lateinit var etiquetaKana: TextView
    private lateinit var etiquetaRomaji: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        etiquetaKana = findViewById(R.id.etiquetaKana)
        etiquetaRomaji = findViewById(R.id.etiquetaRomaji)

        nuevoKana()
    }

    fun botonSiguiente(view: View) {
        nuevoKana()
    }

    fun nuevoKana() {
        etiquetaKana.text = kana
        etiquetaRomaji.text = romaji
    }
}
