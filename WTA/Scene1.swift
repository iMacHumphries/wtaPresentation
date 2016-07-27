//
//  Scene1.swift
//  WTA
//
//  Created by Benjamin Humphries on 7/26/16.
//  Copyright © 2016 Marz Software. All rights reserved.
//

import SpriteKit

class Scene1: SKScene {
    var refBlobbers = [SKSpriteNode]()
    var fires = [SKEmitterNode]()
    var coreData: SKLabelNode!
    var swift: SKSpriteNode!
    var cloud: SKSpriteNode!
    var tv: SKLabelNode!
    var demo: SKLabelNode!

    var tapCount = 0

    override func didMoveToView(view: SKView) {
        demo = childNodeWithName("demo") as! SKLabelNode
        swift = childNodeWithName("swift") as! SKSpriteNode
        cloud = childNodeWithName("cloud") as! SKSpriteNode
        tv = childNodeWithName("tv") as! SKLabelNode
        coreData = childNodeWithName("coreData") as! SKLabelNode!

        enumerateChildNodesWithName("blob", usingBlock: { (blob, stop) in
            blob.hidden = true
            self.refBlobbers.append(blob as! SKSpriteNode)
        })

        enumerateChildNodesWithName("fire*") { (fire, stor) in
            self.fires.append(fire as! SKEmitterNode)
        }
        
        let physicsBody = SKPhysicsBody (edgeLoopFromRect: self.frame)
        self.physicsBody = physicsBody
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        switch tapCount {
        case 0:
            swift.runAction(.sequence([.fadeOutWithDuration(0.0), .unhide(), .group([.fadeInWithDuration(1.0), .scaleBy(1.2, duration: 1.0)]),.scaleTo(1.0, duration: 0.4)]))
        case 1:
            coreData.runAction(.sequence([.fadeAlphaTo(0.0, duration: 0.0), .scaleTo(0.0, duration: 0.0), .unhide(), .group([.fadeAlphaTo(1.0, duration: 1.0),.scaleTo(1.0, duration: 1.0)])]))
        case 2:
            tv.runAction(.sequence([.unhide(), .fadeAlphaTo(0.4, duration: 0.4), .fadeAlphaTo(1.0, duration: 1.0)]))
        case 3:
            cloud.runAction(.sequence([.scaleTo(0.1, duration: 0.0), .unhide(), .group([.scaleTo(1.0, duration: 1.0), .rotateByAngle(CGFloat(2 * M_PI * 2), duration: 2.0)])]))
        case 4:
             burnCoreData()
        case 5:
             hideCoreData()
        case 6:
            spawnBlobbers()
        case 7:
            blowUp()
        case _:
            break
        }

        tapCount += 1
    }

    func burnCoreData() {
        for (index, fire) in fires.enumerate() {
            let wait = 0.15 * Double(index)
            fire.runAction(.sequence([.waitForDuration(wait), .fadeOutWithDuration(0.0), .unhide(), .fadeInWithDuration(1.0)]), completion: {

            })
        }
    }

    func hideCoreData() {
        coreData.removeFromParent()
        for fire in fires {
            fire.runAction(SKAction.fadeOutWithDuration(1.0), completion: { 
                fire.removeFromParent()
            })
        }
    }

    func spawnBlobbers() {
        let spawnRound = SKAction.runBlock {
            for blob in self.refBlobbers {
                if let blobber = blob.copy() as? SKSpriteNode {
                    let delta = Int(self.scene!.size.width / 2)
                    blobber.position.x = CGFloat(Int.random(-delta...delta))
                    blobber.zRotation = CGFloat(arc4random_uniform(360))
                    blobber.hidden = false
                    self.addChild(blobber)
                    blobber.physicsBody?.affectedByGravity = true
                }
            }
        }

        let wait = SKAction.waitForDuration(0.5)
        runAction(.repeatActionForever(.sequence([spawnRound, wait])))
    }

    func blowUp() {
        demo.hidden = false
        removeAllActions()
        let blobber = SKSpriteNode(imageNamed: "blue")
        blobber.zPosition = 100
        self.addChild(blobber)
        blobber.runAction(.sequence([.scaleBy(11, duration: 1.5), .waitForDuration(0.2), SKAction(named: "pop_blue")!])) {
            for child in self.children {
                if child.name != "demo" {
                    child.hidden = true
                }
            }
        }

    }
}
