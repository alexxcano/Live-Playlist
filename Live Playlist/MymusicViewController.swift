//
//  MymusicViewController.swift
//  Live Playlist
//
//  Created by Edwin Gomez on 11/28/17.
//  Copyright © 2017 Alejandro Cano. All rights reserved.
//

import UIKit
//import MusicLibraryClass


class MymusicViewController: UIViewController,UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate, SPTAudioStreamingPlaybackDelegate,SPTAudioStreamingDelegate {
    
    @IBOutlet weak var libraryMusicView: UITableView!
    
    @IBOutlet weak var searchBarField: UISearchBar!
    
    @IBOutlet var searchDController: UISearchDisplayController!
    var session: SPTSession!
    var searchbarClicked = false
    var searchreturnClicked = false
    var searchTracks = [Library]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchreturnClicked && searchbarClicked == false
        {
            return searchTracks.count
        }
        else if searchreturnClicked == false && searchbarClicked == false
        {
            getlibrary()
            return tmpmusicLibrary.count
        }
        else if searchbarClicked && searchreturnClicked == false
        {
            return 1
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()

        if searchreturnClicked && searchbarClicked == false
        {
            cell.accessoryType = .detailButton
            cell.textLabel?.text = searchTracks[indexPath.row].songArtist
            return cell
        }
        else if searchreturnClicked == false && searchbarClicked == false
        {
            cell.accessoryType = .detailButton
            var songN = tmpmusicLibrary[indexPath.row].songName
        
            cell.textLabel?.text = songN
            return cell
        }
        else if searchbarClicked && searchreturnClicked == false
        {
            cell.textLabel?.text = ""
            return cell
        }
        else
        {
            cell.textLabel?.text = ""
            return cell
        }
    }
    
   // this is the function that happens when you press the button circle thing next to the song
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        //this prints out the uri of each song you click
        //so if you wanna test a song uri just do
        //tmpmusicLibrary[indexPath.row].songUri or tmpmusicLibrary[0].songUri with whatever youre using
        //deuces
        if searchreturnClicked == false && searchbarClicked == false
        {
            print(tmpmusicLibrary[indexPath.row].songUri)
        }
        else
        {
            print(searchTracks[indexPath.row].songUri)
        }
        
    }
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(tmpmusicLibrary[indexPath.row].songName)
        
    }*/
    
    var tmpmusicLibrary = [Library]()
    
    
    var libarr = [String]()
    var libarry = [String]()
    var libraryCount = 0
    
    

    
    func getlibrary() {
        if let data = UserDefaults.standard.value(forKey:"MusicLibrary") as? Data {
            let songs2 = try? PropertyListDecoder().decode(Array<Library>.self, from: data)
            tmpmusicLibrary = songs2!
         
            
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarField.delegate = self
        libraryMusicView.delegate = self
        libraryMusicView.dataSource = self
        if let sessionObj:AnyObject = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject? {
            
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            self.session = firstTimeSession
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchreturnClicked = false
        self.searchbarClicked = false
        self.libraryMusicView.reloadData()
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchreturnClicked = false
        searchbarClicked = true
        
    }
    
   
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchreturnClicked = false
        searchbarClicked = false
        print("searchbuttonclicked")
    }
    
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        
        
        if searchTracks.isEmpty == false
        {
            searchTracks.removeAll()
        }
        
        if searchBar.text! == ""
        {
            print("nothing in searchbar")
         
        }
        else
        {
            

            let request: URLRequest = try! SPTSearch.createRequestForSearch(withQuery: searchBar.text!, queryType: SPTSearchQueryType.queryTypeTrack, accessToken: session.accessToken)
            
            SPTRequest.sharedHandler().perform(request) { (error, response, data) in
                if error != nil
                {
                    print(error)
                }
                
                var listPage = try? SPTSearch.searchResults(from: data, with: response, queryType: SPTSearchQueryType.queryTypeTrack)
                
                var count = listPage?.items.count
                for i in 0 ..< count!
                {
                    var track: SPTPartialTrack = listPage?.items[i] as! SPTPartialTrack
                    var trackartist:SPTPartialArtist = ((track.artists as! NSArray).object(at: 0) as? SPTPartialArtist)!
                    self.searchTracks.append(Library(songName: track.name, songArtist: trackartist.name, songUri: track.playableUri.absoluteString))
                }
                
                
                
                
                print(self.searchTracks[0])
                
                DispatchQueue.main.async {
                    self.searchreturnClicked = true
                    self.searchbarClicked = false
                   
                    self.libraryMusicView.reloadData()
                }

            }
            

            
        }
        self.searchDController.isActive = false

        
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
