//
//  SongCell.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 4/28/16.
//  Copyright © 2016 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase

class SongCellF: UITableViewCell {
    
    @IBOutlet weak var songNameLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configureCell(_ snapshot: DataSnapshot, indexPath: NSIndexPath, playlistKey: String?) {
        
        let song = snapshot.value as! NSDictionary
        let name = song[DBSongString.title] ?? "No Title" as AnyObject
        
        songNameLabel.text = name as? String
        songNameLabel.textColor = .darkGray
        
        self.backgroundColor = christmasWhite
    }
  
    
}

