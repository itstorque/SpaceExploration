//
//  Scene.swift
//  space
//
//  Created by Tareq El Dandachi on 1/12/19.
//  Copyright © 2019 Tareq El Dandachi. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    
    var anchors: [ARAnchor] = []
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let sceneView = self.view as? ARSKView else {return}
        
        if let touchLocation = touches.first?.location(in: sceneView) {
            
            if let hit = sceneView.hitTest(touchLocation, types: .featurePoint).first {
                
                let position = hit.worldTransform
                
                let anchor = ARAnchor(transform: position)
                
                sceneView.session.add(anchor: anchor)
                
                anchors.append(anchor)
                
            }
            
        }
        
    }
    
}

class LevelsScene: SKScene, CanReceiveTransitionEvents {
    
    var firstLevel = SKSpriteNode()
    
    var levels : [SKSpriteNode] = []
    
    var prevLevels : [SKSpriteNode] = []
    
    let levelBoundCategory : UInt32 = 0x1 << 1
    
    var lvlBoxSize = CGSize(width: 85, height: 85)
    
    var spacing : CGFloat = 100
    
    var connectors : [SKShapeNode] = [SKShapeNode()]
    
    let worldNode = SKNode()
    
    var parentCount : [SKSpriteNode:Int] = [:]
    
    override func didMove(to view: SKView) {
        
        //view.showsPhysics = true
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            lvlBoxSize = CGSize(width: 125, height: 125)
            
            spacing = 170
            
        }
        
        firstLevel = SKSpriteNode(imageNamed: "levelBoundary")
        firstLevel.size = lvlBoxSize
        
        firstLevel.physicsBody = SKPhysicsBody(rectangleOf: lvlBoxSize)
        firstLevel.physicsBody?.isDynamic = false
        
        firstLevel.position = CGPoint(x: -view.frame.width/2, y: 0)
        firstLevel.physicsBody?.affectedByGravity = false
        
        firstLevel.physicsBody?.contactTestBitMask = levelBoundCategory
        firstLevel.physicsBody?.categoryBitMask = levelBoundCategory
        
        levels.append(firstLevel)
        
        parentCount[firstLevel] = 0
        
        prevLevels.append(SKSpriteNode())
        
        //worldNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
        
        worldNode.position = CGPoint(x: 0, y: 0)
        
        //worldNode.physicsBody?.mass = 0
        
        addChild(worldNode)
        
        //worldNode.physicsBody?.allowsRotation = false
        
        worldNode.constraints = [SKConstraint.zRotation(SKRange(lowerLimit: 0, upperLimit: 0))]
        
        worldNode.addChild(firstLevel)
        
        let firstLvlImage = SKSpriteNode(imageNamed: "Mars")
        
        //firstLvlImage.size = CGSize(width: 81, height: 50)
        
        firstLvlImage.aspectFitToSize(fitSize: CGSize(width: 81, height: 50))
        
        firstLvlImage.position = CGPoint(x: 0, y: 5)
        
        firstLvlImage.zPosition = 1
        
        firstLevel.addChild(firstLvlImage)
        
        let firstLvlLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        
        firstLvlLabel.text = "Hubble Telescope"//"Mars"
        
        firstLvlLabel.fontSize = 18
        
        firstLvlLabel.fontColor = UIColor.white
        
        firstLvlLabel.position = CGPoint(x: 2, y: -40)
        
        firstLvlLabel.horizontalAlignmentMode = .center
        
        firstLvlLabel.numberOfLines = 2
        
        firstLevel.addChild(firstLvlLabel)
        
        firstLvlLabel.adjustLabelFontSizeToFitRect(maxHeight: 30)
        
        createLevel(title: "Lvl 2", image: UIImage(named: "Mars")!, prevSibling: firstLevel)
        
        createLevel(title: "Lvl 3", image: UIImage(named: "Mars")!, prevSibling: levels[1])
        
        createLevel(title: "Lvl 4", image: UIImage(named: "Mars")!, prevSibling: levels[1])
        
        createLevel(title: "Lvl 5", image: UIImage(named: "Mars")!, prevSibling: levels[1])
        
        createLevel(title: "Lvl 6", image: UIImage(named: "Mars")!, prevSibling: levels[3])
        
        createLevel(title: "Lvl 6", image: UIImage(named: "Mars")!, prevSibling: levels[5])
        
        createLevel(title: "Lvl 6", image: UIImage(named: "Mars")!, prevSibling: levels[2])
        
        createLevel(title: "Lvl 6", image: UIImage(named: "Mars")!, prevSibling: levels[2])
        
        createLevel(title: "Lvl 6", image: UIImage(named: "Mars")!, prevSibling: levels[5])
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        self.backgroundColor = UIColor.clear
        
