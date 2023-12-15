//
//  psy_i_rasyApp.swift
//  psy_i_rasy
//
//  Created by apple on 27/05/2023.
//

import SwiftUI

@main
struct psy_i_rasyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
