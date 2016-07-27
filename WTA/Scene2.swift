//
//  Scene2.swift
//  WTA
//
//  Created by Benjamin Humphries on 7/27/16.
//  Copyright © 2016 Marz Software. All rights reserved.
//

import SpriteKit

class Scene2: SKScene {

    var bug: SKSpriteNode!
    var coreAm: SKLabelNode!
    var spark: SKEmitterNode!
    var points = [SKNode]()
    let numBugs = 8
    var bugs = [SKSpriteNode]()

    override func didMoveToView(view: SKView) {
        enumerateChildNodesWithName("point") { (point, stop) in
            self.points.append(point)
        }

        coreAm = childNodeWithName("coreAm") as! SKLabelNode!
        spark = childNodeWithName("spark") as! SKEmitterNode!
        spark.particleBirthRate = 0.0

        bug = childNodeWithName("bug") as! SKSpriteNode!
        bug.hidden = false
        bugs.append(bug)

        for _ in 0..<numBugs {
            let newBug = bug.copy() as! SKSpriteNode
            addChild(newBug)
            move(newBug)
            bugs.append(newBug)
        }
        move(bug)

    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let bug = bugs.popLast() {
            bug.hidden = true
            bug.removeAllChildren()
            bug.removeAllActions()
        } else {
            spark.particleBirthRate = 380.0
            coreAm.runAction(.sequence([.fadeOutWithDuration(0.0), .unhide()]), completion: {
                self.coreAm.runAction(.fadeInWithDuration(1.0))
                self.spark.runAction(.sequence([.unhide(), .moveToX(self.coreAm.position.x + self.coreAm.frame.size.width/2, duration: 1.0), .hide()]), completion: {
                    self.spark.particleBirthRate = 0.0
                })

            })
        }
    }

    func move(node: SKNode) {
        let point = randomPoint()
        rotate(node, toFace: point) {
            node.runAction(.moveTo(point, duration: 1.0), completion: {
                self.move(node)
            })
        }
    }

    func randomPoint() -> CGPoint {
        return points[Int.random(0...points.count-1)].position
    }

    func rotate(node: SKNode, toFace point: CGPoint, completion: () -> ()) {
        let dx = point.x - node.position.x
        let dy = point.y - node.position.y
        let angle = atan2(dy, dx) - CGFloat(M_PI_2)

        if node.zRotation < 0 {
            node.zRotation = node.zRotation + CGFloat(M_PI * 2)
        }

        node.runAction(.rotateToAngle(angle, duration: 0.4), completion: completion)
    }
}
