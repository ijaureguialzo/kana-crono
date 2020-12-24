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

    @EnvironmentObject var config: Config

    @Binding var segundos: Int
    @Binding var kana: String
    @Binding var romaji: String

    // REF: https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-a-timer-with-swiftui
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 5
    @State private var timerRunning = true

    var body: some View {
        HStack(spacing: 20) {

            Button(action: {
                if timerRunning {
                    timer.upstream.connect().cancel()
                    timerRunning = false
                } else {
                    timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    timerRunning = true
                }
            }) {
                if timerRunning {
                    Image(systemName: "pause.fill")
                        .font(.title)
                } else {
                    Image(systemName: "play.fill")
                        .font(.title)
                }
            }

            Text("\(timeRemaining)")
                .onChange(of: segundos) { _ in
                timeRemaining = segundos
            }
                .gesture(TapGesture().onEnded { _ in
                    config.verKanaTemporal = true
                    config.verRomajiTemporal = true
                })
                .onChange(of: config.silabarioSeleccionado) { _ in
                timeRemaining = segundos
                nuevoKana()
            }
                .onChange(of: config.nivelSeleccionado) { _ in
                timeRemaining = segundos
                nuevoKana()
            }
                .onReceive(timer) { _ in

                if !timerRunning {
                    timer.upstream.connect().cancel()
                } else {
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                        if timeRemaining == 0 {
                            config.verKanaTemporal = true
                            config.verRomajiTemporal = true
                        }
                    } else {
                        timeRemaining = segundos
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
                timeRemaining = segundos
                nuevoKana()
            }) {
                Image(systemName: "forward.fill")
                    .font(.title)
            }

        }.onAppear(perform: {
            timeRemaining = segundos
            nuevoKana()
        })
    }

    func nuevoKana() {

        config.verKanaTemporal = false
        config.verRomajiTemporal = false

        let aleatorio = tuplasKana(cantidad: 1, config.silabarioSeleccionado, nivel: config.nivelSeleccionado)[0]

        kana = aleatorio.kana
        romaji = aleatorio.romaji

        // REF: https://nshipster.com/avspeechsynthesizer/
        if config.audio {
            synthesizer.stopSpeaking(at: .immediate)

            let utterance = AVSpeechUtterance(string: kana)
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

    @State private var kana = "きゅ"
    @State private var romaji = "kyu"
    @State private var segundos = 5

    var body: some View {
        Reloj(segundos: $segundos, kana: $kana, romaji: $romaji)
            .environmentObject(Config())
    }
}
