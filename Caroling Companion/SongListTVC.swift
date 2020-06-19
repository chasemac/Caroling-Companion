//
//  SongListTVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/22/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase

class SongListTVC: UITableViewController {
    
    // MARK: FIREBASE STUFF
    private var ref: DatabaseReference!
    private var query: DatabaseQuery?
    
    private var songsArray: [Song] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.query?.removeAllObservers()
        self.ref.removeAllObservers()
    }
    
    func configureDatabase() {
        self.ref = DataService.ds.REF_SONGS
        self.query = ref.queryOrdered(byChild: DBSongString.title)
        self.query?.observe(.value, with: { (snapshot) in
            self.songsArray = []
            for snap in snapshot.children {
                let songSnap = snap as! DataSnapshot
                let song = Song(data: songSnap)
                self.songsArray.append(song)
            }
            self.tableView.reloadData()
        })
    }
    
    // MARK: TableViewMethods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCellF
        let backgroundView = UIView()
        backgroundView.backgroundColor = softGreen
        cell.selectedBackgroundView = backgroundView
        
        let song = songsArray[indexPath.row]
        cell.configureSongNameCell(song: song)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songsArray[indexPath.row]
        performSegue(withIdentifier: "detailSegue", sender: song)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let detailVC = segue.destination as! SongLyricsVC
            detailVC.song = sender as? Song
        }
    }
    
}


