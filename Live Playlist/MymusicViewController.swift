//
//  MymusicViewController.swift
//  Live Playlist
//
//  Created by Edwin Gomez on 11/28/17.
//  Copyright © 2017 Alejandro Cano. All rights reserved.
//

import UIKit
//import MusicLibraryClass


class MymusicViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, SPTAudioStreamingPlaybackDelegate,SPTAudioStreamingDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getlibrary()
        return tmpmusicLibrary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.accessoryType = .detailButton
        var songN = tmpmusicLibrary[indexPath.row].songName
        
        cell.textLabel?.text = songN
        return cell
    }
    
   // this is the function that happens when you press the button circle thing next to the song
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        //this prints out the uri of each song you click
        //so if you wanna test a song uri just do
        //tmpmusicLibrary[indexPath.row].songUri or tmpmusicLibrary[0].songUri with whatever youre using
        //deuces
        print(tmpmusicLibrary[indexPath.row].songUri)
        
    }
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(tmpmusicLibrary[indexPath.row].songName)
        
    }*/
    
    var tmpmusicLibrary = [Library]()
    
    
    var libarr = [String]()
    var libarry = [String]()
    var libraryCount = 0
    
    var count = NowPlayingViewController().self.musicLibraryC.count
    

    
    func getlibrary() {
        if let data = UserDefaults.standard.value(forKey:"MusicLibrary") as? Data {
            let songs2 = try? PropertyListDecoder().decode(Array<Library>.self, from: data)
            tmpmusicLibrary = songs2!
         
            
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
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
