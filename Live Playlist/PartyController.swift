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
    @IBOutlet weak var partyName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var ref:FIRDatabaseReference?
    var databaseHandle:FIRDatabaseHandle?
    var partyNames = [String]()
    let user = FIRAuth.auth()?.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        //Set the Firebase reference
        ref = FIRDatabase.database().reference()
        
        //Retrieve the parties and listen for changes
        ref?.child("Parties").observe(.childAdded, with: { (snapshot) in
            let parties = snapshot.value as? [String: Any]
            let tmp = parties!["party"] as? String
            
            self.partyNames.append(tmp!)
            self.tableView.reloadData()
            
        })
        
        
        hostPartyBttn.layer.cornerRadius = 24.0
        //joinPartyBttn.layer.cornerRadius = 24.0
        //addSongBttn.layer.cornerRadius = 24.0
        
    }
    
 
    

    
    @IBAction func hostPartyButton(_ sender: Any) {
        //hideButtons()
        //party = (ref?.child("Parties").childByAutoId().setValue(partyName.text) as? String)!
        if self.partyName.text != ""
        {
            let partiesReference = ref?.child("Parties").childByAutoId()
            let values = ["party": self.partyName.text]
            var partyStr = partiesReference?.key
            UserDefaults.standard.setValue(partyStr, forKey: "currentParty")
            // print(user?.email)
       
            partiesReference?.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                else
                {
                    print("Saved user successfully")
                }
            })
            self.performSegue(withIdentifier: "partyPlaylistSegue", sender: self)
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
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        print(partyNames[indexPath.row])
        ref?.child("Parties").observe(.childAdded, with: {(snapshot) in
            let userDict = snapshot.value as! [String:Any]
            var found = userDict["party"]
            if found as! String == self.partyNames[indexPath.row]
            {
                    found = snapshot.key
                
                    UserDefaults.standard.setValue(found, forKey: "currentParty")

                
               
            }
       })
        
        self.performSegue(withIdentifier: "partyPlaylistSegue", sender: self)
        
    }
    
    var tmpmusicLibrary = [Library]()

    func getlibrary() {
        if let data = UserDefaults.standard.value(forKey:"MusicLibrary") as? Data {
            let songs2 = try? PropertyListDecoder().decode(Array<Library>.self, from: data)
            tmpmusicLibrary = songs2!
        }
    }
    /*func hideButtons(){
        self.hostPartyBttn.isHidden = true
        self.joinPartyBttn.isHidden = true
        self.partyName.isHidden = true
        self.addSongBttn.isHidden = false
    }*/
    
}
