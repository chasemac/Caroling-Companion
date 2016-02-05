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
        AwayInAManger.lyrics = awayInAManger
        self.songs.append(AwayInAManger)
        
        let DoYouHearWhatIHear = Song()
        DoYouHearWhatIHear.name = "Do You Hear What I Hear"
        DoYouHearWhatIHear.lyrics = doYouHearWhatIHear
        self.songs.append(DoYouHearWhatIHear)
        
        let FrostyTheSnowman = Song()
        FrostyTheSnowman.name = "Frosty The Snowman"
        FrostyTheSnowman.lyrics = frostyTheSnowman
        self.songs.append(FrostyTheSnowman)
        
        let HarkTheHarald = Song()
        HarkTheHarald.name = "Hark The Harald"
        HarkTheHarald.lyrics = harkTheHarold
        self.songs.append(HarkTheHarald)
        
        let HaveYourselfAMerryLittleChristmas = Song()
        HaveYourselfAMerryLittleChristmas.name = "Have Yourself A Merry Little Christmas"
        HaveYourselfAMerryLittleChristmas.lyrics = haveYourselfAMerryLittleChristmas
        self.songs.append(HaveYourselfAMerryLittleChristmas)
        
        let HereComesSantaClaus = Song()
        HereComesSantaClaus.name = "Here Comes Santa Claus"
        HereComesSantaClaus.lyrics = hereComesSantaClause
        self.songs.append(HereComesSantaClaus)
        
        let ItCameUponAMidnightClear = Song()
        ItCameUponAMidnightClear.name = "It Came Upon A Midnight Clear"
        ItCameUponAMidnightClear.lyrics = itCameUponAMidnightClear
        self.songs.append(ItCameUponAMidnightClear)
        
        let JingleBells = Song()
        JingleBells.name = "Jingle Bells"
        JingleBells.lyrics = jingleBells
        self.songs.append(JingleBells)
        
        let JoyToTheWorld = Song()
        JoyToTheWorld.name = "Joy To The World"
        JoyToTheWorld.lyrics = joyToTheWorld
        self.songs.append(JoyToTheWorld)
        
        let LetItSnow = Song()
        LetItSnow.name = "Let It Snow"
        LetItSnow.lyrics = letItSnow
        self.songs.append(LetItSnow)
        
        let LittleDrummer = Song()
        LittleDrummer.name = "Little Drummer"
        LittleDrummer.lyrics = littleDrummerBoy
        self.songs.append(LittleDrummer)
        
        let OChristmasTree = Song()
        OChristmasTree.name = "O Christmas Tree"
        OChristmasTree.lyrics = oCrhsistmasTree
        self.songs.append(OChristmasTree)
        
        let OComeAllYeFaithful = Song()
        OComeAllYeFaithful.name = "O Come All Ye Faithful"
        OComeAllYeFaithful.lyrics = oComeAllYeFaithful
        self.songs.append(OComeAllYeFaithful)
        
        let RudolphTheRedNoseReindeer = Song()
        RudolphTheRedNoseReindeer.name = "Rudolph The Red Nose Reindeer"
        RudolphTheRedNoseReindeer.lyrics = rudolphTheRedNoseReindeer
        self.songs.append(RudolphTheRedNoseReindeer)
        
        let SilentNight = Song()
        SilentNight.name = "Silent Night"
        SilentNight.lyrics = silentNight
        self.songs.append(SilentNight)
        
        let SilverBells = Song()
        SilverBells.name = "Silver Bells"
        SilverBells.lyrics = silverBells
        self.songs.append(SilverBells)
        
        let TheFirstNoel = Song()
        TheFirstNoel.name = "The First Noel"
        TheFirstNoel.lyrics = theFirstNoel
        self.songs.append(TheFirstNoel)
        
        let WinterWonderland = Song()
        WinterWonderland.name = "Winter Wonder land"
        WinterWonderland.lyrics = winterWonderland
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

