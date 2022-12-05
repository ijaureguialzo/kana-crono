//
//  Reloj.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 20/12/20.
//

import SwiftUI

struct Reloj: View {

    @EnvironmentObject var vm: ViewModel

    var body: some View {
        HStack() {

            Button(action: {
                if vm.timerRunning {
                    vm.pararReloj()
                    vm.timerRunning = false
                } else {
                    vm.iniciarReloj()
                    vm.timerRunning = true
                }
            }) {
                if vm.timerRunning {
                    Image(systemName: "pause.fill")
                } else {
                    Image(systemName: "play.fill")
                }
            }

            Text("\(vm.timeRemaining)")
                .onChange(of: vm.segundos) { _ in
                vm.reiniciarReloj()
            }
                .gesture(TapGesture().onEnded { _ in
                    vm.verKanaTemporal = true
                    vm.verRomajiTemporal = true
                })
                .onChange(of: vm.silabarioSeleccionado) { _ in
                vm.reiniciarReloj()
                vm.nuevoKana()
            }
                .onChange(of: vm.nivelSeleccionado) { _ in
                vm.reiniciarReloj()
                vm.nuevoKana()
            }
                .onReceive(vm.timer) { _ in

                if !vm.timerRunning {
                    vm.pararReloj()
                } else {
                    if vm.timeRemaining > 0 {
                        vm.timeRemaining -= 1
                        if vm.timeRemaining == 0 {
                            vm.verKanaTemporal = true
                            vm.verRomajiTemporal = true
                        }
                    } else {
                        vm.timeRemaining = vm.segundos
                        vm.nuevoKana()
                    }
                }
            }

            Button(action: {
                vm.reiniciarReloj()
                vm.nuevoKana()
            }) {
                Image(systemName: "forward.fill")
            }
        }
    }
}

struct Reloj_Previews: PreviewProvider {
    static var previews: some View {
        Reloj_CustomPreview()
    }
}

struct Reloj_CustomPreview: View {

    @State private var segundos = 5

    var body: some View {
        Reloj()
            .environmentObject(ViewModel())
    }
}
