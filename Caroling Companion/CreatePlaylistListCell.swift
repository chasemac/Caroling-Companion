//
//  CreatePlaylistListCell.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/16/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit

class CreatePlaylistListCell: SongCell {


    @IBOutlet weak var playlistSongNameLabel: UILabel!
    @IBOutlet weak var playlistStarImage: UIImageView!
    @IBOutlet weak var playlistCheckBox: UIButton!
    
    @IBAction func playlistCheckboxTapped(_ sender: Any) {
        if playlistCheckBox.imageView?.image == UIImage(named: "checkbox-empty") {
            playlistCheckBox.imageView?.image = UIImage(named: "checkbox-filled")
        } else {
            playlistCheckBox.imageView?.image = UIImage(named: "checkbox-empty")
        }
    }
    
    
    override func configureCell(_ song: Song, indexPath: NSIndexPath) {
        super.configureCell(song, indexPath: indexPath)
        
        playlistCheckBox.imageView?.image = UIImage(named: "checkbox-empty")
    }
    
    override func localSongLable() -> UILabel {
        return playlistSongNameLabel!
    }
    
    override func localStarImage() -> UIImageView {
        return playlistStarImage!
    }
    
    

}
