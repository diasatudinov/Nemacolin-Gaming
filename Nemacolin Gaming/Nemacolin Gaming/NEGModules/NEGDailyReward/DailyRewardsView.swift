//
//  DailyRewardsView.swift
//  Nemacolin Gaming
//
//

import SwiftUI

struct DailyRewardsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = DailyRewardsViewModel()
    @StateObject var shopVM = NEGShopViewModel()

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
    private let dayCellHeight: CGFloat = NEGDeviceManager.shared.deviceType == .pad ? 160:90
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    
                    Image(.dailyRewardTextNEG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 140:72)
                    
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
                Spacer()
                ZStack {
                    
                    Image(.dailyRewardsBgNEG)
                        .resizable()
                        .scaledToFit()
                        
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(1...viewModel.totalDaysCount, id: \.self) { day in
                            ZStack {
                                Image(.dayBgNEG)
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(viewModel.isDayClaimed(day) ? 1: viewModel.isDayUnlocked(day) ? 0.7:0.3)
                                    
                               
                                
                                
                                VStack {
                                    Text("Day \(day)")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundStyle(.yellow)
                                    Spacer()
                                }.padding(20)
                            }
                            .frame(height: dayCellHeight)
                            .offset(x: day > 4 ? dayCellHeight/2:0)
                            
                        }
                    }.frame(width: NEGDeviceManager.shared.deviceType == .pad ? 800:550)
                    
                    VStack {
                        Spacer()
                        Button {
                            viewModel.claimNext()
                        } label: {
                            Image(.claimBtnNEG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 140:72)
                        }.offset(y: NEGDeviceManager.shared.deviceType == .pad ? 70:35)
                    }
                    
                }
                .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 400:270)
                Spacer()
            }
            .padding()
            
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
    DailyRewardsView()
}
