//
//  Kana.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 29/11/20.
//

import SwiftUI

struct Kana: View {

    @EnvironmentObject var config: Config

    @Binding var etiqueta: String

    var body: some View {
        Text(etiqueta)
            .frame(minWidth: 300)
            .opacity(config.verKana ? 1 : 0)
            .font(.custom("Hiragino Mincho ProN W3", size: 144))
            .padding()
            .foregroundColor(Color(.label))
            .background(Color("Fondo"))
            .cornerRadius(10.0)
    }
}

struct Kana_Previews: PreviewProvider {
    static var previews: some View {
        Kana_CustomPreview()
    }
}

struct Kana_CustomPreview: View {
    @State private var etiqueta = "きゅ"

    var body: some View {
        Kana(etiqueta: $etiqueta).environmentObject(Config())
    }
}
