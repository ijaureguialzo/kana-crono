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

    @State var showSettings = false

    init() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    var body: some View {

        VStack() {
            if sizeClass == .regular {
                VStack {
                    Spacer()
                    Kana()
                    Reloj()
                        .frame(height: 30)
                        .foregroundColor(Color(UIColor.lightGray))
                        .opacity(0.33)
                    Romaji()
                    Spacer()
                    BotonAjustes(showSettings: $showSettings)
                        .padding(.bottom, 15)
                }
            } else {
                HStack {
                    VStack {
                        Spacer()

                        Divider()

                        OpcionesVisibilidad()

                        Divider()

                        Spacer()

                        HStack {
                            Spacer()

                            Reloj()
                                .opacity(0.5)

                            Spacer()

                            StepperSegundos()

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
