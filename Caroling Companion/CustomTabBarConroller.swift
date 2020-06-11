//
//  CustomTabBarConroller.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/19/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit

class CustomTabBarConroller: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBarItem.appearance().setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(red:0.72, green:0.31, blue:0.31, alpha:1.0)]), for: .selected)
        
         UITabBarItem.appearance().setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(red:0.72, green:0.31, blue:0.31, alpha:0.5)]), for: .normal)
        
        // The tabBar top border is done using the `shadowImage` and `backgroundImage` properties.
        // We need to override those properties to set the custom top border.
        // Setting the `backgroundImage` to an empty image to remove the default border.
        tabBar.backgroundImage = UIImage()
        // The `shadowImage` property is the one that we will use to set the custom top border.
        // We will create the `UIImage` of 1x5 points size filled with the red color and assign it to the `shadowImage` property.
        // This image then will get repeated and create the red top border of 5 points width.
        
        // A helper function that creates an image of the given size filled with the given color.
        // http://stackoverflow.com/a/39604716/1300959
        func getImageWithColor(color: UIColor, size: CGSize) -> UIImage
        {
            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: size.height))
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            color.setFill()
            UIRectFill(rect)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        }
        
        // Setting the `shadowImage` property to the `UIImage` 1x5 red.
        tabBar.shadowImage = getImageWithColor(color: UIColor(red:0.72, green:0.31, blue:0.31, alpha:1.0), size: CGSize(width: 1.0, height: 2.0))
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
