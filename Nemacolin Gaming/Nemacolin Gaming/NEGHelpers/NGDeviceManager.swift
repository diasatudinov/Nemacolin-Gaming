//
//  NGDeviceManager.swift
//  Nemacolin Gaming
//
//  Created by Dias Atudinov on 04.08.2025.
//


import UIKit

class NGDeviceManager {
    static let shared = NGDeviceManager()
    
    var deviceType: UIUserInterfaceIdiom
    
    private init() {
        self.deviceType = UIDevice.current.userInterfaceIdiom
    }
}