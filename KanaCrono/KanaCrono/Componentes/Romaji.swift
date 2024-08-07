//
//  Romaji.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 19/12/20.
//

import SwiftUI

struct Romaji: View {

    @EnvironmentObject var vm: ViewModel

    var transparencia: Double {
        get {
            return vm.verRomajiTemporal ? 1 : vm.verRomaji ? 1 : 0
        }
    }

    var body: some View {

        Text(vm.romaji)
            .opacity(transparencia)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(.system(size: 50))
            .foregroundColor(Color(.systemBackground))
            .background(Color("AccentColor"))
            .cornerRadius(10.0)
            .gesture(TapGesture().onEnded { _ in
                if vm.todoVisible() {
                    vm.reiniciarReloj()
                    vm.nuevoKana()
                } else {
                    vm.verRomajiTemporal = true
                }
            })
    }
}

struct Romaji_Previews: PreviewProvider {
    static var previews: some View {
        Romaji_CustomPreview()
    }
}

struct Romaji_CustomPreview: View {

    var body: some View {
        VStack {
            Romaji().environmentObject(ViewModel())
        } .frame(maxWidth: 240, maxHeight: 240)
    }
}
