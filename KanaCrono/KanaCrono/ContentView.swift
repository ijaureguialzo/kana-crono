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

    @EnvironmentObject var vm: ViewModel

    @State private var segundos = 5

    var body: some View {

        if sizeClass == .regular {
            VStack {
                Spacer()

                Selectores()
                    .padding(.horizontal, 20)

                Spacer()

                VStack {
                    Kana()
                    Romaji()
                }
                    .padding(20)

                Spacer()

                VStack {
                    Divider()

                    OpcionesVisibilidad()
                        .padding(.horizontal, 10)

                    Divider()

                    StepperSegundos(segundos: $segundos)
                        .padding(.horizontal, 80)

                    Divider()
                }

                Spacer()

                Reloj(segundos: $segundos)

                Spacer()
            }
        } else {
            HStack {
                VStack {
                    Spacer()

                    Selectores()
                        .padding(.bottom, 20)

                    Divider()

                    OpcionesVisibilidad()

                    Divider()

                    Spacer()

                    HStack {
                        Spacer()

                        Reloj(segundos: $segundos)

                        Spacer()

                        StepperSegundos(segundos: $segundos)

                        Spacer()
                    }

                    Spacer()
                }
                    .padding()

                VStack {
                    Kana()
                    Romaji()
                }
                    .padding()
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
        ContentView().environmentObject(ViewModel())
    }
}
