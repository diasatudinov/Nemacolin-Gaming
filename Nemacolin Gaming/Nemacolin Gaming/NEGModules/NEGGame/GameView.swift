//
//  GameView.swift
//  Nemacolin Gaming
//
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var gameScene: GameScene = {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        
        return scene
    }()
    @StateObject var shopVM = NEGShopViewModel()
    @State private var showVictory = false
    @State private var zombieSpawnRatio: CGFloat = 0.0
    @State private var zombieSpawnCount: Int = 0
    var level: Int?
    private let zombieMaxSpawnCount = 3
    
    var body: some View {
        ZStack {
            NGSpriteViewContainer(
                scene: gameScene,
                showVictory: $showVictory,
                zombieSpawnRatio: $zombieSpawnRatio,
                zombieSpawnCount: $zombieSpawnCount)
            .ignoresSafeArea()
            
            VStack {
                HStack(alignment: .top) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Image(.backIconNEG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 100:50)
                    }
                    if let level = level {
                        ZStack {
                            Image(.settingsBgNEG)
                                .resizable()
                            
                            Text("level:\(level)")
                                .font(.custom(Fonts.regular.rawValue, size: 14))
                                .foregroundColor(.yellow)
                            
                        }.frame(width: 80, height: 33)
                    }
                    Spacer()
                    
                    NEGCoinBg()
                }.padding([.horizontal, .top])
                
                Spacer()
                
                HStack(alignment: .bottom, spacing: 0) {
                    
                    Image(.iconZombieNEG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 200:100)
                    VStack(spacing: 0) {
                        
                        Text("\(zombieSpawnCount)/\(zombieMaxSpawnCount)")
                            .font(.custom(Fonts.regular.rawValue, size: 18))
                            .foregroundColor(.black)
                        
                        ZStack {
                            Image(.zombieLineBgNEG)
                                .resizable()
                                .scaledToFit()
                            
                            ProgressView(value: Double(zombieSpawnRatio))
                                .progressViewStyle(LinearProgressViewStyle(tint: .black))
                                .frame(width: 90)
                                .offset(y: 1.5)
                                .scaleEffect(y: 2.5)
                            
                        }
                        .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 60:35)
                    }
                    
                    Spacer()
                    
                }.padding()
            }
            if showVictory {
                Color.black.opacity(0.5).ignoresSafeArea()
                VStack {
                    Image(.winTitleTextNEG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 160:90)
                    ZStack {
                        Image(.winBgNEG)
                            .resizable()
                            .scaledToFit()
                        
                        VStack(spacing: 20) {
                            Spacer()
                            
                            HStack {
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                    
                                } label: {
                                    Image(.homeBtnNEG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 120:70)
                                }
                                
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                    
                                } label: {
                                    Image(.nextLvlNEG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 120:70)
                                }
                            }
                        }.padding()
                    }.frame(height: NEGDeviceManager.shared.deviceType == .pad ? 400:250)
                }
            }
        }.background(
            ZStack {
                Image(.gameBgNEG)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
                
            }
        )
    }
    
    
}

#Preview {
    GameView(level: 1)
}


struct NGRoundSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var shopVM = NEGShopViewModel()
    @State private var openLevel = false
    @State private var selectedLevel: Int? = nil
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 16) {
                ZStack {
                    HStack {
                        Image(.levelTextBgNEG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 100 : 50)
                    }
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(.backIconNEG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: NEGDeviceManager.shared.deviceType == .pad ? 100 : 50)
                        }
                        Spacer()
                        NEGCoinBg()
                    }
                    .padding([.horizontal, .top])
                }
                
                ScrollView {
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(Range(1...8)) { level in
                            Button {
                                selectedLevel = nil
                                DispatchQueue.main.async {
                                    selectedLevel = level
                                }
                                openLevel = true
                                
                            } label: {
                                ZStack {
                                    Image(.levelCardBgNEG)
                                        .resizable()
                                        .scaledToFit()
                                    Text("\(level)")
                                        .font(.custom(Fonts.regular.rawValue, size: NEGDeviceManager.shared.deviceType == .pad ? 40:28))
                                        .foregroundStyle(.yellow)
                                }.frame(height: NEGDeviceManager.shared.deviceType == .pad ? 200 : 110)
                                
                            }
                        }
                    }.frame(width: NEGDeviceManager.shared.deviceType == .pad ? 900 : 500)
                }
                
            }
            .padding()
            .background(
                ZStack {
                    if let bgItem = shopVM.currentBgItem {
                        Image(bgItem.image)
                            .resizable()
                            .edgesIgnoringSafeArea(.all)
                            .scaledToFill()
                    }
                }
            )
            .fullScreenCover(isPresented: $openLevel) {
                if let level = selectedLevel {
                    GameView(level: level)
                }
            }
        }
    }
}

#Preview {
    NGRoundSelectionView()
}
