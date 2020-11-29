//
//  KanaCronoApp.swift
//  KanaCrono
//
//  Created by Ion Jaureguialzo Sarasola on 28/11/20.
//

import SwiftUI

@main
struct KanaCronoApp: App {

    var config = Config()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(config)
        }
    }
}
