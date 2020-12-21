//
//  Selectores.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 29/11/20.
//

import SwiftUI

struct Selectores: View {

    @EnvironmentObject var config: Config

    var body: some View {
        VStack {
            Picker("PICKER_SYLLABARY", selection: $config.silabarioSeleccionado) {
                ForEach(Silabario.allCases, id: \.self) { silabario in
                    Text(silabario.rawValue.capitalized)
                }
            }

            Picker("PICKER_LEVEL", selection: $config.nivelSeleccionado) {
                Text("LEVEL_BASIC")
                    .tag(Nivel.basico)
                Text("LEVEL_DIACRITICS")
                    .tag(Nivel.tenten)
                Text("LEVEL_DIGRAPHS")
                    .tag(Nivel.compuestos)
            }
        }
            .pickerStyle(SegmentedPickerStyle())
    }
}

struct Selectores_Previews: PreviewProvider {
    static var previews: some View {
        Selectores_CustomPreview()
    }
}

struct Selectores_CustomPreview: View {
    var body: some View {
        Selectores().environmentObject(Config())
    }
}
