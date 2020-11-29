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

    @State var timeRemaining = 5
    @State private var value = 5

    @State private var silabarioSeleccionado = Silabario.hiragana
    @State private var nivelSeleccionado = Nivel.basico

    // REF: https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-a-timer-with-swiftui
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {

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

            Text(etiqueta)
                .font(.custom("Hiragino Mincho ProN W3", size: 144))
                .padding()
                .foregroundColor(Color(.label))
                .background(Color("Fondo"))
                .cornerRadius(10.0)
                .padding(.vertical, 20)

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
            .onAppear() {
            nuevoKana()
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
        etiqueta = kana(aleatorios: 1, silabarioSeleccionado, nivel: nivelSeleccionado)[0].0

        // REF: https://nshipster.com/avspeechsynthesizer/
        let utterance = AVSpeechUtterance(string: etiqueta)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = AVSpeechUtteranceMinimumSpeechRate

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        synthesizer.pauseSpeaking(at: .word)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
