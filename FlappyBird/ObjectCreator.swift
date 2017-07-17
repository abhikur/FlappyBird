import UIKit
import SpriteKit

struct PhysicsCategory {
    static let bird:UInt32 = 0x1 << 1
    static let ground: UInt32 = 0x1 << 2
    static let wall:UInt32 = 0x1 << 3
    static let score:UInt32 = 0x1 << 4
}

class ObjectCreator {
    
    static func createBird(frame: CGRect) -> SKSpriteNode {
        let bird = SKSpriteNode(imageNamed: "bird")
        bird.size = CGSize(width: 30, height: 35)
        bird.position = CGPoint(x: frame.width / 2 - bird.frame.width, y: frame.height / 2)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.frame.height / 2)
        bird.physicsBody?.categoryBitMask = PhysicsCategory.bird
        bird.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.wall
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.wall | PhysicsCategory.score
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        bird.zPosition = 2
        bird.physicsBody?.allowsRotation = false
        return bird
    }
    
    static func createGround(frame: CGRect) -> SKSpriteNode {
        let ground = SKSpriteNode(imageNamed: "ground")
        ground.setScale(1)
        ground.size = CGSize(width: 450, height: 60)
        ground.position = CGPoint(x: frame.width / 2, y: 0 + ground.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.bird
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        ground.zPosition = 3
        return ground
    }
    
    static func createScoreNode(frame: CGRect) -> SKSpriteNode {
        let scoreNode = SKSpriteNode()
        scoreNode.size = CGSize(width: 1, height: 200)
        scoreNode.position = CGPoint(x: frame.width, y: frame.height / 2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCategory.score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        return scoreNode
    }
    
    static func createLowerWall(frame: CGRect) -> SKSpriteNode {
        let lowerWall = SKSpriteNode(imageNamed: "wall")
        lowerWall.size = CGSize(width: 40, height: 400)
        lowerWall.position = CGPoint(x: frame.width , y: frame.height / 2 - 300)
        lowerWall.physicsBody = SKPhysicsBody(rectangleOf: lowerWall.size)
        lowerWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        lowerWall.physicsBody?.collisionBitMask = PhysicsCategory.bird
        lowerWall.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        lowerWall.physicsBody?.affectedByGravity = false
        lowerWall.physicsBody?.isDynamic = false
        return lowerWall
    }
    
    static func createUpperWall(frame: CGRect) -> SKSpriteNode {
        let upperWall = SKSpriteNode(imageNamed: "wall")
        upperWall.size = CGSize(width: 40, height: 400)
        upperWall.position = CGPoint(x: frame.width , y: frame.height / 2 + 300)
        upperWall.physicsBody = SKPhysicsBody(rectangleOf: upperWall.size)
        upperWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        upperWall.physicsBody?.collisionBitMask = PhysicsCategory.bird
        upperWall.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        upperWall.physicsBody?.affectedByGravity = false
        upperWall.physicsBody?.isDynamic = false
        upperWall.zRotation = CGFloat(M_PI)
        return upperWall
    }
    
    static func createWallPair(frame: CGRect) -> SKNode {
        let wallPair = SKNode()
        wallPair.zPosition = 1
        let randomPosition = CGFloat.random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        let upperWall = createUpperWall(frame: frame)
        let lowerWall = createLowerWall(frame: frame)
        wallPair.addChild(upperWall)
        wallPair.addChild(lowerWall)
        let scoreNode = createScoreNode(frame: frame)
        wallPair.addChild(scoreNode)
        addAction(toNode: wallPair, frame: frame)
        return wallPair
    }
    
    static func addAction(toNode node: SKNode, frame: CGRect) {
        var moveAndRemove = SKAction()
        let distance = CGFloat(frame.width + node.frame.width)
        let movePipes = SKAction.moveBy( x: -distance, y: 0, duration: TimeInterval(0.008 * distance))
        let removePipes = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([movePipes, removePipes])
        node.run(moveAndRemove)
    }
}
