//
//  NEGAchievementsView.swift
//  Nemacolin Gaming
//
//

import SwiftUI

struct NEGAchievementsView: View {
    @StateObject var user = NEGUser.shared
    @Environment(\.presentationMode) var presentationMode
    @StateObject var shopVM = NEGShopViewModel()

    @StateObject var viewModel = NEGAchievementsViewModel()
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
                                .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 100:60)
                        }
                        
                        Spacer()
                        NEGCoinBg()
                    }
                    
                    HStack {
                        Image(.achievetsTextNEG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 150:80)
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
                }.frame(height: NEGDeviceManager.shared.deviceType == .pad ? 400:240)
                Spacer()
                
            }
        }.background(
            ZStack {
                if let bgItem = shopVM.currentBgItem {
                    Image(bgItem.image)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                }
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
            }
        )
    }
    
    @ViewBuilder func achievementItem(item: NEGAchievement) -> some View {
        
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
                        .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 140:70)
                        .scaleEffect(x: -1)
                }
                .opacity(index == 0 ? 0:1)
                
                Spacer()
                
                VStack(spacing: 16) {
                    
                    Text(item.title)
                        .font(.custom(Fonts.regular.rawValue, size: NEGDeviceManager.shared.deviceType == .pad ? 50:35))
                        .foregroundStyle(.yellow)
                    
                    HStack {
                        Image(item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 180:90)
                        
                        VStack(alignment: .leading) {
                            Text(item.subtitle)
                                .font(.custom(Fonts.regular.rawValue, size: NEGDeviceManager.shared.deviceType == .pad ? 30:20))
                                .foregroundStyle(.yellow)
                                .multilineTextAlignment(.leading)
                                .frame(width: NEGDeviceManager.shared.deviceType == .pad ? 700:400)
                            
                            Image(.rewardImageNEG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 50:30)
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
                        .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 140:70)
                }.opacity(index == viewModel.achievements.count - 1 ? 0:1)
            }
            VStack(spacing: 0) {
                
                Spacer()
                
                Image(.claimBtnNEG)
                    .resizable()
                    .scaledToFit()
                    .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 140:73)
                    .opacity(item.isAchieved ? 0:1)
                    .offset(y:NEGDeviceManager.shared.deviceType == .pad ? 70: 35)
                
            }
        }
    }
}


#Preview {
    NEGAchievementsView()
}
