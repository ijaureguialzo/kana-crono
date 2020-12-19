//
//  ContentView.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 28/11/20.
//

import SwiftUI
import AVFoundation

struct ContentView: View {

    @EnvironmentObject var config: Config

    @State var kana = "きゅ"
    @State var romaji = "kyu"

    @State var timeRemaining = 5
    @State private var value = 5

    // REF: https://www.hackingwithswift.com/books/ios-swiftui/changing-a-views-layout-in-response-to-size-classes
    @Environment(\.verticalSizeClass) var sizeClass

    // REF: https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-a-timer-with-swiftui
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {

        if sizeClass == .regular {
            VStack {
                Selectores()
                    .padding(.horizontal, 40)

                VStack {
                    Kana(etiqueta: $kana)

                    Text(romaji)
                        .opacity(config.verRomaji ? 1 : 0)
                }
                    .padding(.vertical, 20)

                Divider()

                OpcionesVisibilidad()
                    .padding(.horizontal, 10)

                Divider()

                Stepper(onIncrement: incrementStep,
                    onDecrement: decrementStep) {
                    Text("\(value) segundos")
                }
                    .padding(.horizontal, 80)

                Divider()

                Text("\(timeRemaining)")
                    .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        timeRemaining = value
                        nuevoKana()
                    }
                }
                    .font(.system(size: 36))
                    .frame(width: 80, height: 80, alignment: .center)
                    .foregroundColor(.accentColor)
                    .background(Color(.systemGray6))
                    .cornerRadius(40)
            }
        } else {
            HStack {
                VStack {
                    Kana(etiqueta: $kana)

                    Text(romaji)
                        .opacity(config.verRomaji ? 1 : 0)
                }
                    .padding(.vertical, 20)

                VStack {

                    Selectores()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                    Divider()

                    OpcionesVisibilidad()

                    Divider()

                    HStack {
                        Stepper(onIncrement: incrementStep,
                            onDecrement: decrementStep) {
                            Text("\(value) segundos")
                        }
                            .padding(.horizontal, 20)

                        Text("\(timeRemaining)")
                            .onReceive(timer) { _ in
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                            } else {
                                timeRemaining = value
                                nuevoKana()
                            }
                        }
                            .font(.system(size: 36))
                            .frame(width: 80, height: 80, alignment: .center)
                            .foregroundColor(.accentColor)
                            .background(Color(.systemGray6))
                            .cornerRadius(40)
                    }
                        .padding(.horizontal, 20)

                }
                    .padding(.horizontal, 10)

            }
        }
    }

    func incrementStep() {
        value += 1
        if value >= 60 { value = 60 }
        self.timeRemaining = value
    }

    func decrementStep() {
        value -= 1
        if value < 2 {
            value = 2
        }
        self.timeRemaining = value
    }

    func nuevoKana() {

        config.verKanaTemporal = false

        let aleatorio = tuplasKana(cantidad: 1, config.silabarioSeleccionado, nivel: config.nivelSeleccionado)[0]

        kana = aleatorio.kana
        romaji = aleatorio.romaji

        // REF: https://nshipster.com/avspeechsynthesizer/
        if config.audio {
            let utterance = AVSpeechUtterance(string: kana)
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
            utterance.rate = AVSpeechUtteranceMinimumSpeechRate

            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
            synthesizer.pauseSpeaking(at: .word)
        }
    }
}

// REF: https://developer.apple.com/forums/thread/118589?answerId=398398022#398398022
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_CustomPreview()
    }
}

struct ContentView_CustomPreview: View {
    var body: some View {
        ContentView().environmentObject(Config())
    }
}
