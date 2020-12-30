//
//  ViewModel.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 29/11/20.
//

import Foundation

// REF: https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-environmentobject-to-share-data-between-views
class ViewModel: ObservableObject {

    @Published var kana = "きゅ"
    @Published var romaji = "kyu"

    init() {
        kanaAleatorio()
    }

    @Published var silabarioSeleccionado = Silabario.hiragana
    @Published var nivelSeleccionado = Nivel.basico

    @Published var verKana = true {
        didSet {
            verKanaTemporal = verKana

            if todosOff() {
                verRomaji = true
                audio = true
            }
        }
    }
    @Published var verKanaTemporal = false

    @Published var verRomaji = true {
        didSet {
            verRomajiTemporal = verRomaji

            if todosOff() {
                verKana = true
                audio = true
            }
        }
    }
    @Published var verRomajiTemporal = false

    @Published var audio = false {
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
    @Published var timerRunning = true

    func pararReloj() {
        timer.upstream.connect().cancel()
    }

    func iniciarReloj() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
}
