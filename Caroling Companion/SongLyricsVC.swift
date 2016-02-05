//
//  SongLyricsVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 12/20/15.
//  Copyright © 2015 Chase McElroy. All rights reserved.
//

import UIKit



class SongLyricsVC: UIViewController {
    
    var song = Song()
    
    @IBOutlet weak var txtView: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
       initText()
        
       txtView.text = song.lyrics

    }
    
    func initText() {
        txtView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredContentSizeChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        // this bug still exists in iOS 9
        txtView.scrollEnabled = false
        txtView.scrollEnabled = true
        txtView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
    }
    
    func preferredContentSizeChanged(notification: NSNotification) {
        txtView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
    }


    
    
    
}
