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

    var body: some View {
        Text(etiqueta)
            .opacity(config.verRomaji ? 1 : 0)
            .frame(minWidth: 300)
            .font(.title)
            .padding()
            .foregroundColor(Color(.systemBackground))
            .background(Color("AccentColor"))
            .cornerRadius(10.0)
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
