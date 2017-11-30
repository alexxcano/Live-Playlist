//
//  LoginSpotifyViewController.swift
//  Live Playlist
//
//  Created by Edwin Gomez on 10/26/17.
//  Copyright © 2017 Alejandro Cano. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation


class LoginSpotifyViewController: UIViewController, SPTAudioStreamingPlaybackDelegate,SPTAudioStreamingDelegate {
    @IBOutlet weak var logInSpotify: UIButton!
    @IBOutlet weak var logInAppleMusic: UIButton!
    
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
   
    
    var userDefaults = UserDefaults.standard
    
    func setup() {
        SPTAuth.defaultInstance().clientID = "8e6b4eaca65d4eb4afdd42f6c683cdc8"
        SPTAuth.defaultInstance().redirectURL = URL(string:"Live-Playlist://returnAfterLogin")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope,SPTAuthUserLibraryModifyScope,SPTAuthUserLibraryReadScope,SPTAuthUserReadPrivateScope]
        //app opens
        //loginUrl = SPTAuth.defaultInstance().spotifyAppAuthenticationURL()
        loginUrl = auth.spotifyWebAuthenticationURL() //ebsite opens
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        logInSpotify.layer.cornerRadius = 24.0
        logInAppleMusic.layer.cornerRadius = 24.0
        
        setup()
       
        //will call updateafterlogin and call otherfunctions to login to spotify
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginSpotifyViewController.perforSegue), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
        

        // Do any additional setup after loading the view.
    }
    
    //function to initialize player
    /*unc initializePlayer(authSession:SPTSession){
        
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }*/
    
    //after it logins prepare player
    @objc func updateAfterFirstLogin () {
        
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            self.session = firstTimeSession
            //initializePlayer(authSession: session)
            
        }
    }
    
    @IBAction func loginbuttonnPressed(_ sender: Any) {
        
        if UIApplication.shared.openURL(loginUrl!)
        {
            if auth.canHandle(auth.redirectURL)
            {
                
               // self.performSegue(withIdentifier: "loggedInSpotifySegue", sender: nil)
            }
        }
    }
    
    @objc func perforSegue()
    {
        self.performSegue(withIdentifier: "loggedInSpotifySegue", sender: nil)
    }
    
    
    /*func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.playSpotifyURI("spotify:track:0Y2i84QWPFiFHQfEQDgHya", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
            
            
        })
    }*/
    
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
