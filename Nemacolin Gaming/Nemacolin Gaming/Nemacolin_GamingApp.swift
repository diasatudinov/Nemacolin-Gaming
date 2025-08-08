//
//  Nemacolin_GamingApp.swift
//  Nemacolin Gaming
//
//

import SwiftUI

@main
struct Nemacolin_GamingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NGRoot()
                .preferredColorScheme(.light)
        }
    }
}
