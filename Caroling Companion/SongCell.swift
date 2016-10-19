//
//  SongCell.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 4/28/16.
//  Copyright © 2016 Chase McElroy. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    let softGreen = UIColor(red: 0.467, green: 0.600, blue: 0.424, alpha: 1.00)
    let darkRed = UIColor(red: 0.718, green: 0.310, blue: 0.310, alpha: 1.00)
    let softRed = UIColor(red: 0.882, green: 0.471, blue: 0.471, alpha: 1.00)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func colorForIndex(count: Int, index: Int) -> UIColor {
        
        var specific = UIColor()
        var colorCount = Int()
        
        let colorPalette = [self.softGreen, self.darkRed, self.softRed]
        
        while colorCount < count {
            
            for i in colorPalette {
                specific = i
                
                colorCount += 1
                
            }
            print("color \(colorCount) i = \(specific) index = \(index)")
        }
        
        return specific
    }
    
    func configureCell(_ title: String, indexPath: NSIndexPath, count: Int) {
        songNameLabel.text = title
        
        if indexPath.row % 3 == 0 {
            self.backgroundColor = softGreen
        } else if
            indexPath.row % 2 == 0 {
            self.backgroundColor = darkRed
        }
        else {
            self.backgroundColor = softRed
        }
    }
    
}

