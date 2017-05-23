//
//  PlaylistVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/15/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase


class PlaylistVC: UITableViewController {

    var playlists = [Playlist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        DataService.ds.REF_PLAYLISTS.observe(.value, with: { (snapshot) in
            self.playlists = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let playlistDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let playlist = Playlist(playlistKey: key, playlistData: playlistDict)
                        self.playlists.insert(playlist, at: 0)
                    }
                }
            }
            self.tableView.reloadData()
            print(self.playlists.count)
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return playlists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playlist = playlists[indexPath.row]
        // Dequeue cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistNameCell", for: indexPath) as? PlaylistNameCell {
            cell.configureCell(playlist, indexPath: indexPath as NSIndexPath)
            return cell
        } else {
            print("error")
            return PlaylistSongCell()
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let playlist = playlists[indexPath.row]
        self.performSegue(withIdentifier: "showPlaylist", sender: nil
          //  playlist
        )
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "showPlaylist" {
//            let detailVC = segue.destination.contents as! CreatePlaylistVC
//            detailVC.playlistExists = true
//            detailVC.playlist = sender as? Playlist
//
//        } else if segue.identifier == "CreatePlaylist" {
//            let detailVC = segue.destination.contents as! CreatePlaylistVC
//            detailVC.playlistExists = false
//        }
//    }
    
    @IBAction func createPlaylist(_ sender: Any) {
        
        performSegue(withIdentifier: "CreatePlaylist", sender: nil)
    }

}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

