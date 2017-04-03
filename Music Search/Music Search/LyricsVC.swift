//
//  LyricsVCViewController.swift
//  Music Search
//
//  Created by Matthew Jennell on 3/31/17.
//  Copyright © 2017 Matt Jennell. All rights reserved.
//

import UIKit

class LyricsVC: UIViewController {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var lyricsTextView: UITextView!
    
    var selectedTrack: SearchResult?
    
    //==================================SETUP==================================

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Song"
        if let selectedTrack = selectedTrack {
            // setup values
            trackNameLabel.text = "Track: \(selectedTrack.track)"
            artistNameLabel.text = "Artist: \(selectedTrack.artist)"
            albumNameLabel.text = "Album: \(selectedTrack.album)"
            
            // get image from url
            if let url = URL(string: selectedTrack.image) {
                do {
                    let data = try Data(contentsOf: url)
                    albumImage.image = UIImage(data: data)
                } catch {
                    print("unable to get image")
                }
            }
            
            // this is not good code
            // the JSON object that we are fetching is not in the proper format for Swift
            // thus we have to parse out the string keys for the lyrics
            let url = URL(string: selectedTrack.lyrics!)!
            do {
                // contents of url
                var text = try "\(String(contentsOf: url).replacingOccurrences(of: "song = ", with: ""))}"
                
                // removes strings before and after lyrics key
                let startIndex = text.range(of: "lyrics\':\'")?.upperBound
                let endIndex = text.range(of: "\',\n'url")?.lowerBound
                
                let firstPart = text.substring(to: startIndex!)
                let secondPart = text.substring(from: endIndex!)
                
                text = text.replacingOccurrences(of: firstPart, with: "")
                text = text.replacingOccurrences(of: secondPart, with: "")
                
                lyricsTextView.text = text
                
            } catch {
                print("unable to get lyrics")
            }

            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
