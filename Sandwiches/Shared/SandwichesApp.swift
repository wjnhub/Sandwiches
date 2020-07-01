//
//  SandwichesApp.swift
//  Shared
//
//  Created by wjn on 2020/7/1.
//

import SwiftUI

@main
struct SandwichesApp: App {
    @StateObject private var store = SandwichStore()

    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
