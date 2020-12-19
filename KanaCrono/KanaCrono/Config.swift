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

    @Published var verKana = true
    @Published var verKanaTemporal = false
    @Published var verRomaji = true
    @Published var audio = false
}
