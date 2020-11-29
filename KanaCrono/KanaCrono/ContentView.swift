//
//  ContentView.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 28/11/20.
//

import SwiftUI
import AVFoundation

struct ContentView: View {

    @State var etiqueta = "きゅ"
    @State var romaji = "kyu"

    @State private var verKana = true
    @State private var verRomaji = true
    @State private var audio = true

    @State var timeRemaining = 5
    @State private var value = 5

    @State private var silabarioSeleccionado = Silabario.hiragana
    @State private var nivelSeleccionado = Nivel.basico

    // REF: https://www.hackingwithswift.com/books/ios-swiftui/changing-a-views-layout-in-response-to-size-classes
    @Environment(\.verticalSizeClass) var sizeClass

    // REF: https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-a-timer-with-swiftui
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {

        if sizeClass == .regular {
            VStack {
                VStack {
                    Picker("Silabario", selection: $silabarioSeleccionado) {
                        ForEach(Silabario.allCases, id: \.self) { silabario in
                            Text(silabario.rawValue.capitalized)
                        }
                    }

                    Picker("Nivel", selection: $nivelSeleccionado) {
                        Text("Básico").tag(Nivel.basico)
                        Text("Ten-Ten").tag(Nivel.tenten)
                        Text("Compuestos").tag(Nivel.compuestos)
                    }
                }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 40)

                VStack {
                    Text(etiqueta)
                        .frame(minWidth: 300)
                        .opacity(verKana ? 1 : 0)
                        .font(.custom("Hiragino Mincho ProN W3", size: 144))
                        .padding()
                        .foregroundColor(Color(.label))
                        .background(Color("Fondo"))
                        .cornerRadius(10.0)

                    Text(romaji)
                        .opacity(verRomaji ? 1 : 0)
                }
                    .padding(.vertical, 20)

                Divider()

                HStack {
                    Toggle(isOn: $verKana) {
                        Text("Kana")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    Toggle(isOn: $verRomaji) {
                        Text("Romaji")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    Toggle(isOn: $audio) {
                        Text("Audio")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
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
                    Text(etiqueta)
                        .frame(minWidth: 300)
                        .opacity(verKana ? 1 : 0)
                        .font(.custom("Hiragino Mincho ProN W3", size: 144))
                        .padding()
                        .foregroundColor(Color(.label))
                        .background(Color("Fondo"))
                        .cornerRadius(10.0)

                    Text(romaji)
                        .opacity(verRomaji ? 1 : 0)
                }
                    .padding(.vertical, 20)

                VStack {

                    VStack {
                        Picker("Silabario", selection: $silabarioSeleccionado) {
                            ForEach(Silabario.allCases, id: \.self) { silabario in
                                Text(silabario.rawValue.capitalized)
                            }
                        }

                        Picker("Nivel", selection: $nivelSeleccionado) {
                            Text("Básico").tag(Nivel.basico)
                            Text("Ten-Ten").tag(Nivel.tenten)
                            Text("Compuestos").tag(Nivel.compuestos)
                        }
                    }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 40)

                    Divider()

                    HStack {
                        Toggle(isOn: $verKana) {
                            Text("Kana")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        Toggle(isOn: $verRomaji) {
                            Text("Romaji")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        Toggle(isOn: $audio) {
                            Text("Audio")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
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

        let aleatorio = kana(aleatorios: 1, silabarioSeleccionado, nivel: nivelSeleccionado)[0]

        etiqueta = aleatorio.0
        romaji = aleatorio.1

        // REF: https://nshipster.com/avspeechsynthesizer/
        if audio {
            let utterance = AVSpeechUtterance(string: etiqueta)
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
            utterance.rate = AVSpeechUtteranceMinimumSpeechRate

            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
            synthesizer.pauseSpeaking(at: .word)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
