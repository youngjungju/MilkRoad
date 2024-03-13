import SwiftUI
import SpriteKit

class GameOneScene: SKScene, SKPhysicsContactDelegate {
    private var bgNode1: SKSpriteNode!
    private var bgNode2: SKSpriteNode!
    private var truck: SKSpriteNode!
    private var direction: CGFloat = 1.0
    private var obstacles: [SKSpriteNode] = []
    private var gauges: [SKSpriteNode] = []
    private let truckCategory: UInt32 = 0x1 << 0
    private let obstacleCategory: UInt32 = 0x1 << 1
    private var distanceLabel: SKLabelNode!
    private var distanceTraveled: CGFloat = 0
    private var gaugeBottle: SKSpriteNode!
    private var countdownLabel: SKLabelNode!
    private var countdown: Int = 3

    
    override func didMove(to view: SKView) {
        createBackground()
        createTruck()
        physicsWorld.contactDelegate = self
        spawnObstacles()
        createMilk()
        createGauges()
    }
    
    func createBackground() {
        bgNode1 = SKSpriteNode(imageNamed: "game_one_background")
        bgNode1.size = CGSize(width: size.width, height: size.height)
        bgNode1.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(bgNode1)
    }
    
    func createMilk() {
        bgNode1 = SKSpriteNode(imageNamed: "cow_milk")
        bgNode1.size = CGSize(width: size.width, height: size.height)
        bgNode1.position = CGPoint(x: frame.midX, y: frame.midY)
        bgNode1.zPosition = 100
        addChild(bgNode1)
    }
    
    func createTruck() {
        truck = SKSpriteNode(imageNamed: "bottle")
        truck.size = CGSize(width: 40, height: 160)
        truck.position = CGPoint(x: frame.midX, y: frame.minY + truck.size.height)
        addChild(truck)
    }
    
    func createGauges() {
        let yOffset: CGFloat = 100
        for i in 0..<10 {
            let gauge = SKSpriteNode(color: .gray, size: CGSize(width: 35, height: 50))
            gauge.anchorPoint = CGPoint(x: 0.5, y: 0)
            gauge.position = CGPoint(x: size.width - 60, y: CGFloat(i) * gauge.size.height + yOffset)
            addChild(gauge)
            gauges.append(gauge)
        }
    }

    func createObstacle() {
        let obstacle = SKSpriteNode()
        obstacle.size = CGSize(width: 30, height: 60)
        obstacle.position = CGPoint(x: CGFloat.random(in: 35...(size.width - 120 - obstacle.size.width / 2)), y: frame.height)
        addChild(obstacle)
        obstacles.append(obstacle)

        let gifFrames: [SKTexture] = [
            SKTexture(imageNamed: "milk_drop_frame1"),
            SKTexture(imageNamed: "milk_drop_frame2"),
            SKTexture(imageNamed: "milk_drop_frame3"),
            SKTexture(imageNamed: "milk_drop_frame4"),

        ]

        let animateAction = SKAction.animate(with: gifFrames, timePerFrame: 0.1)
        obstacle.run(SKAction.repeatForever(animateAction))

        var speed: CGFloat = 0.1
        let moveAction = SKAction.customAction(withDuration: 5) { node, elapsedTime in
            node.position.y -= speed
            speed += 0.1
        }
        let repeatForeverAction = SKAction.repeatForever(moveAction)
        obstacle.run(repeatForeverAction)
    }


    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            if truck.frame.contains(location) {
                let previousLocation = t.previousLocation(in: self)
                let deltaX = location.x - previousLocation.x
                truck.position.x += deltaX
                if truck.position.x < 35 {
                    truck.position.x = 35
                } else if truck.position.x > size.width - 120 - truck.size.width / 2 {
                    truck.position.x = size.width - 120 - truck.size.width / 2
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for obstacle in obstacles {
            if truck.intersects(obstacle) {
                handleCollision(obstacle: obstacle)
            }
        }
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

    func handleCollision(obstacle: SKSpriteNode) {
        if let index = obstacles.firstIndex(of: obstacle) {
            obstacles.remove(at: index)
            obstacle.removeFromParent()

            if gauges.count >= 0 {
                let gauge = gauges.removeFirst()
                let filledGauge = SKSpriteNode(color: .white, size: CGSize(width: 35, height: 0))
                filledGauge.anchorPoint = CGPoint(x: 0.5, y: 0)
                filledGauge.position = gauge.position
                addChild(filledGauge)
                
                let increaseHeight = SKAction.resize(toHeight: gauge.size.height, duration: 0.5)
                filledGauge.run(increaseHeight)
                
            }

            if gauges.count == 0 {
                success()
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
        let wait = SKAction.wait(forDuration: 1)
        let pause = SKAction.run { [weak self] in
            self?.isPaused = true
        }
        let sequence = SKAction.sequence([wait, pause])
        run(sequence)
        
        NotificationCenter.default.post(name: NSNotification.Name("Success"), object: nil)
    }

}
