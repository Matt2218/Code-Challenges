//
//  SearchResult.swift
//  Music Search
//
//  Created by Matthew Jennell on 3/31/17.
//  Copyright © 2017 Matt Jennell. All rights reserved.
//

import Foundation

// holds information for the individual search results
struct SearchResult {
    var track: String
    var album: String
    var artist: String
    var image: String
    var lyrics: String?
    
    init(trackName: String, albumName: String, artistName: String, imageLink: String) {
        track = trackName
        album = albumName
        artist = artistName
        image = imageLink
                
        lyrics = "http://lyrics.wikia.com/api.php?func=getSong&artist=\(artist.replacingOccurrences(of: " ", with: "+"))&song=\(track.replacingOccurrences(of: " ", with: "+"))&fmt=json"
    }
}
