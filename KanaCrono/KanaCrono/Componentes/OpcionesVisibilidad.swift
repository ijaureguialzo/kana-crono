//
//  OpcionesVisibilidad.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 29/11/20.
//

import SwiftUI

struct OpcionesVisibilidad: View {

    @EnvironmentObject var vm: ViewModel

    var body: some View {
        HStack {
            Toggle(isOn: $vm.verKana) {
                Text("Kana")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Toggle(isOn: $vm.verRomaji) {
                Text("Romaji")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Toggle(isOn: $vm.audio) {
                Text("Audio")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
            .scaleEffect(0.8)
    }
}

struct OpcionesVisibilidad_Previews: PreviewProvider {
    static var previews: some View {
        OpcionesVisibilidad_CustomPreview()
    }
}

struct OpcionesVisibilidad_CustomPreview: View {
    var body: some View {
        OpcionesVisibilidad().environmentObject(ViewModel())
    }
}
