//
//  PlayerNode.swift
//  TextShooter
//
//  Created by Molly Maskrey on 7/21/16.
//  Copyright © 2016 Apress Inc. All rights reserved.
//

import SpriteKit

class PlayerNode: SKNode {
    override init() {
        super.init()
        name = "Player \(self)"
        initNodeGraph()
        initPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func moveToward(_ location: CGPoint) {
        removeAction(forKey: "movement")
        removeAction(forKey: "wobbling")
            
        let distance = pointDistance(position, location)
        let screenWidth = UIScreen.main.bounds.size.width
        let duration = TimeInterval(2 * distance/screenWidth)
        
        run(SKAction.move(to: location, duration: duration),
                                  withKey:"movement")
            
        let wobbleTime = 0.3
        let halfWobbleTime = wobbleTime/2
        let wobbling = SKAction.sequence([
                SKAction.scaleX(to: 0.2, duration: halfWobbleTime),
                SKAction.scaleX(to: 1.0, duration: halfWobbleTime)
        ])
        let wobbleCount = Int(duration/wobbleTime)
        run(SKAction.repeat(wobbling, count: wobbleCount),
                                        withKey:"wobbling")
   }
    
    override func receiveAttacker(_ attacker: SKNode, contact: SKPhysicsContact) {
        let path = Bundle.main.path(forResource:"EnemyExplosion",
                                ofType: "sks")
        let explosion = NSKeyedUnarchiver.unarchiveObject(withFile: path!)
                                as! SKEmitterNode
        explosion.numParticlesToEmit = 50
        explosion.position = contact.contactPoint
        scene!.addChild(explosion)
        
        run(SKAction.playSoundFileNamed("playerHit.wav",
                                waitForCompletion: false))
    }
   
    private func initNodeGraph() {
        let label = SKLabelNode(fontNamed: "Courier")
        label.fontColor = SKColor.darkGray
        label.fontSize = 40
        label.text = "v"
        label.zRotation = CGFloat(M_PI)
        label.name = "label"
        self.addChild(label)
    }
    
    private func initPhysicsBody() {
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
        body.affectedByGravity = false
        body.categoryBitMask = PlayerCategory
        body.contactTestBitMask = EnemyCategory
        body.collisionBitMask = 0
        body.fieldBitMask = 0
        physicsBody = body
    }
}
