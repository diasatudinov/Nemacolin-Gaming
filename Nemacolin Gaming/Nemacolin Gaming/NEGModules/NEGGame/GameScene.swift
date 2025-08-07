//
//  GameScene.swift
//  Nemacolin Gaming
//
//


import Combine
import SpriteKit

class GameScene: SKScene {
    // Tower
        private let tower = SKSpriteNode(texture: SKTexture(imageNamed: "tower"), size: CGSize(width: 90, height: 90))
        private var towerHealth = 100
        private let towerMaxHealth = 100
        private var towerHealthBar: SKShapeNode!
        private let zoneRadius: CGFloat = 160
        private var zoneNode: SKShapeNode!

        // Spawn timing
        private var lastZombieSpawnTime: TimeInterval = 0
        private let zombieSpawnInterval: TimeInterval = 5
        private var zombieSpawnCount = 0
        private let zombieMaxSpawnCount = 3
        private var lastGuardSpawnTime: TimeInterval = 0
        private let guardSpawnInterval: TimeInterval = 10
        private var guardSpawnCount = 0
        private let guardMaxCount = 5

        // Combat stats
        private let guardAttackDamage = 10
        private let zombieAttackDamage = 15
        private let attackInterval: TimeInterval = 1.0
        private let minCombatDistance: CGFloat = 50 // half-width + half-width

        // Health values
        private let zombieMaxHealth = 100
        private let guardMaxHealth = 120

        override func didMove(to view: SKView) {
            backgroundColor = .clear
            setupTower()
            drawZone()
            // Initial guards (level 1: 2 guards)
            for _ in 0..<2 { spawnGuard() }
            lastZombieSpawnTime = 0; lastGuardSpawnTime = 0
        }

        override func update(_ currentTime: TimeInterval) {
            handleSpawns(currentTime)
            updateTowerHealthBar()

            // Gather entities
            let zombies = children.compactMap { $0 as? SKSpriteNode }.filter { $0.name == "zombie" }
            var guards = children.compactMap { $0 as? SKSpriteNode }.filter { $0.name == "guard" }

            // Guard behavior: move towards and attack nearest zombie
            for guardd in guards {
                guard let gNext = guardd.userData?["nextAttack"] as? TimeInterval,
                      let gHealth = guardd.userData?["health"] as? Int,
                      gHealth > 0,
                      currentTime >= gNext else { continue }
                if let target = zombies.min(by: { guardd.position.distance(to: $0.position) < guardd.position.distance(to: $1.position) }) {
                    let dist = guardd.position.distance(to: target.position)
                    if dist > minCombatDistance {
                        move(guardd, to: target.position)
                    } else {
                        // Attack when within range
                        if var zHealth = target.userData?["health"] as? Int {
                            zHealth -= guardAttackDamage
                            target.userData?["health"] = zHealth
                            updateHealthBar(for: target)
                            if zHealth <= 0 { removeEntity(target) }
                            guardd.userData?["nextAttack"] = currentTime + attackInterval
                        }
                    }
                }
            }

            // Update guards list after possible removals
            guards = children.compactMap { $0 as? SKSpriteNode }.filter { $0.name == "guard" }

            // Zombie behavior: prioritize guards; attack tower only if no guards remain
            for zombie in zombies {
                guard let zNext = zombie.userData?["nextAttack"] as? TimeInterval,
                      let zHealth = zombie.userData?["health"] as? Int,
                      zHealth > 0 else { continue }

                if !guards.isEmpty {
                    if let target = guards.min(by: { zombie.position.distance(to: $0.position) < zombie.position.distance(to: $1.position) }) {
                        let dist = zombie.position.distance(to: target.position)
                        if dist > minCombatDistance {
                            move(zombie, to: target.position)
                        } else if currentTime >= zNext {
                            // Attack guard
                            if var gHealth = target.userData?["health"] as? Int {
                                gHealth -= zombieAttackDamage
                                target.userData?["health"] = gHealth
                                updateHealthBar(for: target)
                                if gHealth <= 0 { removeEntity(target) }
                                zombie.userData?["nextAttack"] = currentTime + attackInterval
                            }
                        }
                    }
                } else {
                    // No guards left: move towards and attack tower
                    let towerDistanceThreshold = tower.size.width/2 + zombie.size.width/2
                    let distToTower = zombie.position.distance(to: tower.position)
                    if distToTower > towerDistanceThreshold {
                        move(zombie, to: tower.position)
                    } else if currentTime >= zNext {
                        // Stand and attack tower
                        towerHealth -= zombieAttackDamage
                        updateTowerHealthBar()
                        zombie.userData?["nextAttack"] = currentTime + attackInterval
                        if towerHealth <= 0 { gameOver() }
                    }
                }
            }
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard zombieSpawnCount > 0, let touch = touches.first else { return }
            let location = touch.location(in: self)
            if location.distance(to: tower.position) >= zoneRadius {
                spawnZombie(at: location)
                zombieSpawnCount -= 1
            }
        }

