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

class PartyController: UIViewController, SPTAudioStreamingPlaybackDelegate,SPTAudioStreamingDelegate {

    @IBOutlet weak var hostPartyBttn: UIButton!
    @IBOutlet weak var addSongBttn: UIButton!
    @IBOutlet weak var joinPartyBttn: UIButton!
    @IBOutlet weak var partyName: UITextField!
    
    var ref:FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ref = FIRDatabase.database().reference()
        
        hostPartyBttn.layer.cornerRadius = 24.0
        joinPartyBttn.layer.cornerRadius = 24.0
        addSongBttn.layer.cornerRadius = 24.0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        NowPlayingViewController().player?.playSpotifyURI("spotify:track:0zRtBDhwtIFTfoK2HuURbM", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print(error)
            }
            
        })
        
        MymusicViewController().self.createLibrary(session: NowPlayingViewController().session)
     
    }*/
    
    @IBAction func hostPartyButton(_ sender: Any) {
        hideButtons()
        ref?.child("Parties").childByAutoId().setValue(partyName.text)
    }
    
    func hideButtons(){
        self.hostPartyBttn.isHidden = true
        self.joinPartyBttn.isHidden = true
        self.partyName.isHidden = true
        self.addSongBttn.isHidden = false
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
