//
//  MusicLibraryClass.swift
//  Live Playlist
//
//  Created by Edwin Gomez on 11/29/17.
//  Copyright © 2017 Alejandro Cano. All rights reserved.
//

import Foundation

struct Library: Codable {
    var songName: String
    var songArtist: String
    var songUri: String
    
    init(){
        self.songUri = ""
        self.songArtist = ""
        self.songName = ""
    }
    
    init(songName: String, songArtist: String, songUri: String)
    {
        self.songName = songName
        self.songArtist = songArtist
        self.songUri = songUri
    }
}
