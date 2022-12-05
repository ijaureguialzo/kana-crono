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
        HStack(spacing: 20) {

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
                        .font(.title)
                } else {
                    Image(systemName: "play.fill")
                        .font(.title)
                }
            }
                .frame(width: 25)

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
                .font(.system(size: 36))
                .frame(width: 80, height: 80, alignment: .center)
                .foregroundColor(.accentColor)
                .background(Color(.systemGray6))
                .cornerRadius(40)

            Button(action: {
                vm.reiniciarReloj()
                vm.nuevoKana()
            }) {
                Image(systemName: "forward.fill")
                    .font(.title)
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
