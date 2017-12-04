//
//  PartyController.swift
//  Live Playlist
//
//  Created by Alejandro Cano on 11/28/17.
//  Copyright © 2017 Alejandro Cano. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PartyController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var hostPartyBttn: UIButton!
    //@IBOutlet weak var addSongBttn: UIButton!
    //@IBOutlet weak var joinPartyBttn: UIButton!
    @IBOutlet weak var partyName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var ref:FIRDatabaseReference?
    //var databaseHandle:FIRDatabaseHandle?
    var partyNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        //Set the Firebase reference
        ref = FIRDatabase.database().reference()
        
        //Retrieve the parties and listen for changes
        ref?.child("Parties").observe(.childAdded, with: { (snapshot) in
            //self.partyNames = [snapshot.value as! String]
            let parties = snapshot.value as? String
            if let actualParties = parties {
                self.partyNames.append(actualParties)
                self.tableView.reloadData()
            }
        })
        
        hostPartyBttn.layer.cornerRadius = 24.0
        //joinPartyBttn.layer.cornerRadius = 24.0
        //addSongBttn.layer.cornerRadius = 24.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hostPartyButton(_ sender: Any) {
        //hideButtons()
        if partyName.text != "" {
            ref?.child("Parties").childByAutoId().setValue(partyName.text)
            self.performSegue(withIdentifier: "partyPlaylistSegue", sender: self)
        }else {
            print("Name empty")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partyNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .detailButton
        cell.textLabel?.text = partyNames[indexPath.row]
        return cell
    }
    
    /*func hideButtons(){
        self.hostPartyBttn.isHidden = true
        self.joinPartyBttn.isHidden = true
        self.partyName.isHidden = true
        self.addSongBttn.isHidden = false
    }*/
    
}
