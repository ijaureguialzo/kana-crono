//
//  ViewModel.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 29/11/20.
//

import Foundation
import SwiftUI
import AVFoundation

// REF: Global para evitar un memory-leak: https://stackoverflow.com/a/60309746/14378620
let synthesizer = AVSpeechSynthesizer()

enum Fuente: String, CaseIterable, Identifiable {
    case normal
    case cursiva

    var id: String { self.rawValue }
}

// REF: https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-environmentobject-to-share-data-between-views
class ViewModel: ObservableObject {

    @Published var kana = "きゅ"
    @Published var romaji = "kyu"

    @AppStorage("segundos") var segundos = 5

    init() {
        kanaAleatorio()
        timeRemaining = segundos
    }

    @AppStorage("silabarioSeleccionado") var silabarioSeleccionado = Silabario.hiragana
    @AppStorage("nivelSeleccionado") var nivelSeleccionado = Nivel.basico
    @AppStorage("fuenteSeleccionada") var fuenteSeleccionada = Fuente.normal

    @AppStorage("verKana") var verKana = true {
        didSet {
            verKanaTemporal = verKana

            if todosOff() {
                verRomaji = true
                audio = true
            }
        }
    }
    @Published var verKanaTemporal = false

    @AppStorage("verRomaji") var verRomaji = true {
        didSet {
            verRomajiTemporal = verRomaji

            if todosOff() {
                verKana = true
                audio = true
            }
        }
    }
    @Published var verRomajiTemporal = false

    @AppStorage("audio") var audio = false {
        didSet {
            verKanaTemporal = verKana

            if todosOff() {
                verKana = true
                verRomaji = true
            }
        }
    }

    func todosOff() -> Bool {
        return !verKana && !verRomaji && !audio
    }

    private var kana_anterior: String!

    func kanaAleatorio() {

        kana_anterior = kana
        repeat {
            let aleatorio = tuplasKana(cantidad: 1, silabarioSeleccionado, nivel: nivelSeleccionado)[0]

            kana = aleatorio.kana
            romaji = aleatorio.romaji
        } while(kana == kana_anterior)
    }

    // REF: https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-a-timer-with-swiftui
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var timeRemaining = 5
    @AppStorage("timerRunning") var timerRunning = true

    func pararReloj() {
        timer.upstream.connect().cancel()
    }

    func iniciarReloj() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }

    func reiniciarReloj() {
        pararReloj()
        timeRemaining = segundos
        iniciarReloj()
    }

    func leerKana() {
        // REF: https://nshipster.com/avspeechsynthesizer/
        if audio {
            synthesizer.stopSpeaking(at: .immediate)

            let utterance = AVSpeechUtterance(string: kana)
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
            utterance.rate = AVSpeechUtteranceMinimumSpeechRate

            synthesizer.speak(utterance)
        }
    }

    func nuevoKana() {
        verKanaTemporal = false
        verRomajiTemporal = false
        kanaAleatorio()
        leerKana()
    }

    func todoVisible() -> Bool {
        return (verKana || verKanaTemporal) && (verRomaji || verRomajiTemporal)
    }
}
