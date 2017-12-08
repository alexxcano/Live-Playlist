//
//  NowPlayingViewController.swift
//  Live Playlist
//
//  Created by Edwin Gomez on 11/1/17.
//  Copyright © 2017 Alejandro Cano. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Foundation


class NowPlayingViewController: UIViewController, SPTAudioStreamingPlaybackDelegate,SPTAudioStreamingDelegate {
    @IBOutlet weak var albumArtwork: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumeControl: UISlider!
    var ref:FIRDatabaseReference?

    @IBOutlet weak var artistName: UILabel!
    
    var musicLibraryC = [Library]()
    
    var libarr = [String]()
    var libarry = [String]()
    
    var libraryCount = 0
    var player: SPTAudioStreamingController!
    var session:SPTSession!
    var auth = SPTAuth.defaultInstance()!
    var userDefaults = UserDefaults.standard
    var user:SPTUser!
    var songsArr = [String]()
    var status = false
    var isplaying = true

    var songUri = [String]()
    
    func setup() {
    
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthUserLibraryModifyScope,SPTAuthUserLibraryReadScope]
        SPTAuth.defaultInstance().clientID = "8e6b4eaca65d4eb4afdd42f6c683cdc8"
        SPTAuth.defaultInstance().redirectURL = URL(string:"Live-Playlist://returnAfterLogin")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            self.session = firstTimeSession
           
            initializePlayer(authSession: session)
            
        }

        //getsongs()
        let group = DispatchGroup()
        getsongsarr(){ songUri in
            //print(songUri.count)
            group.enter()
            var count = songUri.count
            self.songsArr.append("")

            for i in 0 ..< count
            {
                self.songsArr[i] = songUri[i]
            
            }
            
            group.leave()
            
        }
        
        group.notify(queue: .main)
        {
          
           
       

        }
    }
        
        func initializePlayer(authSession:SPTSession){
            
            if self.player == nil {
                self.player = SPTAudioStreamingController.sharedInstance()
                self.player!.playbackDelegate = self
                self.player!.delegate = self
                
               
                try! player!.start(withClientId: auth.clientID)
                self.player!.login(withAccessToken: authSession.accessToken)
            
            }
        }
    
    
    
   
    
 
    
    func getsongsarr(completion: @escaping ([String]) -> ())
    {
        var songs = [String]()
        var currentParty = userDefaults.value(forKey: "currentParty")
        ref = FIRDatabase.database().reference()
        ref?.child("Parties").child(currentParty as! String).child("Songs").observe(.childAdded, with: { (snapshot) in
            
                //songs.removeAll()
                let song = snapshot.value as! String
                print(song)
                songs.append(song)
                completion(songs)
            
            
        })
    }
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
 
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String)
    {
        
        var count = self.songsArr.count
        if count != 1
        {
            self.songsArr.removeFirst()
        
            audioStreaming.queueSpotifyURI(self.songsArr[0], callback: {(error) in
                if error == nil
                {
                    print("queueing song")
            
                }
            })
            
            let trackName = audioStreaming.metadata.currentTrack?.name
            let albName = audioStreaming.metadata.currentTrack?.albumName
            let artiName = audioStreaming.metadata.currentTrack?.artistName
            let albumart = audioStreaming.metadata.currentTrack?.albumCoverArtURL
            self.songName.text = trackName!
            self.albumName.text = albName!
            self.artistName.text = artiName!
            let  albumarturl = URL(string: albumart!)
            let data = try? Data(contentsOf: albumarturl!)
            let image = UIImage(data: data!)
            self.albumArtwork.image = image
            
        }
        else
        {
            audioStreaming.queueSpotifyURI(self.songsArr[0], callback: {(error) in
                if error == nil
                {
                    print("queueing song")
                    
                }
            })
            
            let trackName = audioStreaming.metadata.currentTrack?.name
            let albName = audioStreaming.metadata.currentTrack?.albumName
            let artiName = audioStreaming.metadata.currentTrack?.artistName
            let albumart = audioStreaming.metadata.currentTrack?.albumCoverArtURL
            self.songName.text = trackName!
            self.albumName.text = albName!
            self.artistName.text = artiName!
            let  albumarturl = URL(string: albumart!)
            let data = try? Data(contentsOf: albumarturl!)
            let image = UIImage(data: data!)
            self.albumArtwork.image = image
        }
    }
        
        
   
        
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.playSpotifyURI(self.songsArr[0], startingWith: 0, startingWithPosition: 0, callback: { (error) in
        if (error == nil) {
         print("playing!")
        }
        
        
        
        
        })
        
    }
        
    
    

    
    
   
    
    @IBAction func playButtonAct(_ sender: Any) {
        
        
       if isplaying
       {
            self.player?.setIsPlaying(false, callback: nil)
            isplaying = false
            self.playButton.setTitle("Play", for: UIControlState.normal)
        }
        else
       {
            self.player?.setIsPlaying(true, callback: nil)
            isplaying = true
            self.playButton.setTitle("Pause", for: UIControlState.normal)

        }
       
        
    }
    
    @IBAction func volumeSlide(_ sender: Any) {
        
        let volumee = Double(volumeControl.value)
        
        self.player?.setVolume(volumee, callback: { (error) in
            if (error != nil) {
                print(error)
            }
            
            
            
        })
        
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "passingStructsSegue"{
            
        
            let vc: MymusicViewController = segue.destination as! MymusicViewController
            vc.tmpmusicLibrary = musicLibraryC
        }
        
    }*/
 

}
