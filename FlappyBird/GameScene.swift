import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    
    var gameStarted = Bool()
    var score = 0
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        
        let ground = ObjectCreator.createGround(frame: frame)
        self.addChild(ground)
        
        bird = ObjectCreator.createBird(frame: frame)
        self.addChild(bird)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
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
                let wallPair = ObjectCreator.createWallPair(frame: self.frame)
                self.addChild(wallPair)
            })
            
            let delay = SKAction.wait(forDuration: 2.0)
            let spawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            self.run(spawnDelayForever)
            
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
            
        }
        else{
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
        }
        
    }
}
