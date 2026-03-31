//
//  DizzyFlowApp.swift
//  DizzyFlow
//
//  Created by SangHyouk Jin on 3/31/26.
//

import SwiftUI

@main
struct DizzyFlowApp: App {
    @StateObject private var workflowStore = WorkflowStore()

    var body: some Scene {
        WindowGroup {
            ContentView(store: workflowStore)
        }
    }
}
