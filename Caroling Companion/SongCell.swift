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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func colorForIndex(count: Int, index: Int) -> UIColor {
        let itemCount = count - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        
        return UIColor(red: 0.10, green: color, blue: 1.0, alpha: 0.3)
    }
    
    func configureCell(_ title: String, indexPath: NSIndexPath, count: Int) {
     songNameLabel.text = title
        
        if (indexPath.row % 2 == 0)
        {
            self.backgroundColor = colorForIndex(count: count, index: indexPath.row)
        } else {
            self.backgroundColor = UIColor.clear
        }
        
    }
    

}
