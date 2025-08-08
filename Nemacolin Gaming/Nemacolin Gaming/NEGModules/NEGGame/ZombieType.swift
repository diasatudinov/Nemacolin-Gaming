
import SwiftUI
import SpriteKit


struct NGSpriteViewContainer: UIViewRepresentable {
    @StateObject var user = NEGUser.shared
    var scene: GameScene
    @Binding var showVictory: Bool
    @Binding var zombieSpawnRatio: CGFloat
    @Binding var zombieSpawnCount: Int
    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: UIScreen.main.bounds)
        skView.backgroundColor = .clear
        scene.scaleMode = .resizeFill
        scene.victoryHandler = {
            DispatchQueue.main.async {
                showVictory = true
            }
        }
        scene.zombieSpawnHandler = { ratio, count in
            DispatchQueue.main.async {
                zombieSpawnRatio = ratio
                zombieSpawnCount = count
            }
        }
        skView.presentScene(scene)
        
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        uiView.frame = UIScreen.main.bounds
    }
}
