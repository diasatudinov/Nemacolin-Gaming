//
//  NGSettingsViewModel.swift
//  Nemacolin Gaming
//
//


import SwiftUI

class NGSettingsViewModel: ObservableObject {
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
}
