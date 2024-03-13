import SwiftUI
import SpriteKit

class GameFourScene: SKScene, SKPhysicsContactDelegate {
    private var bgNode1: SKSpriteNode!
    private var bgNode2: SKSpriteNode!
    private var truck: SKSpriteNode!
    private var direction: CGFloat = 1.0
    private var obstacles: [SKSpriteNode] = []
    private var hearts: [SKSpriteNode] = []
    private let truckCategory: UInt32 = 0x1 << 0
    private let obstacleCategory: UInt32 = 0x1 << 1
    private var distanceLabel: SKLabelNode!
    private var distanceTraveled: CGFloat = 0
    
    override func didMove(to view: SKView) {
        createBackground()
        createTruck()
        physicsWorld.contactDelegate = self
        createHearts()
        spawnObstacles()
        
       distanceLabel = SKLabelNode(text: "0mi")
       distanceLabel = SKLabelNode(fontNamed: "PoetsenOne-Regular")
       distanceLabel.fontSize = 28
       distanceLabel.fontColor = .white
       distanceLabel.position = CGPoint(x: size.width - 53, y: size.height - 60)
       addChild(distanceLabel)
    
    }
    
    func createBackground() {
        bgNode1 = SKSpriteNode(imageNamed: "game_four_background")
        bgNode1.size = CGSize(width: size.width, height: size.height)
        bgNode1.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(bgNode1)
        
        bgNode2 = SKSpriteNode(imageNamed: "game_four_background")
        bgNode2.size = CGSize(width: size.width, height: size.height)
        bgNode2.position = CGPoint(x: frame.midX, y: frame.midY + bgNode1.size.height)
        addChild(bgNode2)
    }
    
    
    func createTruck() {
        truck = SKSpriteNode(imageNamed: "truck")
        truck.size = CGSize(width: 35, height: 120)
        truck.position = CGPoint(x: frame.midX, y: frame.minY + truck.size.height * 2)
        addChild(truck)
    }
    
    func createHearts() {
            for i in 0..<3 {
                let heart = SKSpriteNode(imageNamed: "bottle")
                heart.size = CGSize(width: 40, height: 100)
                heart.position = CGPoint(x: CGFloat(i) * heart.size.width + 30, y: size.height - 60)
                addChild(heart)
                hearts.append(heart)
            }
        }
    
    func createObstacle() {
        let obstacle = SKSpriteNode(imageNamed: "obstacle")
        obstacle.size = CGSize(width: 20, height: 60)
        obstacle.position = CGPoint(x: CGFloat.random(in: 100...frame.width - 80 - obstacle.size.width / 2), y: frame.height)
        addChild(obstacle)
        obstacles.append(obstacle)

        let moveAction = SKAction.moveTo(y: -30, duration: 2.8)
        let removeAction = SKAction.removeFromParent()
        obstacle.run(SKAction.sequence([moveAction, removeAction]))
    }


    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        direction *= -1
    }
    
    func spawnObstacles() {
        let spawnAction = SKAction.sequence([
            SKAction.run {
                self.createObstacle()
            },
            SKAction.wait(forDuration: 2)
        ])

        let spawnForeverAction = SKAction.repeatForever(spawnAction)
        run(spawnForeverAction, withKey: "spawnObstacles")
    }
    
    override func update(_ currentTime: TimeInterval) {
        scrollBackground()
        moveTruck()
        
        distanceTraveled += 0.01 // 임의의 속도
        distanceLabel.text = String(format: "%.2f mi", distanceTraveled)
        
        if distanceTraveled >= 10 {
            success()
        }
    }
    
    func scrollBackground() {
        bgNode1.position = CGPoint(x: bgNode1.position.x, y: bgNode1.position.y - 5)
        bgNode2.position = CGPoint(x: bgNode2.position.x, y: bgNode2.position.y - 5)
        
        if bgNode1.position.y < -bgNode1.size.height / 2 {
            bgNode1.position = CGPoint(x: frame.midX, y: bgNode2.position.y + bgNode2.size.height)
        }
        if bgNode2.position.y < -bgNode2.size.height / 2 {
            bgNode2.position = CGPoint(x: frame.midX, y: bgNode1.position.y + bgNode1.size.height)
        }
    }
    
    func handleCollision(obstacle: SKSpriteNode) {
        if let index = obstacles.firstIndex(of: obstacle) {
            obstacles.remove(at: index)
            obstacle.removeFromParent()

            if let heart = hearts.popLast() {
                heart.removeFromParent()
            }

            if hearts.isEmpty {
                gameOver()
            }
        }
    }

    func moveTruck() {
        truck.position = CGPoint(x: truck.position.x + 1 * direction, y: truck.position.y)
        
        if truck.position.x < 100 {
            truck.position.x = 100
        } else if truck.position.x > size.width - 80 - truck.size.width / 2 {
            truck.position.x = size.width - 80 - truck.size.width / 2
        }
        
        for obstacle in obstacles {
            if truck.intersects(obstacle) {
                handleCollision(obstacle: obstacle)
            }
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        var obstacle: SKSpriteNode?

        if contact.bodyA.categoryBitMask == truckCategory && contact.bodyB.categoryBitMask == obstacleCategory {
            obstacle = contact.bodyB.node as? SKSpriteNode
        } else if contact.bodyA.categoryBitMask == obstacleCategory && contact.bodyB.categoryBitMask == truckCategory {
            obstacle = contact.bodyA.node as? SKSpriteNode
        }

        if let obstacle = obstacle {
            handleCollision(obstacle: obstacle)
        }
    }



    func success() {
        isPaused = true
        NotificationCenter.default.post(name: NSNotification.Name("Success"), object: nil)
    }
    
    func gameOver() {
        isPaused = true
        NotificationCenter.default.post(name: NSNotification.Name("ReplayGame"), object: nil)
    }
}
