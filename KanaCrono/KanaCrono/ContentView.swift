//
//  ContentView.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 28/11/20.
//

import SwiftUI

struct ContentView: View {

    // REF: https://www.hackingwithswift.com/books/ios-swiftui/changing-a-views-layout-in-response-to-size-classes
    @Environment(\.verticalSizeClass) var sizeClass

    @EnvironmentObject var config: Config

    @State private var kana = "きゅ"
    @State private var romaji = "kyu"
    @State private var segundos = 5

    var body: some View {

        if sizeClass == .regular {
            VStack {
                Selectores()
                    .padding(.horizontal, 40)

                VStack {
                    Kana(etiqueta: $kana)
                    Romaji(etiqueta: $romaji)
                }
                    .padding(20)

                Divider()

                OpcionesVisibilidad()
                    .padding(.horizontal, 10)

                Divider()

                StepperSegundos(segundos: $segundos)
                    .padding(.horizontal, 80)

                Divider()

                Reloj(segundos: $segundos, kana: $kana, romaji: $romaji)
            }
        } else {
            HStack {
                VStack {
                    Kana(etiqueta: $kana)
                    Romaji(etiqueta: $romaji)
                }
                    .padding(20)

                VStack {

                    Selectores()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                    Divider()

                    OpcionesVisibilidad()

                    Divider()

                    HStack {
                        StepperSegundos(segundos: $segundos)
                            .padding(.horizontal, 20)

                        Spacer()

                        Reloj(segundos: $segundos, kana: $kana, romaji: $romaji)
                    }
                        .padding(.horizontal, 20)

                }
                    .padding(.horizontal, 10)

            }
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
