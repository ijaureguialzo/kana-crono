//
//  Settings.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 5/12/22.
//

import SwiftUI

struct Settings: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {

        NavigationView {

            // Parche para iOS 26: https://developer.apple.com/forums/thread/787893
            VStack(spacing: 0) {
                Color(.systemGroupedBackground).frame(height: 16)
                List {
                    Section(header: Text("SETTINGS_SYLLABARY")) {
                        Selectores()
                    }
                    Section(header: Text("SETTINGS_FONT")) {
                        SelectorFuente()
                    }
                    Section(header: Text("SETTINGS_VISIBILITY")) {
                        OpcionesVisibilidad()
                    }
                    Section(header: Text("SETTINGS_TIME")) {
                        StepperSegundos()
                    }
                }
                    .listStyle(.grouped)
                    .navigationBarTitle("SETTINGS_TITLE")
                    .navigationBarItems(trailing: Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        if #unavailable(iOS 26.0) {
                            Text(Image(systemName: "xmark.circle.fill"))
                                .foregroundColor(Color(.tertiaryLabel))
                        } else {
                            Text(Image(systemName: "xmark"))
                        }
                    })
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings_CustomPreview()
    }
}

struct Settings_CustomPreview: View {
    var body: some View {
        Settings().environmentObject(ViewModel())
    }
}
