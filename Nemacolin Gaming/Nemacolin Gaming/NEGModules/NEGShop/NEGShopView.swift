//
//  NEGShopView.swift
//  Nemacolin Gaming
//
//

import SwiftUI

struct NEGShopView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var user = NGUser.shared
    @ObservedObject var viewModel: NGShopViewModel
    @State var category: NGItemCategory?
    var categoryArray: [NGItemCategory] = [.skin, .background]
    @State var bgIndex = 0
    @State var skinIndex = 0
    
    var body: some View {
        ZStack {
            
            VStack {
                
                ZStack(alignment: .top) {
                    
                    Image(.shopTextNEG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: NGDeviceManager.shared.deviceType == .pad ? 180:90)
                    
                    HStack(alignment: .center) {
                        Button {
                            if let category = category {
                                self.category = nil
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
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
                Spacer()
                ZStack {
                    Image(.settingsBgNEG)
                        .resizable()
                        .scaledToFit()
                    
                    if let category = category {
                        switch category {
                        case .skin:
                            
                            HStack {
                                Button {
                                    if skinIndex > 0 {
                                        skinIndex -= 1
                                    }
                                } label: {
                                    Image(.rightBtnNEG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: NGDeviceManager.shared.deviceType == .pad ? 140:70)
                                        .scaleEffect(x: -1)
                                }
                                .opacity(skinIndex == 0 ? 0:1)
                                
                                shopSkinItem(skin: viewModel.shopSkinItems[skinIndex])
                                
                                Button {
                                    if skinIndex < viewModel.shopSkinItems.count - 1 {
                                        skinIndex += 1
                                    }
                                } label: {
                                    Image(.rightBtnNEG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: NGDeviceManager.shared.deviceType == .pad ? 140:70)
                                }.opacity(skinIndex == viewModel.shopSkinItems.count - 1 ? 0:1)
                                
                            }
                        case .background:
                            HStack {
                                Button {
                                    if bgIndex > 0 {
                                        bgIndex -= 1
                                    }
                                } label: {
                                    Image(.rightBtnNEG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: NGDeviceManager.shared.deviceType == .pad ? 140:70)
                                        .scaleEffect(x: -1)
                                }
                                .opacity(bgIndex == 0 ? 0:1)
                                
                                shopBgItem(bg: viewModel.shopBgItems[bgIndex])
                                
                                Button {
                                    if bgIndex < viewModel.shopBgItems.count - 1 {
                                        bgIndex += 1
                                    }
                                } label: {
                                    Image(.rightBtnNEG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: NGDeviceManager.shared.deviceType == .pad ? 140:70)
                                }.opacity(bgIndex == viewModel.shopBgItems.count - 1 ? 0:1)
                                
                            }
                            
                            
                        }
                    } else {
                        VStack {
                            
                            Image(.bgBtnBEG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: NGDeviceManager.shared.deviceType == .pad ? 130:70)
                                .onTapGesture {
                                    withAnimation {
                                        self.category = .background
                                    }
                                }
                            
                            Image(.skinBtnBEG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: NGDeviceManager.shared.deviceType == .pad ? 130:70)
                                .onTapGesture {
                                    withAnimation {
                                        self.category = .skin
                                    }
                                }
                        }
                    }
                    
                    //                    VStack {
                    //                        Spacer()
                    //
                    //                        HStack {
                    //                            ForEach(categoryArray, id: \.self) { category in
                    //                                Image("\(category.rawValue)BtnNG")
                    //                                    .resizable()
                    //                                    .scaledToFit()
                    //                                    .frame(height: NGDeviceManager.shared.deviceType == .pad ? 80:46)
                    //                                    .offset(y: self.category == category ? -10:0)
                    //                                    .onTapGesture {
                    //                                        withAnimation {
                    //                                            self.category = category
                    //                                        }
                    //                                    }
                    //                            }
                    //                        }
                    //                    }
                }.frame(height: NGDeviceManager.shared.deviceType == .pad ? 500:270)
                Spacer()
            }
            
        }.background(
            ZStack {
                Image(.appBgNEG)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
        
    }
    
    @ViewBuilder func shopBgItem(bg: NGItem) -> some View {
        ZStack {
            VStack {
                Text("The background is a crowd of\nzombies")
                    .font(.custom(Fonts.regular.rawValue, size: NGDeviceManager.shared.deviceType == .pad ? 30:20))
                    .foregroundStyle(.yellow)
                    .multilineTextAlignment(.center)
                
                Image(.rewardImageNEG)
                    .resizable()
                    .scaledToFit()
                    .frame(height: NGDeviceManager.shared.deviceType == .pad ? 50:30)
                
                Image("\(bg.image)")
                    .resizable()
                    .scaledToFit()
                    .frame(height: NGDeviceManager.shared.deviceType == .pad ? 200:115)
                    .cornerRadius(12)
                
            }.padding(.bottom)
            VStack {
                Spacer()
                
                Button {
                    viewModel.selectOrBuy(bg, user: user, category: .background)
                } label: {
                    if viewModel.isPurchased(bg, category: .background) {
                        ZStack {
                            Image(.btnBgNEG)
                                .resizable()
                                .scaledToFit()
                            Text(viewModel.isCurrentItem(item: bg, category: .background) ? "selected":"select")
                                .font(.custom(Fonts.regular.rawValue, size: NGDeviceManager.shared.deviceType == .pad ? 30:20))
                                .foregroundStyle(.yellow)
                        }.frame(height: NGDeviceManager.shared.deviceType == .pad ? 120:70)
                    } else {
                        Image(.buyBtnNEG)
                            .resizable()
                            .scaledToFit()
                            .opacity(viewModel.isMoneyEnough(item: bg, user: user, category: .background) ? 1:0.6)
                            .frame(height: NGDeviceManager.shared.deviceType == .pad ? 120:70)
                    }
                }
                .offset(y: 20)
            }.frame(height: NGDeviceManager.shared.deviceType == .pad ? 550:295)
        }
        
    }
    
    @ViewBuilder func shopSkinItem(skin: NGItem) -> some View {
        ZStack {
            VStack {
                Text("The background is a crowd of\nzombies")
                    .font(.custom(Fonts.regular.rawValue, size: NGDeviceManager.shared.deviceType == .pad ? 30:20))
                    .foregroundStyle(.yellow)
                    .multilineTextAlignment(.center)
                
                Image(.rewardImageNEG)
                    .resizable()
                    .scaledToFit()
                    .frame(height: NGDeviceManager.shared.deviceType == .pad ? 50:30)
                
                Image("\(skin.image)")
                    .resizable()
                    .scaledToFit()
                    .frame(height: NGDeviceManager.shared.deviceType == .pad ? 200:115)
                    .cornerRadius(12)
                
            }.padding(.bottom)
            VStack {
                Spacer()
                
                Button {
                    viewModel.selectOrBuy(skin, user: user, category: .skin)
                } label: {
                    if viewModel.isPurchased(skin, category: .skin) {
                        ZStack {
                            Image(.btnBgNEG)
                                .resizable()
                                .scaledToFit()
                            Text(viewModel.isCurrentItem(item: skin, category: .skin) ? "selected":"select")
                                .font(.custom(Fonts.regular.rawValue, size: NGDeviceManager.shared.deviceType == .pad ? 30:20))
                                .foregroundStyle(.yellow)
                        }.frame(height: NGDeviceManager.shared.deviceType == .pad ? 120:70)
                    } else {
                        Image(.buyBtnNEG)
                            .resizable()
                            .scaledToFit()
                            .opacity(viewModel.isMoneyEnough(item: skin, user: user, category: .skin) ? 1:0.6)
                            .frame(height: NGDeviceManager.shared.deviceType == .pad ? 120:70)
                    }
                }
                .offset(y: 20)
            }.frame(height: NGDeviceManager.shared.deviceType == .pad ? 550:295)
        }
    }
}

#Preview {
    NEGShopView(viewModel: NGShopViewModel())
}
