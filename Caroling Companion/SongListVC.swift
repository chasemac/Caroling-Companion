//
//  ViewController.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 12/20/15.
//  Copyright © 2015 Chase McElroy. All rights reserved.
//

import UIKit

class SongListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSongs()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func createSongs() {
        
        let AwayInAManger = Song()
        AwayInAManger.name = "Away In A Manger"
        AwayInAManger.file = "AwayInAManger"
        self.songs.append(AwayInAManger)
        
        let DoYouHearWhatIHear = Song()
        DoYouHearWhatIHear.name = "Do You Hear What I Hear"
        DoYouHearWhatIHear.file = "DoYouHearWhatIHear"
        self.songs.append(DoYouHearWhatIHear)
        
        let FrostyTheSnowman = Song()
        FrostyTheSnowman.name = "Frosty The Snowman"
        FrostyTheSnowman.file = "FrostyTheSnowman"
        self.songs.append(FrostyTheSnowman)
        
        let HarkTheHarald = Song()
        HarkTheHarald.name = "Hark The Harald"
        HarkTheHarald.file = "HarkTheHarald"
        self.songs.append(HarkTheHarald)
        
        let HaveYourselfAMerryLittleChristmas = Song()
        HaveYourselfAMerryLittleChristmas.name = "Have Yourself A Merry Little Christmas"
        HaveYourselfAMerryLittleChristmas.file = "HaveYourselfAMerryLittleChristmas"
        self.songs.append(HaveYourselfAMerryLittleChristmas)
        
        let HereComesSantaClaus = Song()
        HereComesSantaClaus.name = "Here Comes Santa Claus"
        HereComesSantaClaus.file = "HereComesSantaClaus"
        self.songs.append(HereComesSantaClaus)
        
        let ItCameUponAMidnightClear = Song()
        ItCameUponAMidnightClear.name = "It Came Upon A Midnight Clear"
        ItCameUponAMidnightClear.file = "ItCameUponAMidnightClear"
        self.songs.append(ItCameUponAMidnightClear)
        
        let JingleBells = Song()
        JingleBells.name = "Jingle Bells"
        JingleBells.file = "JingleBells"
        self.songs.append(JingleBells)
        
        let JoyToTheWorld = Song()
        JoyToTheWorld.name = "Joy To The World"
        JoyToTheWorld.file = "JoyToTheWorld"
        self.songs.append(JoyToTheWorld)
        
        let LetItSnow = Song()
        LetItSnow.name = "Let It Snow"
        LetItSnow.file = "LetItSnow"
        self.songs.append(LetItSnow)
        
        let LittleDrummer = Song()
        LittleDrummer.name = "Little Drummer"
        LittleDrummer.file = "LittleDrummer"
        self.songs.append(LittleDrummer)
        
        let OChristmasTree = Song()
        OChristmasTree.name = "O Christmas Tree"
        OChristmasTree.file = "OChristmasTree"
        self.songs.append(OChristmasTree)
        
        let OComeAllYeFaithful = Song()
        OComeAllYeFaithful.name = "O Come All Ye Faithful"
        OComeAllYeFaithful.file = "OComeAllYeFaithful"
        self.songs.append(OComeAllYeFaithful)
        
        let RudolphTheRedNoseReindeer = Song()
        RudolphTheRedNoseReindeer.name = "Rudolph The Red Nose Reindeer"
        RudolphTheRedNoseReindeer.file = "RudolphTheRedNoseReindeer"
        self.songs.append(RudolphTheRedNoseReindeer)
        
        let SilentNight = Song()
        SilentNight.name = "Silent Night"
        SilentNight.file = "SilentNight"
        self.songs.append(SilentNight)
        
        let SilverBells = Song()
        SilverBells.name = "Silver Bells"
        SilverBells.file = "SilverBells"
        self.songs.append(SilverBells)
        
        let TheFirstNoel = Song()
        TheFirstNoel.name = "The First Noel"
        TheFirstNoel.file = "TheFirstNoel"
        self.songs.append(TheFirstNoel)
        
        let WinterWonderland = Song()
        WinterWonderland.name = "Winter Wonder land"
        WinterWonderland.file = "WinterWonderland"
        self.songs.append(WinterWonderland)

    }


    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let song = self.songs[indexPath.row]
        cell.textLabel!.text = song.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let song = self.songs[indexPath.row]
        self.performSegueWithIdentifier("detailSegue", sender: song)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailVC = segue.destinationViewController as! SongLyricsVC
        detailVC.song = sender as! Song
        
    }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
}

