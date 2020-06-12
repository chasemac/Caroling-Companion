//
//  OutlineBtn.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/7/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
@IBDesignable
class OutlineBtn: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    @IBInspectable var borderWidth: CGFloat = 2 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black
    

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = 2
    }
 

}
