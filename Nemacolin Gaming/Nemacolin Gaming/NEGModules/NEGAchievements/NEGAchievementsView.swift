//
//  NEGAchievementsView.swift
//  Nemacolin Gaming
//
//

import SwiftUI

struct NEGAchievementsView: View {
    @StateObject var user = NGUser.shared
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = NGAchievementsViewModel()
    @State private var index = 0
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    HStack(alignment: .top) {
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.backIconNEG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: NGDeviceManager.shared.deviceType == .pad ? 100:60)
                        }
                        
                        Spacer()
                        NGCoinBg()
                    }
                    
                    HStack {
                        Image(.achievetsTextNEG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: NGDeviceManager.shared.deviceType == .pad ? 150:80)
                    }
                }.padding([.top])
                
                ZStack {
                    Image(.dailyRewardsBgNEG)
                        .resizable()
                        .scaledToFit()
                    
                    achievementItem(item: viewModel.achievements[index])
                        .onTapGesture {
                            viewModel.achieveToggle(viewModel.achievements[index])
                        }
                }.frame(height: NGDeviceManager.shared.deviceType == .pad ? 400:240)
                Spacer()
                
            }
        }.background(
            ZStack {
                Image(.appBgNEG)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
            }
        )
    }
    
    @ViewBuilder func achievementItem(item: MGAchievement) -> some View {
        
        ZStack {
            HStack {
                Button {
                    if index > 0 {
                        index -= 1
                    }
                } label: {
                    Image(.rightBtnNEG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: NGDeviceManager.shared.deviceType == .pad ? 140:70)
                        .scaleEffect(x: -1)
                }
                .opacity(index == 0 ? 0:1)
                
                Spacer()
                
                VStack(spacing: 16) {
                    
                    Text(item.title)
                        .font(.custom(Fonts.regular.rawValue, size: NGDeviceManager.shared.deviceType == .pad ? 50:35))
                        .foregroundStyle(.yellow)
                    
                    HStack {
                        Image(item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: NGDeviceManager.shared.deviceType == .pad ? 180:90)
                        
                        VStack(alignment: .leading) {
                            Text(item.subtitle)
                                .font(.custom(Fonts.regular.rawValue, size: NGDeviceManager.shared.deviceType == .pad ? 30:20))
                                .foregroundStyle(.yellow)
                                .multilineTextAlignment(.leading)
                                .frame(width: NGDeviceManager.shared.deviceType == .pad ? 700:400)
                            
                            Image(.rewardImageNEG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: NGDeviceManager.shared.deviceType == .pad ? 50:30)
                        }
                    }
                    
                }
                Spacer()
                Button {
                    if index < viewModel.achievements.count - 1 {
                        index += 1
                    }
                } label: {
                    Image(.rightBtnNEG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: NGDeviceManager.shared.deviceType == .pad ? 140:70)
                }.opacity(index == viewModel.achievements.count - 1 ? 0:1)
            }
            VStack(spacing: 0) {
                
                Spacer()
                
                Image(.claimBtnNEG)
                    .resizable()
                    .scaledToFit()
                    .frame(height: NGDeviceManager.shared.deviceType == .pad ? 140:73)
                    .opacity(item.isAchieved ? 0:1)
                    .offset(y:NGDeviceManager.shared.deviceType == .pad ? 70: 35)
                
            }
        }
    }
}


#Preview {
    NEGAchievementsView()
}
