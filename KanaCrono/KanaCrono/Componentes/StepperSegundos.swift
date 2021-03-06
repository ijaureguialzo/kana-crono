//
//  StepperSegundos.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 20/12/20.
//

import SwiftUI

struct StepperSegundos: View {

    @Environment(\.verticalSizeClass) var sizeClass

    @Binding var segundos: Int

    // REF: https://levelup.gitconnected.com/localization-with-swiftui-5abbeb275d5
    // REF: https://levelup.gitconnected.com/step-by-step-guide-for-localizing-plurals-in-ios-57f9deaade3e
    var body: some View {
        if sizeClass == .regular {
            HStack {
                Text("\(segundos) SECONDS")
                    .padding(.trailing, 8)
                Stepper("Segundos", value: $segundos, in: 1...60)
                    .labelsHidden()
            } .scaleEffect(0.8)
        } else {
            VStack {
                Stepper("Segundos", value: $segundos, in: 1...60)
                    .labelsHidden()
                Text("\(segundos) SECONDS")
                    .padding(.top, 3)
            } .scaleEffect(0.8)
        }
    }
}

struct StepperSegundos_Previews: PreviewProvider {
    static var previews: some View {
        StepperSegundos_CustomPreview()
    }
}

struct StepperSegundos_CustomPreview: View {

    @State private var segundos = 5

    var body: some View {
        StepperSegundos(segundos: $segundos)
    }
}
