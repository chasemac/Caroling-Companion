//
//  SongLyricsVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 12/20/15.
//  Copyright © 2015 Chase McElroy. All rights reserved.

import UIKit
import Firebase

class SongLyricsVC: SwipeRightToDismissVC {
    
    var songF : DataSnapshot!
    

    @IBOutlet weak var txtView: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser?.uid != nil {
            print("Logged in user UID ------> \(Auth.auth().currentUser!.uid as Any)")
        } else {
            print("no current user")
        }
        initText()
        print("the almost there one!! ----->>>> \(String(describing: self.songF))")
        loadSongs(song: self.songF)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadSongs(song: DataSnapshot) {
        if let songDict = song.value as? [String : AnyObject] {
            let title = songDict[DBSongString.title] as? String ?? "Title Unavailable"
            navigationItem.title = title.uppercased()
            let lyrics = songDict[DBSongString.lyrics] as? String ?? "Lyrics Unavailable"
            let lyricsSwift = lyrics.replacingOccurrences(of: "<br>", with: "\n")
            txtView.text = lyricsSwift

        } else {
            txtView.text = "Unable To Load Song"
        }
    }
    
    func initText() {
        txtView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        txtView.textColor = .darkGray
        NotificationCenter.default.addObserver(self, selector: #selector(self.preferredContentSizeChanged(_:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    @objc func preferredContentSizeChanged(_ notification: Notification) {
        txtView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        txtView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
