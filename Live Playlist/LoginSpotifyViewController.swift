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
    
    var musicLibraryC = [Library]()
    
    var libarr = [String]()
    var libarry = [String]()
    
    var libraryCount = 0
    
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
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            self.session = firstTimeSession
            initializePlayer(authSession: session)
        }
        else
        {
            print("error")
        }
        

        // Do any additional setup after loading the view.
    }
    
    //function to initialize player
    func initializePlayer(authSession:SPTSession){
        
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    //after it logins prepare player
    @objc func updateAfterFirstLogin () {
        
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            self.session = firstTimeSession
            initializePlayer(authSession: session)
            
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
        
        if musicLibraryC.isEmpty{
            print("library is empty")
        }
        else
        {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(musicLibraryC),forKey:"MusicLibrary")
            
            
        }
        
        
        self.performSegue(withIdentifier: "loggedInSpotifySegue", sender: nil)
    }
    
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        //self.player?.playSpotifyURI("spotify:track:0oPdaY4dXtc3ZsaG17V972", startingWith: 0, startingWithPosition: 0, callback: { (error) in
           // if (error != nil) {
               // print("playing!")
            //}
            
            
        
        
        createLibrary()
        
    }
    
    
    func audioStreamingDidBecomeActivePlaybackDevice(_ audioStreaming: SPTAudioStreamingController!)
    {
        
        audioStreaming.playSpotifyURI("spotify:track:6uWp8yAt8dN5ZaT7REJ6RV", startingWith: 0, startingWithPosition: 0, callback: {(error) in
            if error == nil
            {
                print("playing")
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createLibrary(){
        let accessToken = session.accessToken
        let request: URLRequest = try! SPTYourMusic.createRequestForCurrentUsersSavedTracks(withAccessToken: accessToken)
        SPTRequest.sharedHandler().perform(request) { (error, response, data) in
            if error != nil {
                print(error)
                
            }
            let listPage = try! SPTListPage(from: data, with: response, expectingPartialChildren: false, rootObjectKey: nil)
            self.libraryCount = listPage.items.count
            var count = listPage.items.count
            
            for i in 0 ..< count{
                var track:SPTPartialTrack = listPage.items[i] as! SPTPartialTrack
                var artist:SPTPartialArtist = ((track.artists as! NSArray).object(at: 0) as? SPTPartialArtist)!
                
                self.musicLibraryC.append(Library(songName: track.name, songArtist: artist.name, songUri: track.playableUri.absoluteString))
                
                
            }
            
            //print(self.musicLibraryC[0].songName)
            
            
            
        }
        //print(self.musicLibraryC[0].songName)

        
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
