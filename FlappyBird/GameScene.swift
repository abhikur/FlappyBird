import SpriteKit

struct PhysicsCategory {
    static let bird:UInt32 = 0x1 << 1
    static let ground: UInt32 = 0x1 << 2
    static let wall:UInt32 = 0x1 << 3
    static let score:UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ground = SKSpriteNode()
    var bird = SKSpriteNode()
    var scoreNode = SKSpriteNode()
    
    var wallPair = SKNode()
    
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    var score = 0
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        ground = SKSpriteNode(imageNamed: "ground")
        ground.setScale(1)
        ground.size = CGSize(width: 450, height: 60)
        ground.position = CGPoint(x: self.frame.width / 2, y: 0 + ground.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.bird
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        ground.zPosition = 3
        self.addChild(ground)
        
        bird = SKSpriteNode(imageNamed: "bird")
        bird.size = CGSize(width: 30, height: 35)
        bird.position = CGPoint(x: self.frame.width / 2 - bird.frame.width, y: self.frame.height / 2)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.frame.height / 2)
        bird.physicsBody?.categoryBitMask = PhysicsCategory.bird
        bird.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.wall
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.wall | PhysicsCategory.score
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        bird.zPosition = 2
        bird.physicsBody?.allowsRotation = false
        self.addChild(bird)
        
        
        self.addChild(scoreNode)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        print(firstBody.contactTestBitMask)
        
        if(firstBody.categoryBitMask == PhysicsCategory.wall && secondBody.categoryBitMask == PhysicsCategory.bird || firstBody.categoryBitMask == PhysicsCategory.ground && secondBody.categoryBitMask == PhysicsCategory.bird) {
            let gameOverScene = GameOverScene(size: self.size, score: score)
            self.view?.presentScene(gameOverScene)
        }
        
        if(firstBody.categoryBitMask == PhysicsCategory.score && secondBody.categoryBitMask == PhysicsCategory.bird) {
            score += 1
            print("Score is: \(score)")
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
            
            gameStarted = true
            bird.physicsBody?.affectedByGravity = true
            let spawn = SKAction.run ({
                () in
                self.createWall()
            })
            
            let delay = SKAction.wait(forDuration: 2.0)
            let spawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveBy( x: -distance, y: 0, duration: TimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15))
            
        }
        else{
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15))
        }
        
    }
   
    override func update(_ currentTime: TimeInterval) {
      
    }
    
    func createWall() {
        
        wallPair = SKNode()
        let scoreNode = SKSpriteNode()
        scoreNode.size = CGSize(width: 1, height: 200)
        scoreNode.position = CGPoint(x: self.frame.width, y: self.frame.height / 2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCategory.score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        
        let upperWall = SKSpriteNode(imageNamed: "wall")
        let lowerWall = SKSpriteNode(imageNamed: "wall")
        
        upperWall.size = CGSize(width: 40, height: 400)
        lowerWall.size = CGSize(width: 40, height: 400)
        
        upperWall.position = CGPoint(x: self.frame.width , y: self.frame.height / 2 + 300)
        lowerWall.position = CGPoint(x: self.frame.width , y: self.frame.height / 2 - 300)
        
        upperWall.physicsBody = SKPhysicsBody(rectangleOf: upperWall.size)
        upperWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        upperWall.physicsBody?.collisionBitMask = PhysicsCategory.bird
        upperWall.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        upperWall.physicsBody?.affectedByGravity = false
        upperWall.physicsBody?.isDynamic = false
        upperWall.zRotation = CGFloat(M_PI)
        
        lowerWall.physicsBody = SKPhysicsBody(rectangleOf: lowerWall.size)
        lowerWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        lowerWall.physicsBody?.collisionBitMask = PhysicsCategory.bird
        lowerWall.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        lowerWall.physicsBody?.affectedByGravity = false
        lowerWall.physicsBody?.isDynamic = false
        
        wallPair.zPosition = 1
        
        let randomPosition = CGFloat.random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        
        wallPair.addChild(upperWall)
        wallPair.addChild(lowerWall)
        wallPair.addChild(scoreNode)
        
        wallPair.run(moveAndRemove)
        self.addChild(wallPair)
    }
}
