//
//  LevelsController.swift
//  space
//
//  Created by Tareq El Dandachi on 1/14/19.
//  Copyright © 2019 Tareq El Dandachi. All rights reserved.
//

import UIKit
import SpriteKit

class LevelsController: UIViewController {

    @IBOutlet var sceneView: SKView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
            
        }
        
        sceneView.backgroundColor = UIColor.clear
        
        sceneView.allowsTransparency = true
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        guard
            let skView = self.view as? SKView,
            let canReceiveRotationEvents = skView.scene as? CanReceiveTransitionEvents else { return }
        
        canReceiveRotationEvents.viewWillTransition(to: size)
        
    }
    
}

protocol CanReceiveTransitionEvents {
    func viewWillTransition(to size: CGSize)
}
