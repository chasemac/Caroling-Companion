//
//  SongLyricsVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 12/20/15.
//  Copyright © 2015 Chase McElroy. All rights reserved.

import UIKit
import Firebase

class SongLyricsVC: SwipeRightToDismissVC {
    
    var song: Song!

    @IBOutlet weak var txtView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initText()
        loadSongs(song: song)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadSongs(song: Song) {
        let title = song.title ?? "Title Unavailable"
        navigationItem.title = title.uppercased()
        let lyrics = song.lyrics ?? "Lyrics Unavailable"
        let lyricsSwift = lyrics.replacingOccurrences(of: "<br>", with: "\n")
        txtView.text = lyricsSwift
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
