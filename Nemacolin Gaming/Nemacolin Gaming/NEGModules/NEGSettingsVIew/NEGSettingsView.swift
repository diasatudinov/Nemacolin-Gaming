//
//  NEGSettingsView.swift
//  Nemacolin Gaming
//
//

import SwiftUI

struct NEGSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var shopVM = NEGShopViewModel()
    @ObservedObject var settingsVM: NGSettingsViewModel
    var body: some View {
        ZStack {
            
            VStack(alignment: .center, spacing: 0) {
                
                ZStack(alignment: .top) {
                    
                    Image(.settingTitleTextNEG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 180:90)
                    
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.backIconNEG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 100:50)
                        }
                        Spacer()
                        
                        NEGCoinBg()
                    }.padding([.horizontal, .top])
                }
                
                ZStack {
                    
                    Image(.settingsBgNEG)
                        .resizable()
                        .scaledToFit()
                    
                    VStack {
                        
                        HStack(spacing: 30) {
                            Image(settingsVM.soundEnabled ? .soundsIconOnNEG:.soundsIconOffNEG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 130:70)
                            
                            Button {
                                withAnimation {
                                    settingsVM.soundEnabled.toggle()
                                }
                            } label: {
                                HStack(spacing: 20) {
                                    
                                    Image(settingsVM.soundEnabled ? .onNEG:.offNEG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 70:38)
                                    
                                }
                            }
                        }
                        
                        Image(.englishTextNEG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 130:73)
                    }.padding(.top)
                }.frame(width: NEGDeviceManager.shared.deviceType == .pad ? 750:426,height: NEGDeviceManager.shared.deviceType == .pad ? 400:250)
                Spacer()
            }.padding()
        }.background(
            ZStack {
                if let bgItem = shopVM.currentBgItem {
                    Image(bgItem.image)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                }
                
                Color.black.opacity(0.6)
            }.edgesIgnoringSafeArea(.all)

        )
    }
}

#Preview {
    NEGSettingsView(settingsVM: NGSettingsViewModel())
}
