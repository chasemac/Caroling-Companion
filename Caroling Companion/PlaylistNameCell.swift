//
//  PlaylistNameCell.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/17/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import Foundation
import Firebase

class PlaylistNameCell: UITableViewCell {
    
    @IBOutlet weak var playlistNameLabel: UILabel!

    var playlist: Playlist!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func configureCell(_ playlist: Playlist, indexPath: NSIndexPath) {
        self.playlist = playlist
        
        if playlist.title != nil {
            playlistNameLabel.text = playlist.title
        } else {
            playlistNameLabel.text = "No Title"
        }
        
        
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

