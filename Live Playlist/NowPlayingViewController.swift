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
    var player: SPTAudioStreamingController?
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
        
        
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            self.session = firstTimeSession
            initializePlayer(authSession: session)
           
           
            
            

        // Do any additional setup after loading the view.
    }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func initializePlayer(authSession:SPTSession){
        
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
            print("player is initialized")
        }
        
  
    }
    
  
   
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
     // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.playSpotifyURI("spotify:track:6tN6rdEfm6ZtuKsqpoh3on", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print(error)
            }
     
        })
        
        createLibrary()
        var tmpc = musicLibraryC.count
        if self.libraryCount == tmpc{
            print("finished creating library")
        }
     

        
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
                self.libarr.append(String(describing: listPage.items[i]))
                self.libarry.append(String(self.libarr[i].reversed()))
                
                
                self.libarry[i].removeFirst()
                if let range = self.libarry[i].range(of: "(")
                {
                    self.libarry[i] = String(self.libarry[i][self.libarry[i].startIndex..<range.lowerBound])
                }
                self.libarry[i] = String(self.libarry[i].reversed())
            }
            
            print(self.libarry[0])
            self.fixuriarray()
            
            
            
        }
    }
    
    func fixuriarray(){
        
        
        var market = NSLocale.current.regionCode as? String
        
        
        var count = self.libarry.count
        for i in 0 ..< count{
            
            let request: URLRequest? = try? SPTTrack.createRequest(forTrack: URL(string: self.libarry[i] ), withAccessToken: session.accessToken, market: market! )
            SPTRequest.sharedHandler().perform(request) { (error, response, data) in
                if error != nil {
                    print(error)
                    
                }
                let track = try? SPTTrack(from: data, with: response)
                
                let trackArtist:SPTPartialArtist = ((track?.artists as! NSArray).object(at: 0) as? SPTPartialArtist)!
                
                
                self.musicLibraryC.append(Library(songName:track!.name,songArtist:trackArtist.name,songUri:track!.playableUri.absoluteString))
               
                
            }
            
        }
        
        
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
