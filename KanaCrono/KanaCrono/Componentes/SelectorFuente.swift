//
//  SelectorFuente.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 5/12/22.
//

import SwiftUI

struct SelectorFuente: View {

    @EnvironmentObject var vm: ViewModel

    var body: some View {
        VStack {
            Picker("PICKER_FONT", selection: $vm.fuenteSeleccionada) {
                Text("FONT_NORMAL")
                    .tag(Fuente.normal)
                Text("FONT_CURSIVE")
                    .tag(Fuente.cursiva)
            }
        }
            .pickerStyle(SegmentedPickerStyle())
    }
}

struct SelectorFuente_Previews: PreviewProvider {
    static var previews: some View {
        SelectorFuente_CustomPreview()
    }
}

struct SelectorFuente_CustomPreview: View {
    var body: some View {
        SelectorFuente().environmentObject(ViewModel())
    }
}
