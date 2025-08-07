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
    @StateObject var shopVM = NGShopViewModel()
    @State private var collected: Int = 0
    @State private var gameOverMessage: String? = nil
    @State private var isWin = false
    var body: some View {
        ZStack {
            NGSpriteViewContainer(scene: gameScene)
                .ignoresSafeArea()
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
    GameView()
}
