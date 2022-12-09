//
//  StepperSegundos.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 20/12/20.
//

import SwiftUI

struct StepperSegundos: View {

    @EnvironmentObject var vm: ViewModel

    // REF: https://levelup.gitconnected.com/localization-with-swiftui-5abbeb275d5
    // REF: https://levelup.gitconnected.com/step-by-step-guide-for-localizing-plurals-in-ios-57f9deaade3e
    var body: some View {
        Stepper(value: $vm.segundos, in: 1...60) {
            Text("\(vm.segundos) SECONDS")
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
        List {
            StepperSegundos().environmentObject(ViewModel())
        }
    }
}
