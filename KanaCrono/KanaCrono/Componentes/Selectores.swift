//
//  Selectores.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 29/11/20.
//

import SwiftUI

struct Selectores: View {

    @EnvironmentObject var vm: ViewModel

    var body: some View {
        VStack {
            Picker("PICKER_SYLLABARY", selection: $vm.silabarioSeleccionado) {
                ForEach(Silabario.allCases, id: \.self) { silabario in
                    Text(silabario.rawValue.capitalized)
                }
            }

            Picker("PICKER_LEVEL", selection: $vm.nivelSeleccionado) {
                Text("LEVEL_BASIC")
                    .tag(Nivel.basico)
                Text("LEVEL_DIACRITICS")
                    .tag(Nivel.tenten)
                Text("LEVEL_DIGRAPHS")
                    .tag(Nivel.compuestos)
                if(vm.silabarioSeleccionado == .katakana) {
                    Text("LEVEL_EXTRA")
                        .tag(Nivel.extra)
                }
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
        Selectores().environmentObject(ViewModel())
    }
}