        // MARK: - Setup Methods
        private func setupTower() {
            tower.position = CGPoint(x: size.width/2, y: size.height/2)
            addChild(tower)
            towerHealthBar = SKShapeNode(rectOf: CGSize(width: tower.size.width, height: 6), cornerRadius: 3)
            towerHealthBar.strokeColor = .black
            towerHealthBar.lineWidth = 1
            towerHealthBar.fillColor = .green
            towerHealthBar.position = CGPoint(x: 0, y: tower.size.height/2 + 10)
            tower.addChild(towerHealthBar)
        }

        private func drawZone() {
            zoneNode = SKShapeNode(circleOfRadius: zoneRadius)
            zoneNode.position = tower.position
            zoneNode.strokeColor = .black
            zoneNode.lineWidth = 2
            zoneNode.fillColor = SKColor.black.withAlphaComponent(0.1)
            addChild(zoneNode)
        }

        // MARK: - Spawning
        private func handleSpawns(_ currentTime: TimeInterval) {
            if currentTime - lastZombieSpawnTime >= zombieSpawnInterval {
                zombieSpawnCount = min(zombieMaxSpawnCount, zombieSpawnCount + 1)
                lastZombieSpawnTime = currentTime
            }
            if currentTime - lastGuardSpawnTime >= guardSpawnInterval {
                if guardSpawnCount < guardMaxCount { spawnGuard() }
                lastGuardSpawnTime = currentTime
            }
        }

        private func spawnZombie(at position: CGPoint) {
            let node = SKSpriteNode(texture: SKTexture(imageNamed: "zombie"), size: CGSize(width: 50, height: 50))
            node.name = "zombie"
            node.position = position
            node.userData = ["health": zombieMaxHealth, "nextAttack": 0.0]
            addChild(node)
            addHealthBar(to: node)
        }

        private func spawnGuard() {
            let node = SKSpriteNode(texture: SKTexture(imageNamed: "guard"), size: CGSize(width: 50, height: 50))
            node.name = "guard"
            let offset = randomPointOnCircle(radius: zoneRadius)
            node.position = CGPoint(x: tower.position.x + offset.x, y: tower.position.y + offset.y)
            node.userData = ["health": guardMaxHealth, "nextAttack": 0.0]
            addChild(node)
            addHealthBar(to: node)
            guardSpawnCount += 1
        }

        private func randomPointOnCircle(radius: CGFloat) -> CGPoint {
            let angle = CGFloat.random(in: 0..<(2 * .pi))
            return CGPoint(x: cos(angle) * radius, y: sin(angle) * radius)
        }

        // MARK: - Movement
        private func move(_ sprite: SKSpriteNode, to target: CGPoint) {
            let dx = target.x - sprite.position.x
            let dy = target.y - sprite.position.y
            let angle = atan2(dy, dx)
            let speed: CGFloat = 80
            let delta = CGFloat(1.0/60.0)
            sprite.position.x += cos(angle) * speed * delta
            sprite.position.y += sin(angle) * speed * delta
        }

        // MARK: - Health Bars
        private func addHealthBar(to node: SKSpriteNode) {
            let bar = SKShapeNode(rectOf: CGSize(width: node.size.width, height: 5), cornerRadius: 2)
            bar.strokeColor = .black
            bar.lineWidth = 1
            bar.fillColor = .green
            bar.name = "healthBar"
            bar.position = CGPoint(x: 0, y: node.size.height/2 + 8)
            node.addChild(bar)
            updateHealthBar(for: node)
        }

        private func updateHealthBar(for node: SKSpriteNode) {
            guard let health = node.userData?["health"] as? Int,
                  let bar = node.childNode(withName: "healthBar") as? SKShapeNode else { return }
            let maxHealth = node.name == "zombie" ? zombieMaxHealth : guardMaxHealth
            let ratio = max(0, CGFloat(health) / CGFloat(maxHealth))
            bar.xScale = ratio
        }

        private func updateTowerHealthBar() {
            let ratio = max(0, CGFloat(towerHealth) / CGFloat(towerMaxHealth))
            towerHealthBar.xScale = ratio
        }

        // MARK: - Removal & GameOver
        private func removeEntity(_ node: SKSpriteNode) {
            node.removeAllChildren()
            node.removeFromParent()
        }

        private func gameOver() {
            isUserInteractionEnabled = false
            let label = SKLabelNode(text: "Zombies Win!")
            label.fontSize = 36; label.fontColor = .red
            label.position = CGPoint(x: size.width/2, y: size.height/2)
            addChild(label)
        }
    }

// MARK: - CGPoint Extension
private extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        hypot(x - point.x, y - point.y)
    }
}
