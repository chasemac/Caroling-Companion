//
//  PlaylistSongCellF.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/1/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase

class PlaylistSongCellF: SongCellF {
    
    @IBOutlet weak var playlistCheckBox: UIImageView!
    
    func configureCreatePlaylistSongNameCell(song: Song) {
        songNameLabel.text = song.title
        songNameLabel.textColor = .darkGray
        
        self.backgroundColor = christmasWhite
        self.playlistCheckBox.image = UIImage(named: song.inPlaylist ? "deleteCellBtn" : "addPlusBtn")
        
    }
}
