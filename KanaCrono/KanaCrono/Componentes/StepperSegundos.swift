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

    var body: some View {
        if sizeClass == .regular {
            Stepper(onIncrement: incrementStep,
                onDecrement: decrementStep) {
                Text("\(segundos) segundos")
            } .scaleEffect(0.8)
        } else {
            VStack {
                Stepper("", onIncrement: incrementStep,
                    onDecrement: decrementStep)
                    .labelsHidden()
                Text("\(segundos) segundos")
            } .scaleEffect(0.8)
        }
    }

    func incrementStep() {
        segundos += 1
        if segundos >= 60 { segundos = 60 }
    }

    func decrementStep() {
        segundos -= 1
        if segundos < 2 {
            segundos = 2
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