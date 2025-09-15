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
                let lado = UIScreen.main.bounds.width * 0.66

                VStack(spacing: 0) {
                    Reloj()
                        .padding(.top)
                        .foregroundColor(Color(.tertiaryLabel))
                    Spacer()
                    Kana()
                        .frame(maxWidth: lado, maxHeight: lado)
                        .padding(.bottom)
                    Romaji()
                        .frame(maxWidth: lado, maxHeight: lado)
                        .padding(.top)
                    Spacer()
                    BotonAjustes(showSettings: $showSettings)
                        .padding(.bottom)
                }
            } else {
                let lado = UIScreen.main.bounds.height * 0.66

                VStack(spacing: 0) {
                    Reloj()
                        .padding(.top)
                        .foregroundColor(Color(.tertiaryLabel))
                    Spacer()
                    HStack(spacing: 0) {
                        Kana()
                            .frame(maxWidth: lado, maxHeight: lado)
                            .padding(.trailing)
                        Romaji()
                            .frame(maxWidth: lado, maxHeight: lado)
                            .padding(.leading)
                    }
                    Spacer()
                    BotonAjustes(showSettings: $showSettings)
                        .padding(.bottom)
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
