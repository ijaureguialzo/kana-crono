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
            }.listStyle(.plain)
                .navigationBarTitle("SETTINGS_TITLE")
                .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                    Text(Image(systemName: "xmark.circle"))
                        .foregroundColor(Color(UIColor.lightGray))
                        .opacity(0.33)
                })

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
