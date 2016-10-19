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
    
    let blue = UIColor(red: 0.043, green: 0.863, blue: 0.973, alpha: 1.00)
    let red = UIColor(red: 0.988, green: 0.227, blue: 0.369, alpha: 1.00)
    let green = UIColor(red: 0.612, green: 0.976, blue: 0.596, alpha: 1.00)
    let purple = UIColor(red: 0.773, green: 0.278, blue: 0.980, alpha: 1.00)
    
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
        
        let colorPallet = [self.blue, self.red, self.green, self.purple]
        
        while colorCount < count {
            
            for i in colorPallet {
                specific = i

                colorCount += 1
                
            }
            print("color \(colorCount) i = \(specific) index = \(index)")
        }
        
        return specific
    }
    
    func configureCell(_ title: String, indexPath: NSIndexPath, count: Int) {
     songNameLabel.text = title
        
            self.backgroundColor = colorForIndex(count: count, index: indexPath.row)
        
        
    }
}
