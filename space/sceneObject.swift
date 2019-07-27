//
//  sceneObject.swift
//  space
//
//  Created by Tareq El Dandachi on 1/13/19.
//  Copyright © 2019 Tareq El Dandachi. All rights reserved.
//

import SceneKit
    
class SceneObject: SCNNode {

    init(from file: String) {
        super.init()
        
        let nodesInFile = SCNNode.allNodes(from: file)
        nodesInFile.forEach { (node) in
            self.addChildNode(node)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class Sphere: SceneObject {
    
    var animating: Bool = false
    let patrolDistance: Float = 4.85
    
    init() {
        super.init(from: "Scene.scn")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        
        if animating { return }
        animating = true
        
        let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat(Float.random(min: -Float.pi, max: Float.pi)), z: 0, duration: 5.0)
        
        let backwards = rotateOne.reversed()
        let rotateSequence = SCNAction.sequence([rotateOne, backwards])
        let repeatForever = SCNAction.repeatForever(rotateSequence)
        
        runAction(repeatForever)
    }
    
    func patrol(targetPos: SCNVector3) {
        let distanceToTarget = targetPos.distance(receiver: self.position)
        
        if distanceToTarget < patrolDistance {
            removeAllActions()
            animating = false
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.20
            look(at: targetPos)
            SCNTransaction.commit()
        } else {
            if !animating {
                animate()
            }
        }
    }
}

extension SCNNode {
    
    public class func allNodes(from file: String) -> [SCNNode] {
        var nodesInFile = [SCNNode]()
        
        do {
            guard let sceneURL = Bundle.main.url(forResource: file, withExtension: nil) else {
                print("Could not find scene file \(file)")
                return nodesInFile
            }
            
            let objScene = try SCNScene(url: sceneURL as URL, options: [SCNSceneSource.LoadingOption.animationImportPolicy:SCNSceneSource.AnimationImportPolicy.doNotPlay])
            
            for childNode in objScene.rootNode.childNodes {
                nodesInFile.append(childNode)
            }
        } catch {
            
        }
        
        return nodesInFile
    }
    
    func topmost(parent: SCNNode? = nil, until: SCNNode) -> SCNNode {
        if let pNode = self.parent {
            return pNode == until ? self : pNode.topmost(parent: pNode, until: until)
        } else {
            return self
        }
        
    }
}

extension SCNVector3 {
    public func distance(receiver:SCNVector3) -> Float {
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        
        if (distance < 0){
            return (distance * -1)
        } else {
            return (distance)
        }
    }
}

public extension Float {
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    static var random: Float {
        get {
            return Float(arc4random()) / 0xFFFFFFFF
        }
    }
    /**
     Create a random num Float
     
     - parameter min: Float
     - parameter max: Float
     
     - returns: Float
     */
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}
