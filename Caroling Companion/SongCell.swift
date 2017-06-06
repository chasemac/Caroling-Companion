////
////  SongCell.swift
////  Caroling Companion
////
////  Created by Chase McElroy on 4/28/16.
////  Copyright © 2016 Chase McElroy. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class SongCell: UITableViewCell {
//    
//    @IBOutlet weak var songNameLabel: UILabel!
//    @IBOutlet weak var starImage: UIImageView!
//    
//    var song: Song!
//    var favoriteRef: FIRDatabaseReference!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        // Configure the view for the selected state
//    }
//    
//    
//    func configureCell(_ song: Song, indexPath: NSIndexPath) {
//        self.song = song
//        
//        songNameLabel.text = song.title
//        
//        if indexPath.row % 3 == 0 {
//            self.backgroundColor = softGreen
//        } else if
//            indexPath.row % 2 == 0 {
//            self.backgroundColor = darkRed
//        }
//        else {
//            self.backgroundColor = softRed
//        }
//        setFavorite()
//    }
//    
//    func setFavorite() {
//        favoriteRef = DataService.ds.REF_USER_CURRENT.child(DBSongString.favorites).child(song.songKey)
//        favoriteRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let _ = snapshot.value as? NSNull {
//                self.starImage.image = UIImage(named: "star-empty")
//            } else {
//                self.starImage.image = UIImage(named: "star-filled")
//            }
//        })
//    }
//    
//}
//
