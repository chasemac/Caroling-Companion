//
//  SongCell.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 4/28/16.
//  Copyright © 2016 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase

class SongCell: UITableViewCell {
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    
    var song: Song!
    var favoriteRef: FIRDatabaseReference!
    
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

    
    func configureCell(_ song: Song, indexPath: NSIndexPath) {
        self.song = song
        
        favoriteRef = DataService.ds.REF_USER_CURRENT.child(DBSongString.favorites).child(song.songKey)
        songNameLabel.text = song.title
        
        if indexPath.row % 3 == 0 {
            self.backgroundColor = softGreen
        } else if
            indexPath.row % 2 == 0 {
            self.backgroundColor = darkRed
        }
        else {
            self.backgroundColor = softRed
        }
        

        favoriteRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.starImage.image = UIImage(named: "star-empty")
            } else {
                self.starImage.image = UIImage(named: "star-filled")
            }
        })
    }
}

