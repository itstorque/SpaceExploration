//
//  levelDetailViewController.swift
//  space
//
//  Created by Tareq El Dandachi on 1/18/19.
//  Copyright © 2019 Tareq El Dandachi. All rights reserved.
//

import UIKit
import SceneKit

class levelDetailViewController: UIViewController {

    @IBOutlet weak var scenePreview: SCNView!
    
    var scene = SCNScene()
    
    let object = SCNNode()
    
    let material = SCNMaterial()
    
    let container = SCNNode()
    
    let sphericalShape = SCNSphere(radius: 0.1)
    
    var origPivot : SCNMatrix4 = SCNMatrix4Identity
    
    @IBOutlet weak var distanceFromSun: UILabel!
    
    @IBOutlet weak var planetDiameter: UILabel!
    
    @IBOutlet weak var planetMass: UILabel!
    
    let numberFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scenePreview.scene = scene
        
        scenePreview.backgroundColor = UIColor.clear
        
        sphericalShape.segmentCount = 100
        
        object.geometry = sphericalShape
        
        material.diffuse.contents = UIImage(named: "art.scnassets/marsTexture.jpg")
        
        //material.emission.contents = UIImage(named: "art.scnassets/earthTextureNight.jpg")
        
        //material.emission.intensity = 1
        
        object.geometry?.firstMaterial = material
        
        addRotation(node: object, period: 4)
        
        scene.rootNode.addChildNode(container)
        
        container.addChildNode(object)
        
        origPivot = container.pivot
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(levelDetailViewController.panGesture))
        
        scenePreview.addGestureRecognizer(panRecognizer)
        
        let dblTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(levelDetailViewController.resetRotation))
        
        dblTapRecognizer.numberOfTapsRequired = 2
        
        scenePreview.addGestureRecognizer(dblTapRecognizer)
        
        guard let valueDistanceFromSun = data.planetDistances["Mars"] else { return }
        
        guard let valuePlanetDiameter = data.planetDiameters["Mars"] else { return }
        
        guard let valuePlanetMass = data.planetMass["Mars"] else { return }
        
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        distanceFromSun.text = String(valueDistanceFromSun) + " AU"
        
        planetMass.text = String(round(valuePlanetMass * data.earthMass * 1000)/1000) + " M⊕"
        
        guard let formattedPlanetDiameter = numberFormatter.string(from: NSNumber(value:valuePlanetDiameter)) else {planetDiameter.text = String(valuePlanetDiameter) + " km"; return}
        
        planetDiameter.text = formattedPlanetDiameter + " km"
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func addRotation(node: SCNNode, period: Double) {
        
        let duration = period*5.0
        
        //let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: duration)
        
        let rotate = SCNAction.rotate(by: CGFloat(Float.pi), around: node.convertVector(SCNVector3(0, 1, 0), to: node.parent), duration: duration)
        
        let repeatForever = SCNAction.repeatForever(rotate)
        
        node.runAction(repeatForever)
        
    }
    
    @objc func resetRotation() {
        
        print("@@@")
        
        var rotationVector = SCNVector4()
        rotationVector.x = 0
        rotationVector.y = 0
        rotationVector.z = 0
        rotationVector.w = 0
        
        container.rotation = rotationVector
        
        let changePivot = SCNMatrix4Invert(container.transform)
        
        container.pivot = SCNMatrix4Mult(changePivot, origPivot)
        
        container.transform = SCNMatrix4Identity
        
    }
    
    @objc func panGesture(gestureRecognize: UIPanGestureRecognizer) {
        
        let translation = gestureRecognize.translation(in: gestureRecognize.view!)
        
        let x = Float(translation.x)
        let y = Float(-translation.y)
        
        let anglePan = sqrt(pow(x,2)+pow(y,2))*(Float)(Double.pi)/180.0
        
        var rotationVector = SCNVector4()
        rotationVector.x = -y
        rotationVector.y = x
        rotationVector.z = 0
        rotationVector.w = anglePan
        
        container.rotation = rotationVector
        
        if(gestureRecognize.state == UIGestureRecognizer.State.ended) {
            
            let currentPivot = container.pivot
            let changePivot = SCNMatrix4Invert( container.transform)
            
            container.pivot = SCNMatrix4Mult(changePivot, currentPivot)
            
            container.transform = SCNMatrix4Identity
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
