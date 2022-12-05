//
//  BotonAjustes.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 5/12/22.
//

import SwiftUI

struct BotonAjustes: View {

    @Binding var showSettings: Bool

    var body: some View {
        Button(action: {
            self.showSettings = true
        }) {
            Text(Image(systemName: "gearshape"))
                .foregroundColor(Color(UIColor.lightGray))
                .opacity(0.33)
        }
            .sheet(isPresented: $showSettings, content: {
            Settings()
        })
    }
}

struct BotonAjustes_Previews: PreviewProvider {
    static var previews: some View {
        BotonAjustes_CustomPreview()
    }
}

struct BotonAjustes_CustomPreview: View {

    @State var showSettings = false

    var body: some View {
        BotonAjustes(showSettings: $showSettings)
    }
}
