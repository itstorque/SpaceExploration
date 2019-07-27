//
//  questionViewController.swift
//  space
//
//  Created by Tareq El Dandachi on 1/27/19.
//  Copyright © 2019 Tareq El Dandachi. All rights reserved.
//

import UIKit

class questionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0.003921568627, blue: 0.1254901961, alpha: 1)
        
        var count = 30
        
        var positions : [(CGFloat, CGFloat)] = []
        
        while count > 0 {
            
            let x = CGFloat.random(in: 0...view.frame.width),  y = CGFloat.random(in: 1...view.frame.height)
            
            var positionIsOkay = true
            
            for i in positions {
                
                if calcDist(point1: (x,y), point2: i) < 140 {
                    
                    positionIsOkay = false
                    
                }
                
            }
            
            if positionIsOkay {
                
                positions.append((x,y))
                
                let star = UILabel(frame: CGRect(x: x, y: y, width: 4, height: 4))
                
                star.layer.cornerRadius = 2
                
                star.backgroundColor = UIColor.white
                
                view.addSubview(star)
                
                view.sendSubviewToBack(star)
                
                count -= 1
                
            }
            
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func calcDist(point1: (CGFloat, CGFloat), point2: (CGFloat, CGFloat)) -> CGFloat {
        
        let x1 = point1.0, x2 = point2.0, y1 = point1.1, y2 = point2.1
        
        let powX = pow(x2-x1,2), powY = pow(y2-y1,2)
        
        return pow((powX+powY),0.5)
        
    }
    
}
