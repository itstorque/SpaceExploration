//
//  button.swift
//  space
//
//  Created by Tareq El Dandachi on 1/27/19.
//  Copyright © 2019 Tareq El Dandachi. All rights reserved.
//

import UIKit

class clickButton: UIButton {
    
    var colorIndex = 3
    
    let availableColors = [#colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1),#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1),#colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)]
    
    let availableShadowColors = [#colorLiteral(red: 0.4666666667, green: 0, blue: 0.05490196078, alpha: 1),#colorLiteral(red: 0, green: 0.2784313725, blue: 0.5843137255, alpha: 1),#colorLiteral(red: 0.5921568627, green: 0.3450980392, blue: 0, alpha: 1),#colorLiteral(red: 0.1568627451, green: 0.5176470588, blue: 0.2196078431, alpha: 1)]
    
    var color : UIColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
    
    var shadowColor : CGColor = #colorLiteral(red: 0.2823529412, green: 0.2823529412, blue: 0.2823529412, alpha: 1).cgColor
    
    let disabledColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
    let disabledShadowColor = #colorLiteral(red: 0.2823529412, green: 0.2823529412, blue: 0.2823529412, alpha: 1).cgColor
    
    var wasHighlighted = false
    
    var didCompleteAnimation = true
    
    //TRUE := 3; FALSE := 0; A,B,C,D := 0,1,2,3; SUBMIT := 3
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorIndex = self.tag
        
        color = availableColors[colorIndex]
        shadowColor = availableShadowColors[colorIndex].cgColor
        
        self.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .highlighted)
        self.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .focused)
        self.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .disabled)
        self.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .selected)
        
        self.showsTouchWhenHighlighted = false
        
        self.clipsToBounds = false
        
        self.layer.shadowColor = shadowColor
        
        self.layer.shadowRadius = 0
        
        self.layer.shadowOpacity = 1
        
        self.layer.shadowOffset = CGSize(width: 0, height: 7)
        
        self.transform = CGAffineTransform(translationX: 0, y: -7)
        
        self.backgroundColor = color
        
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.setTitle(self.titleLabel?.text?.capitalized, for: .normal)
        
        self.contentEdgeInsets.bottom = 4
        
        self.addTarget(self, action: #selector(onPress), for: .touchUpInside)
        
        if self.buttonType != .custom {
            
            self.setTitle("BROKEN BUTTON", for: .normal)
            
        }
        
    }
    
    override func layoutSubviews() {
        
        super .layoutSubviews()
        
        self.layer.cornerRadius = self.layer.bounds.height/11
        
        let fontSize = (self.frame.height)/2 - 10
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .heavy)
        
    }
    
    override open var isHighlighted: Bool {
        
        didSet {
            
            if !didCompleteAnimation {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    
                    self.pressButton(isHighlighted: self.isHighlighted)
                    
                }
                
            } else {
                
                pressButton(isHighlighted: isHighlighted)
            
            }
            
        }
    }
    
    func pressButton(isHighlighted: Bool) {
        
        if (isHighlighted != wasHighlighted) && self.isEnabled {
            
            self.titleLabel?.alpha = 1
            
            didCompleteAnimation = false
            
            let layerAnim = CABasicAnimation(keyPath: "shadowOffset")
            
            layerAnim.fromValue = self.isHighlighted ? CGSize(width: 0, height: 7) : CGSize(width: 0, height: 0)
            
            layerAnim.toValue = self.isHighlighted ? CGSize(width: 0, height: 0) : CGSize(width: 0, height: 7)
            
            layerAnim.fillMode = CAMediaTimingFillMode.both
            layerAnim.isRemovedOnCompletion = false
            
            layerAnim.duration = 0.1
            
            self.layer.add(layerAnim, forKey: "shadowOffset")
            
            self.layer.shadowOffset = self.isHighlighted ? CGSize(width: 0, height: 0) : CGSize(width: 0, height: 7)
            
            UIView.animate(withDuration: 0.1, animations: {
                
                self.transform = self.isHighlighted ? CGAffineTransform.identity : CGAffineTransform(translationX: 0, y: -7)
                
            }) { (Bool) in
                
                self.didCompleteAnimation = true
                
            }
            
            wasHighlighted = isHighlighted
            
        }
        
    }
    
    override open var isEnabled: Bool {
        didSet {
            
            backgroundColor = isHighlighted ? color : disabledColor
            
        }
    }
    
    @objc func onPress() {
        print("Pressed")
    }
}
