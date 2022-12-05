//
//  Kana.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 29/11/20.
//

import SwiftUI

struct Kana: View {

    @EnvironmentObject var vm: ViewModel

    var transparencia: Double {
        get {
            return vm.verKanaTemporal ? 1 : vm.verKana ? 1 : 0
        }
    }

    // REF: https://www.answertopia.com/swiftui/working-with-gesture-recognizers-in-swiftui/
    var body: some View {

        Text(vm.kana)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(transparencia)
            .font(vm.fuente)
            .foregroundColor(Color(.label))
            .background(Color("Fondo"))
            .cornerRadius(10.0)
            .gesture(TapGesture().onEnded { _ in
                if vm.todoVisible() {
                    vm.reiniciarReloj()
                    vm.nuevoKana()
                } else {
                    vm.verKanaTemporal = true
                }
            })
    }
}

struct Kana_Previews: PreviewProvider {
    static var previews: some View {
        Kana_CustomPreview()
    }
}

struct Kana_CustomPreview: View {

    var body: some View {
        VStack {
            Kana().environmentObject(ViewModel())
        } .frame(maxWidth: 240, maxHeight: 240)
    }
}
