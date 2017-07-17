//
//  GameOverVC.swift
//  FlappyBird
//
//  Created by Abhishek Thakur on 7/17/17.
//  Copyright © 2017 Abhishet. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    var playAgainNode: SKLabelNode?
    let score: Int
    
    init(size: CGSize, score: Int) {
        self.score = score
        super.init(size: size)
        
        backgroundColor = SKColor.white
        print("Score is: \(score)")
        let gameOverNode = SKLabelNode(fontNamed: "Chalkduster")
        gameOverNode.text = "Game Over"
        gameOverNode.fontSize = 40
        gameOverNode.fontColor = SKColor.black
        gameOverNode.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(gameOverNode)
        
        let scoreNode = SKLabelNode(fontNamed: "Chalkduster")
        scoreNode.text = "Your Score is \(score)"
        scoreNode.fontSize = 30
        scoreNode.fontColor = SKColor.black
        scoreNode.position = CGPoint(x: size.width/2, y: size.height/2 + 200)
        addChild(scoreNode)
        
        playAgainNode = SKLabelNode(fontNamed: "Chalkduster")
        playAgainNode?.text = "tap to play again"
        playAgainNode?.fontSize = 30
        playAgainNode?.fontColor = SKColor.black
        playAgainNode?.position = CGPoint(x: size.width/2, y: size.height/2 - 50)
        addChild(playAgainNode!)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if (playAgainNode?.contains(location))! {
                let gameScene = GameScene(fileNamed: "GameScene")
                view?.showsFPS = true
                view?.showsNodeCount = true
                view?.ignoresSiblingOrder = true
                gameScene?.scaleMode = .aspectFill
                view?.presentScene(gameScene)
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
