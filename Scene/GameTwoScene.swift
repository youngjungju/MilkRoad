import SwiftUI
import SpriteKit

class GameTwoScene: SKScene {
    var bgNode1: SKSpriteNode!
    var bgNode2: SKSpriteNode!
    
    let balloonTextures: [SKTexture] = [
        SKTexture(imageNamed: "bad_bacteria"),
        SKTexture(imageNamed: "good_bacteria1"),
        SKTexture(imageNamed: "good_bacteria2"),
        SKTexture(imageNamed: "good_bacteria3")
    ]
    
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Pasteurization levels : \(score)%"
            
            if score >= 100 {
                success()
            }
        }
    }
    
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white

        let balloonSpawnAction = SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.run(spawnBalloon)
        ])
        
        run(SKAction.repeatForever(balloonSpawnAction))
        
        scoreLabel = SKLabelNode(fontNamed: "PoetsenOne-Regular")
        scoreLabel.fontSize = 48
        scoreLabel.fontColor = .black
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        scoreLabel.text = "Pasteurization levels : 0%"
        addChild(scoreLabel)
        
        createBackground()
    }
    
    func createBackground() {
        bgNode1 = SKSpriteNode(imageNamed: "game_two_background")
        bgNode1.anchorPoint = CGPoint(x: 0, y: 0.5)
        bgNode1.position = CGPoint(x: 0, y: size.height / 2)
        bgNode1.size = CGSize(width: size.width, height: size.height)
        bgNode1.zPosition = -1
        bgNode1.name = "background"
        addChild(bgNode1)
        
        bgNode2 = SKSpriteNode(imageNamed: "game_two_background")
        bgNode2.anchorPoint = CGPoint(x: 0, y: 0.5)
        bgNode2.position = CGPoint(x: bgNode1.size.width, y: size.height / 2)
        bgNode2.size = CGSize(width: size.width, height: size.height)
        bgNode2.zPosition = -1
        bgNode2.name = "background"
        addChild(bgNode2)
        
        let moveLeft = SKAction.moveBy(x: -bgNode1.size.width, y: 0, duration: 20)
        let moveReset = SKAction.moveBy(x: bgNode1.size.width, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)

        bgNode1.run(moveForever)
        bgNode2.run(moveForever)
    }
    
    func spawnBalloon() {
        let balloon = SKSpriteNode(texture: balloonTextures.randomElement())
        balloon.size = CGSize(width: 70, height: 70)
        balloon.position = CGPoint(x: 0, y: CGFloat.random(in: 160..<size.height-170))
        
        let moveAction = SKAction.move(to: CGPoint(x: size.width+100, y: CGFloat.random(in: 160..<size.height-170)), duration: 8.0)
        let removeAction = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([moveAction, removeAction])
        
        balloon.run(sequenceAction)
        addChild(balloon)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            
            let location = touch.location(in: self)
            let nodes = nodes(at: location)
            
            for node in nodes {
                if node.name == "background" {
                    continue
                }
                
                if let balloonNode = node as? SKSpriteNode {
                    if balloonNode.texture == balloonTextures[0]{
                        score += 10
                    } else {
                        score -= 10
                    }
                    
                    balloonNode.removeFromParent()
                }
            }
        }
    
    func success() {

        NotificationCenter.default.post(name: NSNotification.Name("Success"), object: nil)
    }

}
