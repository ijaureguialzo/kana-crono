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
            Picker("Silabario", selection: $config.silabarioSeleccionado) {
                ForEach(Silabario.allCases, id: \.self) { silabario in
                    Text(silabario.rawValue.capitalized)
                }
            }

            Picker("Nivel", selection: $config.nivelSeleccionado) {
                Text("Básico").tag(Nivel.basico)
                Text("Diacríticos").tag(Nivel.tenten)
                Text("Dígrafos").tag(Nivel.compuestos)
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
