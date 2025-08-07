import SpriteKit

enum ZombieType {
    case walker
    case brute
    
    var energyCost: Int {
        switch self {
        case .walker: return 10
        case .brute:  return 20
        }
    }
    
    var maxHealth: CGFloat {
        switch self {
        case .walker: return 50
        case .brute:  return 120
        }
    }
    
    var damage: CGFloat {
        switch self {
        case .walker: return 10
        case .brute:  return 25
        }
    }
    
    var speed: CGFloat {
        switch self {
        case .walker: return 80
        case .brute:  return 50
        }
    }
    
    var textureName: String {
        switch self {
        case .walker: return "zombie_walk"
        case .brute:  return "zombie_brute"
        }
    }
}

class Zombie: SKSpriteNode {
    let type: ZombieType
    var health: CGFloat
    weak var targetCamp: EnemyCamp?
    
    init(type: ZombieType) {
        self.type = type
        self.health = type.maxHealth
        let tex = SKTexture(imageNamed: type.textureName)
        super.init(texture: tex, color: .clear, size: tex.size())
        name = "Zombie"
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody?.categoryBitMask = 1
        physicsBody?.contactTestBitMask = 2
        physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func update(_ currentTime: TimeInterval) {
        guard let camp = targetCamp else { return }
        // Движемся к лагерю
        let dir = (camp.position - position).normalized()
        position += dir * (type.speed * CGFloat(1.0/60.0))
    }
    
    func takeDamage(_ dmg: CGFloat) {
        health -= dmg
        if health <= 0 {
            removeFromParent()
            // Сообщаем сцене о добытых мозгах
            (scene as? GameScene)?.collectBrains(5)
        }
    }
}