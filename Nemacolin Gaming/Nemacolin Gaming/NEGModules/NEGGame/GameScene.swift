import SpriteKit
import Combine

class GameScene: SKScene {
    // Публикуем энергию и мозги для SwiftUI
    @Published private(set) var energy: Int = 100
    @Published private(set) var brains: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    private var lastSpawnTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        physicsWorld.gravity = .zero
        
        // Создадим лагерь-пример
        let camp = EnemyCamp(position: CGPoint(x: size.width/2, y: size.height/2))
        addChild(camp)
        
        // Таймер пополнения энергии
        let regen = SKAction.repeatForever(.sequence([
            .wait(forDuration: 1.0),
            .run { [weak self] in self?.energy = min(self!.energy + 5, 100) }
        ]))
        run(regen)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Обновляем спавн защитников лагерей
        for node in children.compactMap({ $0 as? EnemyCamp }) {
            node.update(currentTime: currentTime)
        }
    }
    
    // MARK: — Спавн зомби
    func spawnZombie(of type: ZombieType) {
        guard energy >= type.energyCost else { return }
        energy -= type.energyCost
        
        let zombie = Zombie(type: type)
        // Спавним внизу экрана в центре
        zombie.position = CGPoint(x: size.width/2, y: 50)
        addChild(zombie)
        
        // Даем команду атаковать ближайший лагерь
        zombie.targetCamp = children.compactMap { $0 as? EnemyCamp }.first
    }
    
    // MARK: — Заработок мозгов
    func collectBrains(_ amount: Int) {
        brains += amount
    }
}