        //let move = SKAction.moveBy(x:0, y: 200, duration: 1)
        //firstLevel.run(move)
        
    }
    
    func viewWillTransition(to size: CGSize) {
        
        /*UIView.animate(withDuration: 1) {
            
            self.firstLevel.position = CGPoint(x: self.spacing-size.width/2, y: 0)
            
        }*/
        
        /*scene?.speed = 100
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            self.scene?.speed = 1
            
        }*/
        
        //ADD CONSTRAINTS FOR SCREEN BOUNDS AND UPDATE THEM
        
    }
    
    override func didSimulatePhysics() {
        
        for i in 0..<levels.count {
            
            let prevSibling = prevLevels[i]
            
            let siblingCount = prevLevels.prefix(i).filter{$0 == prevSibling}.count
            
            //Purpose of 20 is so that lines are drawn nicely fit into squares
            
            var pt = CGPoint(x: prevSibling.position.x + prevSibling.frame.width/2 - 20, y: prevSibling.position.y)
            
            if siblingCount == 1 {
                
                pt = CGPoint(x: prevSibling.position.x, y: prevSibling.position.y + prevSibling.frame.height/2 - 20)
                
            } else if siblingCount == 2 {
                
                pt = CGPoint(x: prevSibling.position.x, y: prevSibling.position.y - prevSibling.frame.height/2 + 20)
                
            }
            
            let pos = levels[i].position
            
            let line_path:CGMutablePath = CGMutablePath()
            line_path.move(to: pt)
            line_path.addLine(to: pos)
            
            connectors[i].path = line_path
            
        }
        
    }
    
    func createLevel(title: String, image: UIImage, prevSibling: SKSpriteNode) {
        
        let node = SKSpriteNode(imageNamed: "levelBoundary")
        
        node.size = lvlBoxSize
        
        node.physicsBody = SKPhysicsBody(rectangleOf: lvlBoxSize)
        
        node.physicsBody?.linearDamping = 1
        
        node.physicsBody?.contactTestBitMask = levelBoundCategory
        
        node.physicsBody?.categoryBitMask = levelBoundCategory
        
        parentCount[node] = parentCount[prevSibling]! + 1
        
        //node.physicsBody!.contactTestBitMask = node.physicsBody!.collisionBitMask
        
        //let range = SKRange(lowerLimit: prevSibling.position.x+50, upperLimit: prevSibling.position.x+250)
        
        //let lockToCenter = SKConstraint.positionX(SKRange.withNoLimits(), y: SKRange(lowerLimit: -view!.frame.height/2, upperLimit: view!.frame.height/2)) //WAS WORKING ON THIS
        
        let rotateLock = SKConstraint.zRotation(SKRange(lowerLimit: 0, upperLimit: 0))
        
        node.constraints = [ /*lockToCenter, */rotateLock ]
        
        worldNode.addChild(node)
        
        addLevelToList(node: node, prevSibling: prevSibling)
        
    }
    
    func addLevelToList(node:SKSpriteNode, prevSibling: SKSpriteNode) {
        
        let siblingCount = prevLevels.filter{$0 == prevSibling}.count
        
        let connectionNode = SKSpriteNode()
        
        let spacingScaled = /*(1/CGFloat(parentCount[node]!)) */ spacing
        
        connectionNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
        
        var pt = CGPoint(x: prevSibling.position.x + prevSibling.frame.width/2, y: prevSibling.position.y)
        
        var pos = CGPoint(x: prevSibling.position.x+spacingScaled, y: prevSibling.position.y)
        
        if siblingCount == 1 {
            
            pt = CGPoint(x: prevSibling.position.x, y: prevSibling.position.y + prevSibling.frame.height/2)
            
            pos = CGPoint(x: prevSibling.position.x, y: prevSibling.position.y+spacing)
            
            print("A")
            
        } else if siblingCount == 2 {
            
            pt = CGPoint(x: prevSibling.position.x, y: prevSibling.position.y - prevSibling.frame.height/2)
            
            pos = CGPoint(x: prevSibling.position.x, y: prevSibling.position.y-spacing)
            
            print("B")
            
        }
        
        let spring = SKPhysicsJointSpring.joint(withBodyA: prevSibling.physicsBody!,
                                                bodyB: connectionNode.physicsBody!,
                                                anchorA: pt,
                                                anchorB: node.position)
        
        let spring2 = SKPhysicsJointFixed.joint(withBodyA: connectionNode.physicsBody!, bodyB: node.physicsBody!, anchor: node.position)
        
        print(distanceBetween(pt, pos))
        
        //let maxJoint = SKPhysicsJointLimit.joint(withBodyA: prevSibling.physicsBody!, bodyB: node.physicsBody!, anchorA: pt, anchorB: node.position)
        
        //maxJoint.maxLength = 100
        
        spring.frequency = 10
        spring.damping = 10
        
        node.position = pos
        
        worldNode.addChild(connectionNode)
        
        physicsWorld.add(spring)
        
        physicsWorld.add(spring2)
        
        //physicsWorld.add(maxJoint)
        
        let line_path:CGMutablePath = CGMutablePath()
        line_path.move(to: pt)
        line_path.addLine(to: node.position)
        
        let connectorShape = SKShapeNode()
        
        connectorShape.path = line_path
        connectorShape.strokeColor = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)
        connectorShape.lineWidth = 5
        
        connectorShape.zPosition = -1
        
        worldNode.addChild(connectorShape)
        
        levels.append(node)
        
        prevLevels.append(prevSibling)
        
        connectors.append(connectorShape)
        
    }
    
    var touchedNodeHolder : SKNode?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            //guard touchedNodeHolder != nil else {return} //let's not allow other touches to interfere
            let pointOfTouch = touch.location(in: self)
            
            touchedNodeHolder = atPoint(pointOfTouch)
            
            if touchedNodeHolder == firstLevel {
                
                touchedNodeHolder = nil
                
                return
                
            }
            
        }
        
    }

    var worldAcc : CGFloat? = nil
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touchedNodeHolder == nil {
            
            for touch in touches {
                
                let pointOfTouch = touch.location(in: self)
                
                if worldAcc != nil {
                    
                    worldAcc = worldAcc! - pointOfTouch.x
                    
                    worldNode.position = CGPoint(x:worldNode.position.x - worldAcc!, y: 0)
                    
                    for i in worldNode.children {
                        
                        i.physicsBody?.isDynamic = false
                        
                    }
                    
                }
                
                worldAcc = pointOfTouch.x
                
            }
            
            
        } else {
            
            guard let node = touchedNodeHolder as? SKSpriteNode else {touchedNodeHolder = nil; return}
            
            //guard let prevIndex = levels.firstIndex(of: node) else {touchedNodeHolder = nil; return}
            
            guard let index = levels.firstIndex(of: node) else {touchedNodeHolder = nil; return}
            
            let prevLevel = prevLevels[index]//levels[levels.index(before: prevIndex)]
            
            for touch in touches {
                
                //let pointOfTouch = touch.location(in: self)
                
                let pointOfTouch = touch.location(in: worldNode)
                    
                //if (pointOfTouch.x > prevLevel.position.x + prevLevel.frame.width) && (pointOfTouch.x < prevLevel.position.x + prevLevel.frame.width*3) {
                    
                    touchedNodeHolder?.position = CGPoint(x: pointOfTouch.x, y: pointOfTouch.y)
                    
                //}
                
            }
            
        }
        
    }
    
    func distanceBetween(_ pt1: CGPoint, _ pt2: CGPoint) -> CGFloat {
        
        let x = pt1.x - pt2.x
        
        let y = pt1.y - pt2.y
        
        return pow((pow(x, 2) + pow(y, 2)), 0.5)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touchedNodeHolder == nil {
        
            for i in worldNode.children {
                
                i.physicsBody?.isDynamic = true
                
                firstLevel.physicsBody?.isDynamic = false
                
            }
            
        } else {
            
            let initVelocity = touchedNodeHolder?.physicsBody?.velocity
            
            touchedNodeHolder?.physicsBody?.velocity = CGVector(dx: (initVelocity?.dx)!/10, dy: (initVelocity?.dy)!/10)
            
            touchedNodeHolder = nil
            
        }
        
        worldAcc = nil
        
    }
    
}

