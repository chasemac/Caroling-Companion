//
//  SongLyricsVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 12/20/15.
//  Copyright © 2015 Chase McElroy. All rights reserved.
//

import UIKit

class SongLyricsVC: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var song = Song()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localPath = NSBundle.mainBundle().URLForResource("\(song.file)", withExtension: "html")
        let localRequest = NSURLRequest(URL: localPath!)
        webView.loadRequest(localRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
