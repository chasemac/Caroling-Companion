////
////  SongListTVC.swift
////  Caroling Companion
////
////  Created by Chase McElroy on 5/22/17.
////  Copyright © 2017 Chase McElroy. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class SongListTVCF_TEST_SEARCH: UITableViewController {
//    
//    @IBOutlet weak var textField: UITextField!
//    
//    fileprivate var _favorites: Int!
//    
//    // MARK: NEW FIREBASE STUFF
//    var ref: FIRDatabaseReference!
//    var songsF: [FIRDataSnapshot]! = []
//    fileprivate var songF : FIRDataSnapshot!
//    fileprivate var _refHandle: FIRDatabaseHandle!
//    fileprivate var query: FIRDatabaseQuery?
//    
//    var text = ""
// //   var favorites: [String] = []
//    
//    var songsLoaded: Bool = false
//    
//    override func viewDidLoad() {
//        configureDatabase()
//
//        super.viewDidLoad()
//    }
//    
//    func configureDatabase() {
//        text = textField.text!
//        
//        songsF = []
//        // not lowercasing
//        let lowercaseText = text
//        self.ref = DataService.ds.REF_SONGS
//        if text != "" {
//            self.query = ref.queryOrdered(byChild: DBSongString.title).queryStarting(atValue: lowercaseText).queryEnding(atValue: lowercaseText+"\u{f8ff}")
//        } else {
//            self.query = ref.queryOrdered(byChild: DBSongString.title)
//        }
//
//        self.query?.observe(.value, with: { (snapshot) in
//            
//            for snap in snapshot.children {
//                let song = snap as! FIRDataSnapshot
//                self.songsF.append(song)
//                self.tableView.insertRows(at: [IndexPath(row: self.songsF.count-1, section: 0)], with: .automatic)
//            }
//            
//        })
//        tableView.reloadData()
//    }
//    @IBAction func editingChanged(_ sender: Any) {
//        text = textField.text!
//        print(text)
//        configureDatabase()
//    }
//
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Dequeue cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCellF
//        
//        let snapshot = songsF[indexPath.row]
//        cell.configureCell(snapshot, indexPath: indexPath as NSIndexPath)
//        return cell
//        
//    }
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.songsF.count
//    }
//    
//}
