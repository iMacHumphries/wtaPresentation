//
//  GameViewController.swift
//  WTA
//
//  Created by Benjamin Humphries on 7/26/16.
//  Copyright (c) 2016 Marz Software. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var myView: SKView!

    var index = 0
    let scenes = [Scene1(fileNamed: "Scene1")]

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = SKScene(fileNamed: "GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .Fill
            
            skView.presentScene(scene)
            myView = skView
        }
    }

    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        if presses.first?.type == .Menu {
            index -= 1
            guard index >= 0 else {
                index = 0
                return
            }
            myView.presentScene(scenes[index])
        }
    }

    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        guard index < scenes.count && presses.first?.type != .Menu else {
            return
        }

        myView.presentScene(scenes[index])
        index += 1
    }
}
