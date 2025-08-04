//
//  NGCoinBg.swift
//  Nemacolin Gaming
//
//  Created by Dias Atudinov on 04.08.2025.
//


import SwiftUI

struct NGCoinBg: View {
    @StateObject var user = NGUser.shared
    var height: CGFloat = NGDeviceManager.shared.deviceType == .pad ? 100:50
    var body: some View {
        ZStack {
            Image(.coinsBgNEG)
                .resizable()
                .scaledToFit()
            
            Text("\(user.money)")
                .font(.system(size: NGDeviceManager.shared.deviceType == .pad ? 30:15, weight: .black))
                .foregroundStyle(.yellow)
                .textCase(.uppercase)
                .offset(x: -15)
            
            
            
        }.frame(height: height)
        
    }
}

#Preview {
    NGCoinBg()
}
