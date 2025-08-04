//
//  NEGSettingsView.swift
//  Nemacolin Gaming
//
//

import SwiftUI

struct NEGSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var settingsVM: NGSettingsViewModel
    var body: some View {
        ZStack {
            
            VStack(alignment: .center, spacing: 0) {
                
                ZStack(alignment: .top) {
                    
                    Image(.settingTitleTextNEG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: NGDeviceManager.shared.deviceType == .pad ? 180:90)
                    
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.backIconNEG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: NGDeviceManager.shared.deviceType == .pad ? 100:50)
                        }
                        Spacer()
                        
                        NGCoinBg()
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
                                .frame(height: NGDeviceManager.shared.deviceType == .pad ? 130:70)
                            
                            Button {
                                withAnimation {
                                    settingsVM.soundEnabled.toggle()
                                }
                            } label: {
                                HStack(spacing: 20) {
                                    
                                    Image(settingsVM.soundEnabled ? .onNEG:.offNEG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: NGDeviceManager.shared.deviceType == .pad ? 70:38)
                                    
                                }
                            }
                        }
                        
                        Image(.englishTextNEG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: NGDeviceManager.shared.deviceType == .pad ? 130:73)
                    }.padding(.top)
                }.frame(width: NGDeviceManager.shared.deviceType == .pad ? 750:426,height: NGDeviceManager.shared.deviceType == .pad ? 400:250)
                Spacer()
            }.padding()
        }.background(
            ZStack {
                Image(.appBgNEG)
                    .resizable()
                    .scaledToFill()
                Color.black.opacity(0.6)
            }.edgesIgnoringSafeArea(.all)

        )
    }
}

#Preview {
    NEGSettingsView(settingsVM: NGSettingsViewModel())
}
