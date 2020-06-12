//
//  ShowPlaylistVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/22/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase

class ShowPlaylistVC: SongListTVC {
    
    fileprivate var query: DatabaseQuery?
    fileprivate var ref: DatabaseReference!
    var playlistF : DataSnapshot!
    
    var playListSongKeys: [String] = []
    
    override func viewDidLoad() {
        
        print("the first one!! ----->>>> \(playlistF)")
        super.viewDidLoad()
        let playlist = playlistF.value as! [String:Any]
        let navTitle =  playlist[DBPlaylistString.title] as? String ?? "No Title"
        navigationItem.title = navTitle.uppercased()
    }

    override func configureDatabase() {
        let playlistDict = playlistF.value as! NSDictionary
        if playlistDict[DBPlaylistString.songs] != nil {
            let songKeyDict = playlistDict[DBPlaylistString.songs] as! [String:Any]
            for (key, _) in songKeyDict {
                self.playListSongKeys.append(key)
                
            }
            for key in playListSongKeys {
                self.loadSongs(key: key)
            }
        }

    }
    
    func loadSongs(key: String) {
        songsF = []
        let songRef = DataService.ds.REF_SONGS
        
        songRef.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                self.songsF.append(snapshot)
            print("the snap building one!! ----->>>> \(snapshot)")
                self.tableView.insertRows(at: [IndexPath(row: self.songsF.count-1, section: 0)], with: .automatic)
        })
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("the second one!! ----->>>> \(playlistF)")
        if segue.identifier == "EditPlaylist" {
            let detailVC = segue.destination.contents as! CreatePlaylistVCF
            detailVC.playlistF = sender as? DataSnapshot
        }
        super.prepare(for: segue, sender: sender)
    }
    
    @IBAction func editBtnTapped(_ sender: Any) {
        print("the third one!! ----->>>> \(playlistF)")
        performSegue(withIdentifier: "EditPlaylist", sender: playlistF)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // TODO: Clicking Edit Button While Searching Crashes
//    override func editingChange(_ sender: Any) {
//        // Fix this
//    }
}
