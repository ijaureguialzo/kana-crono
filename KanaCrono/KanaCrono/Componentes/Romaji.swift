//
//  Romaji.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 19/12/20.
//

import SwiftUI

struct Romaji: View {

    @EnvironmentObject var config: Config

    @Binding var etiqueta: String

    var transparencia: Double {
        get {
            return config.verRomajiTemporal ? 1 : config.verRomaji ? 1 : 0
        }
    }

    var body: some View {
        Text(etiqueta)
            .opacity(transparencia)
            .frame(minWidth: 220)
            .font(.title)
            .padding()
            .foregroundColor(Color(.systemBackground))
            .background(Color("AccentColor"))
            .cornerRadius(10.0)
            .gesture(TapGesture().onEnded { _ in
                config.verRomajiTemporal = true
            })
    }
}

struct Romaji_Previews: PreviewProvider {
    static var previews: some View {
        Romaji_CustomPreview()
    }
}

struct Romaji_CustomPreview: View {
    @State private var etiqueta = "kyu"

    var body: some View {
        Romaji(etiqueta: $etiqueta).environmentObject(Config())
    }
}