extension SKSpriteNode {
    
    func aspectFitToSize(fitSize: CGSize) {
        
        if texture != nil {
            
            self.size = texture!.size()
            
            let verticalRatio = fitSize.height / self.texture!.size().height
            let horizontalRatio = fitSize.width /  self.texture!.size().width
            
            let scaleRatio = horizontalRatio < verticalRatio ? horizontalRatio : verticalRatio
            
            self.setScale(scaleRatio)
            
        }
        
    }
    
}

extension SKLabelNode {
    
    func adjustLabelFontSizeToFitRect(maxHeight: CGFloat = 0) {
        
        //RUN THIS AFTER ADDING LABEL INTO NODE SINCE *PARENT* REQUIRED!
        
        guard var rect = self.parent?.frame.size else {return}
        
        if maxHeight != 0 {
            
            rect = CGSize(width: rect.width, height: maxHeight)
            
        }
        
        let scalingFactor = min(rect.width / self.frame.width, rect.height / self.frame.height)
        
        self.fontSize *= scalingFactor
        
        if self.fontSize < 14 {
            
            self.text = self.text?.replacingOccurrences(of: " ", with: "\n")
            
            let scalingFactor = min(rect.width / self.frame.width, rect.height / self.frame.height)
            
            self.fontSize *= scalingFactor
            
        }
        
        //self.position = CGPoint(x: rect.midX, y: rect.midY - self.frame.height / 2.0)
        
    }
    
}
