//
//  NEGMenuView.swift
//  Nemacolin Gaming
//
//

import SwiftUI

struct NEGMenuView: View {
    @State private var showGame = false
    @State private var showShop = false
    @State private var showAchievement = false
    @State private var showMiniGames = false
    @State private var showSettings = false
    @State private var showCalendar = false
    @State private var showDailyTask = false
    
//    @StateObject var achievementVM = NGAchievementsViewModel()
//    @StateObject var settingsVM = NGSettingsViewModel()
//    @StateObject var shopVM = NGShopViewModel()
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 20) {
                    
                    Spacer()
                    
                    NGCoinBg()
                    
                    Button {
                        showSettings = true
                    } label: {
                        Image(.settingsIconNEG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: NGDeviceManager.shared.deviceType == .pad ? 100:50)
                    }
                    
                }.padding(15)
                
                Spacer()
                VStack(spacing: 7) {
                    HStack(alignment: .top) {
                        Button {
                            showGame = true
                        } label: {
                            Image(.playIconNEG)
                                .resizable()
                                .scaledToFit()
                        }
                        
                        Button {
                            showDailyTask = true
                        } label: {
                            Image(.dailyTasksIconNEG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: NGDeviceManager.shared.deviceType == .pad ? 120:66)
                        }.offset(y: -5)
                        
                    }.frame(height: NGDeviceManager.shared.deviceType == .pad ? 160:88)
                    
                    Button {
                        showShop = true
                    } label: {
                        Image(.shopIconNEG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: NGDeviceManager.shared.deviceType == .pad ? 160:88)
                    }.offset(x: 20)
                    
                    Button {
                        showAchievement = true
                    } label: {
                        Image(.achievementsIconNEG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: NGDeviceManager.shared.deviceType == .pad ? 160:88)
                    }.offset(x: -30)
                }
                Spacer()
            }
        }
        .background(
            ZStack {
                Image(.appBgNEG)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
        .fullScreenCover(isPresented: $showGame) {
//            NGRoundSelectionView()
        }
        .fullScreenCover(isPresented: $showAchievement) {
//            NGAchievementsView(viewModel: achievementVM)
        }
        .fullScreenCover(isPresented: $showShop) {
//            NGShopView(viewModel: shopVM)
        }
        .fullScreenCover(isPresented: $showSettings) {
//            NGSettingsView(settingsVM: settingsVM)
        }
        .fullScreenCover(isPresented: $showDailyTask) {
//            NGDailyTasksView()
        }
    }
    
}

#Preview {
    NEGMenuView()
}
