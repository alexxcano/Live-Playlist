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
    var player = SPTAudioStreamingController.sharedInstance()
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
          
           
                
            /*self.player?.playSpotifyURI(self.songsArr[0], startingWith: 0, startingWithPosition: 0, callback: {(error) in
                if error == nil
                {
                    print("playing")
                }
            })*/

                //self.audioStreaming(self.player, didStartPlayingTrack: self.songsArr[0])
            //self.audioStreaming(self.player, didStopPlayingTrack: self.songsArr[0])
            //print(self.player?.metadata.nextTrack?.playbackSourceUri)
                //self.audioStreaming(self.player, didStopPlayingTrack: self.songsArr[0])

        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    
           /*if self.player != nil
           {
        
            let trackName = self.player?.metadata.currentTrack?.name
            let albName = self.player?.metadata.currentTrack?.albumName
            let artiName = self.player?.metadata.currentTrack?.artistName
            let albumart = self.player?.metadata.currentTrack?.albumCoverArtURL
            self.songName.text = trackName!
            self.albumName.text = albName!
            self.artistName.text = artiName!
            let  albumarturl = URL(string: albumart!)
            let data = try? Data(contentsOf: albumarturl!)
            let image = UIImage(data: data!)
            self.albumArtwork.image = image
      
        }*/
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
    
     func loadsong()
    {
        self.audioStreamingDidBecomeActivePlaybackDevice(self.player)
        
        
      
    }
   
    
    @objc func newsong()
    {
        self.songUri.removeFirst()
        
    }
    
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
       audioStreaming.skipNext({(error) in
        if error == nil
        {
            print("skipped")
        }
       })
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
 
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String)
    {
        
      
        
        audioStreaming.queueSpotifyURI("spotify:track:7inXu0Eaeg02VsM8kHNvzM", callback: {(error) in
            if error == nil
            {
                print("queueing song")
            
            }
        })
        
    }
        
        
   
        
       
        
    
    
    func audioStreamingDidBecomeActivePlaybackDevice(_ audioStreaming: SPTAudioStreamingController!)
    {
        
        audioStreaming.playSpotifyURI(self.songsArr[0], startingWith: 0, startingWithPosition: 0, callback: {(error) in
            if error == nil
            {
                print("playing")
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
