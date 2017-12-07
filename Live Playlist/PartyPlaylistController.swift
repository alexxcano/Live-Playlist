//
//  PartyPlaylistController.swift
//  Live Playlist
//
//  Created by Alejandro Cano on 12/2/17.
//  Copyright © 2017 Alejandro Cano. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PartyPlaylistController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = songNames[indexPath.row]
        return cell
    }

    @IBOutlet weak var tableView: UITableView!
    var ref:FIRDatabaseReference?


    //var currentParty = UserDefaults.standard.value(forKey: "currentParty")
    var songNames = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        /*UserDefaults.standard.synchronize()
        var currentParty = UserDefaults.standard.value(forKey: "JoinedParty")

        print("yo what up")
        print(currentParty)
        ref = FIRDatabase.database().reference()
        //print(currentParty)
        //print("yo")
        //Retrieve the parties and listen for changes
        ref?.child("Parties").child(currentParty as! String).child("Songs").observe(.childAdded, with: { (snapshot) in
            //self.partyNames = [snapshot.value as! String]
            let parties = snapshot.key
            print(parties)
            //let tmp = parties!["party"] as? String
            //print(parties)
            self.songNames.append(parties)
            //self.tableView.reloadData()
            
        })*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var currentParty = UserDefaults.standard.value(forKey: "currentParty")
        
        ref = FIRDatabase.database().reference()
       
        //Retrieve the parties and listen for changes
        ref?.child("Parties").child(currentParty as! String).child("Songs").observe(.childAdded, with: { (snapshot) in
            //self.partyNames = [snapshot.value as! String]
            let parties = snapshot.key
           
            self.songNames.append(parties)
            self.tableView.reloadData()
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
