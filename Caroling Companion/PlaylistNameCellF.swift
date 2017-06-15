//
//  PlaylistNameCell.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/17/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import Foundation
import Firebase

class PlaylistNameCellF: UITableViewCell {
    
    @IBOutlet weak var playlistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func configureCell(_ playlistName: AnyObject, indexPath: NSIndexPath) {
    
        playlistNameLabel.text = playlistName as? String
        
        self.backgroundColor = christmasWhite
    }
    
}

