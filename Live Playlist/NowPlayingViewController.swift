//
//  NowPlayingViewController.swift
//  Live Playlist
//
//  Created by Edwin Gomez on 11/1/17.
//  Copyright © 2017 Alejandro Cano. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController, SPTAudioStreamingPlaybackDelegate,SPTAudioStreamingDelegate {
    @IBOutlet weak var albumArtwork: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumeControl: UISlider!
    
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
    
    var isplaying = true

    
    func setup() {
    
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthUserLibraryModifyScope,SPTAuthUserLibraryReadScope]
        SPTAuth.defaultInstance().clientID = "8e6b4eaca65d4eb4afdd42f6c683cdc8"
        SPTAuth.defaultInstance().redirectURL = URL(string:"Live-Playlist://returnAfterLogin")
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
  
  
   
        
        
   
    
 
    
  
    
    
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didStartPlayingTrack trackUri: String){
        
        
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
        
        
        if musicLibraryC.isEmpty{
            print("library is empty")
        }
        else
        {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(musicLibraryC),forKey:"MusicLibrary")

            
        }
        
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
            
            //
            
            
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
