//
//  Config.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 29/11/20.
//

import Foundation

// REF: https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-environmentobject-to-share-data-between-views
class Config: ObservableObject {
    @Published var silabarioSeleccionado = Silabario.hiragana
    @Published var nivelSeleccionado = Nivel.basico

    @Published var verKana = true {
        didSet {
            verKanaTemporal = verKana
            checkTodosOff()
        }
    }
    @Published var verKanaTemporal = false

    @Published var verRomaji = true {
        didSet {
            verRomajiTemporal = verRomaji
            checkTodosOff()
        }
    }
    @Published var verRomajiTemporal = false

    @Published var audio = false {
        didSet {
            verKanaTemporal = verKana
            checkTodosOff()
        }
    }

    func checkTodosOff() {
        if !verKana && !verRomaji && !audio {
            verKana = true
            verRomaji = true
        }
    }
}
