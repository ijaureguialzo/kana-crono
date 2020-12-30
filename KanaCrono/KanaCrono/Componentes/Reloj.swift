//
//  Reloj.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 20/12/20.
//

import SwiftUI
import AVFoundation

// REF: Global para evitar un memory-leak: https://stackoverflow.com/a/60309746/14378620
let synthesizer = AVSpeechSynthesizer()

struct Reloj: View {

    @EnvironmentObject var vm: ViewModel

    @Binding var segundos: Int

    var body: some View {
        HStack(spacing: 20) {

            Button(action: {
                if vm.timerRunning {
                    vm.pararReloj()
                } else {
                    vm.iniciarReloj()
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
                .onChange(of: segundos) { _ in
                vm.pararReloj()
                vm.timeRemaining = segundos
                vm.iniciarReloj()
            }
                .gesture(TapGesture().onEnded { _ in
                    vm.verKanaTemporal = true
                    vm.verRomajiTemporal = true
                })
                .onChange(of: vm.silabarioSeleccionado) { _ in
                vm.pararReloj()
                vm.timeRemaining = segundos
                vm.iniciarReloj()
                nuevoKana()
            }
                .onChange(of: vm.nivelSeleccionado) { _ in
                vm.pararReloj()
                vm.timeRemaining = segundos
                vm.iniciarReloj()
                nuevoKana()
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
                        vm.timeRemaining = segundos
                        nuevoKana()
                    }
                }
            }
                .font(.system(size: 36))
                .frame(width: 80, height: 80, alignment: .center)
                .foregroundColor(.accentColor)
                .background(Color(.systemGray6))
                .cornerRadius(40)

            Button(action: {
                vm.pararReloj()
                vm.timeRemaining = segundos
                vm.iniciarReloj()
                nuevoKana()
            }) {
                Image(systemName: "forward.fill")
                    .font(.title)
            }

        }
    }

    func nuevoKana() {

        vm.verKanaTemporal = false
        vm.verRomajiTemporal = false

        vm.kanaAleatorio()

        // REF: https://nshipster.com/avspeechsynthesizer/
        if vm.audio {
            synthesizer.stopSpeaking(at: .immediate)

            let utterance = AVSpeechUtterance(string: vm.kana)
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
            utterance.rate = AVSpeechUtteranceMinimumSpeechRate

            synthesizer.speak(utterance)
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
        Reloj(segundos: $segundos)
            .environmentObject(ViewModel())
    }
}
