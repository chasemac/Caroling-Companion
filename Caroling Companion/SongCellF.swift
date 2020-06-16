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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureSongNameCell(song: Song) {

        songNameLabel.text = song.title
        songNameLabel.textColor = .darkGray
        
        self.backgroundColor = christmasWhite
    }
  
    
}

