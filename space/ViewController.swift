//
//  ViewController.swift
//  space
//
//  Created by Tareq El Dandachi on 1/12/19.
//  Copyright © 2019 Tareq El Dandachi. All rights reserved.
//

/*import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSKView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController : ARSKViewDelegate {
    
    /*func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        <#code#>
    }*/
    
    func view(_ view: ARSKView, didAdd node: SKNode, for anchor: ARAnchor) {
        
        let planetNode = SKSpriteNode(imageNamed: "Mars")
        
        planetNode.xScale = 0.25
        planetNode.yScale = 0.25
        
        node.addChild(planetNode)
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}


*/

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var node = SCNNode()
    
    let planetPeriods : [String:Double] = data.planetPeriods//["Mercury":58.65,"Venus":116.75,"Earth":1,"Mars":1.025,"Jupiter":0.414,"Saturn":0.4458,"Uranus":0.718,"Neptune":0.671,"Pluto":6.4, "Moon Orbit":27.3, "Moon": 27]
    
    let planetDiameter : [String:Int] = data.planetDiameters//["Mercury":4879,"Venus":12104,"Earth":12742,"Mars":6779,"Jupiter":139822,"Saturn":116464,"Uranus":50724,"Neptune":49244,"Pluto":2377, "Moon Orbit":385000, "Moon": 3474]
    
    //var objShow : [String:Bool] = ["Mercury":true,"Venus":true,"Earth":true,"Mars":true,"Jupiter":false,"Saturn":false,"Uranus":false,"Neptune":false,"Pluto":false, "Moon": true, "Moon Orbit":true, "Sun": false]
    
    var objShow : [String:Bool] = ["Mercury":true,"Venus":true,"Earth":true,"Mars":true,"Jupiter":false,"Saturn":false,"Uranus":false,"Neptune":false,"Pluto":true, "Moon": true, "Moon Orbit":true, "Sun": true]
    
    var extraShow : [String:Bool] = ["axisOfRotation":false,"orbitPath":false,"names":false,"evenlyLit":true,"scaleSize":true,"scaleDistance":false]
    
    let planetsOrder : [String:Double] = data.planetsOrder//["Mercury":1, "Venus":2, "Earth":3, "Mars":4, "Jupiter":5, "Saturn":6, "Uranus":7, "Neptune":8, "Pluto":9]
    
    let planetTilt : [String:Double] = data.planetTilts//["Mercury":0.03, "Venus":177.4, "Earth":23.44, "Mars":25.19, "Jupiter":3.13, "Saturn":26.73, "Uranus":82.23, "Neptune":28.32, "Pluto":57.47, "Moon":6.68, "Ceres":4]
    
    var spacing = 0.15
    
    var detailView = UIView()
    
    var bgView = UIView()
    
    var pictureTease = UIImageView()
    
    var teaseTitle = UILabel()
    
    var teaseDetails = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/Scene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        for n in scene.rootNode.childNodes {
            
            guard let name = n.name else {return}
            
            var period = 0.0
            
            if let periodTemp = planetPeriods[name] {
                
                period = periodTemp
                
            }
            
            print(period)
            
            if name == "Moon Orbit" {
                
                print("YAY")
                
                addRotation(node: n.childNodes[0], period: planetPeriods["Moon"]!)
                
            }
            
            if period != 0 {
                
                addRotation(node: n, period: period)
                
            }
            
        }
        
        node = scene.rootNode.childNodes[0]
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func updateLightNodesLightEstimation() {
        
        print("SPAMBOI")
        DispatchQueue.main.async {
            guard let lightEstimate = self.sceneView.session.currentFrame?.lightEstimate else { return }
            
            let ambientIntensity = lightEstimate.ambientIntensity
            //let ambientColorTemperature = lightEstimate.ambientColorTemperature
            
            print(ambientIntensity)
            
            let earth = self.sceneView.scene.rootNode.childNode(withName: "Earth", recursively: false)
            
            let material = earth?.geometry?.material(named: "EarthDay")
            
            if ambientIntensity < 500 {
                
                material?.diffuse.contents = UIImage(named: "art.scnassets/earthTextureNight.jpg")
                
                material?.emission.contents = UIImage(named: "art.scnassets/earthTextureNight.jpg")
                
                material?.emission.intensity = 1
                
            } else {
                
                material?.diffuse.contents = UIImage(named: "art.scnassets/earthTexture.jpg")
                
                material?.emission.contents = UIColor.black
                
            }
            
        }
    }
    
    func checkFocus() {
        
        let pos = sceneView.center
        
        let hitTest = sceneView.hitTest(pos, options: nil)
        
        if let focusNode = hitTest.first?.node {
            
            guard var name = focusNode.name else {return}
            
            //if name == "Saturn Ring" { name = "Saturn" }
            
            guard let diameter = planetDiameter[name] else {return}
            
            guard let rotation = planetPeriods[name] else {return}
            
            guard let tilt = planetTilt[name] else {return}
            
            var details = "Period of Rotation: " + String(describing: rotation)
                
            details = details + " Earth Day\nAxial Tilt: " + String(describing: tilt)
            
            let ratio = Double(diameter)/Double(planetDiameter["Earth"]!)
            
            let ratioRounded = Double(round(1000*ratio)/1000)
            
            details = details + " degrees\nRadius: " + String(ratioRounded) + "x Earth Radius"
            
            guard let image = UIImage(named: name+"Small") else {return}
            
            showDetail(name: name, detail: details, image: image)
            
        } else {
            
            hideDetail()
            
        }
        
    }
    
    func showDetail(name: String, detail: String, image: UIImage) {
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
            
            self.bgView.frame.origin = CGPoint(x: 15, y: self.view.frame.height - 115)
            
            self.detailView.frame.origin = CGPoint(x: 15, y: self.view.frame.height - 115)
            
        }) { (Bool) in
            
        }
        
        teaseTitle.text = name
        
        teaseDetails.text = detail
        
        pictureTease.image = image
        
    }
    
    func hideDetail() {
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
            
            self.bgView.frame.origin = CGPoint(x: 15, y: self.view.frame.height)
            
            self.detailView.frame.origin = CGPoint(x: 15, y: self.view.frame.height)
            
        }) { (Bool) in
            
        }
        
    }
    
    @objc func didTapScreen(recognizer: UITapGestureRecognizer) {
        
        //updateLightNodesLightEstimation()
        
        return
        
        let pos = recognizer.location(in: self.sceneView)
        
        let hitTest = sceneView.hitTest(pos, types: .estimatedHorizontalPlane).first
        
        print("ACTIVE")
        
        guard let worldTransform = hitTest?.worldTransform else {return}
        
        let newPosition = SCNVector3(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)
        
        print(newPosition)
        
        node.simdPosition = float3(newPosition.x, newPosition.y, newPosition.z)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //1. Get The Current Touch Point
        guard let currentTouchPoint = touches.first?.location(in: self.sceneView),
            //2. Get The Next Feature Point Etc
            let hitTest = sceneView.hitTest(currentTouchPoint, types: .existingPlane).first else { return }
        
        //3. Convert To World Coordinates
        let worldTransform = hitTest.worldTransform
        
        //4. Set The New Position
        let newPosition = SCNVector3(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)
        
        //5. Apply To The Node
        node.simdPosition = float3(newPosition.x, newPosition.y, newPosition.z)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        setupWorld()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTapScreen))
        
        self.view.addGestureRecognizer(tapRecognizer)
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(repeatedFunctions), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func repeatedFunctions() {
    
        if extraShow["evenlyLit"]! {
    
            updateLightNodesLightEstimation()
    
        }
        
        checkFocus()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //playBackgroundMusic()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func setupWorld() {
        
        //If user wants evenly lit, then sun light is hidden
        sceneView.scene.rootNode.childNode(withName: "Sun Light", recursively: false)?.isHidden = extraShow["evenlyLit"]!
        
        let distance : Float = 0.5
        
        var prevNodeOffest : Float = -2.0
        
        for node in sceneView.scene.rootNode.childNodes {
            
            if objShow[(node.name) ?? ""] ?? false == false {
                
                print("hide")
                
                node.isHidden = true
                
            } else {
                
                //prevNodeOffest = prevNodeOffest + distance + node.scale.x/2
                
                //node.position = SCNVector3(prevNodeOffest,0,0)
                
                prevNodeOffest += distance + node.scale.z
                
                node.position = SCNVector3(0, 0, prevNodeOffest)
            
                if extraShow["scaleSize"]! {
                    
                    //FIX LATER
                    //node.scale = SCNVector3(0.1, 0.1, 0.1)
                    
                } else {
                    
                    node.scale = SCNVector3(0.1, 0.1, 0.1)
                    
                }
                
                /*if extraShow["scaleDistance"]! {
                    
                    //FIX LATER
                    
                } else {
                    
                    if let order = planetsOrder[(node.name) ?? ""] {
                        
                        node.worldPosition = SCNVector3(0, 0, spacing + prevNodeOffest)
                        
                    }
                    
                }
                
                if node.name == "Moon Orbit" {
                    
                    node.worldPosition = SCNVector3(0.3, 0.3, prevNodeOffest+0.3)
                    
                }
                
                if let diameter = planetDiameter[(node.name) ?? ""] {
                    
                    if !(node.name == "Moon" || node.name == "Moon Orbit") {
                        
                        prevNodeOffest = Double(node.worldPosition.z) + Double(node.scale.z)
                        
                    }
                    
                }*/
                
            }
            
        }
        
        /* Detail View */
        
        bgView = UIView(frame: CGRect(x: 15, y: view.frame.height - 115, width: view.frame.width - 30, height: 100))
        
        bgView.layer.cornerRadius = 10
        
        bgView.clipsToBounds = true
        
        detailView = UIView(frame: CGRect(x: 15, y: view.frame.height - 115, width: view.frame.width - 30, height: 100))
        
        detailView.layer.cornerRadius = 10
        
        pictureTease = UIImageView(frame: CGRect(x: 15, y: 15, width: 70, height: 70))
        
        teaseTitle = UILabel(frame: CGRect(x: 100, y: 10, width: view.frame.width - 130, height: 24))
        
        teaseTitle.font = UIFont.boldSystemFont(ofSize: 20)
        
        teaseTitle.textColor = UIColor.white
        
        teaseDetails = UILabel(frame: CGRect(x: 100, y: 35, width: view.frame.width - 140, height: 50))
        
        teaseDetails.font = UIFont.boldSystemFont(ofSize: 13)
        
        teaseDetails.textColor = UIColor.white
        
        teaseTitle.text = "Mars"
        
        teaseDetails.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        
        teaseDetails.numberOfLines = 3
        
        pictureTease.image = UIImage(named: "Mars")
        
        detailView.addSubview(pictureTease)
        
        detailView.addSubview(teaseTitle)
        
        detailView.addSubview(teaseDetails)
        
        detailView.backgroundColor = UIColor.clear
        
        pictureTease.contentMode = .scaleAspectFit
        
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibility.isReduceTransparencyEnabled {
            bgView.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = bgView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            blurEffectView.layer.cornerRadius = 10
            
            bgView.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            bgView.backgroundColor = .black
        }
        
        sceneView.addSubview(bgView)
        
        sceneView.addSubview(detailView)
        
        hideDetail()
        
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("GUACA")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    func addRotation(node: SCNNode, period: Double) {
        
        let duration = period*5.0
        
        let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: duration)
        
        let rotateTwo = SCNAction.rotate(by: CGFloat(Float.pi), around: node.convertVector(SCNVector3(0, 1, 0), to: node.parent), duration: duration)
        
        let repeatForever = SCNAction.repeatForever(rotateTwo)
        
        node.runAction(repeatForever)
        
    }
    
    /* Audio - Music and Effects */
    
    func playBackgroundMusic() {
        
        let audioNode = SCNNode()
        
        let audioSource = SCNAudioSource(fileNamed: "art.scnassets/KeplerSounds.caf")!
        
        audioSource.loops = true
        
        audioSource.volume = 0.2
        
        let audioPlayer = SCNAudioPlayer(source: audioSource)
        
        audioNode.addAudioPlayer(audioPlayer)
        
        let play = SCNAction.playAudio(audioSource, waitForCompletion: true)
        
        audioNode.runAction(play)
        
        sceneView.scene.rootNode.addChildNode(audioNode)
        
    }
    
}
