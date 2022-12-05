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
                Section(header: Text("Silabario")) {
                    Selectores()
                }
                Section(header: Text("Fuente")) {
                    SelectorFuente()
                }
                Section(header: Text("Visibilidad")) {
                    OpcionesVisibilidad()
                }
                Section(header: Text("Tiempo")) {
                    StepperSegundos()
                }
            }.listStyle(.plain)
                .navigationBarTitle("Settings")
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
