//
//  CircleView.swift
//  SocialApp
//
//  Created by Chase McElroy on 3/23/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
