//
//  SearchResultCell.swift
//  Music Search
//
//  Created by Matthew Jennell on 3/31/17.
//  Copyright © 2017 Matt Jennell. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    var result: SearchResult! {
        didSet {
            // setup labels based on information
            trackNameLabel.text = "Track: \(result.track)"
            artistNameLabel.text = "Artist: \(result.artist)"
            albumNameLabel.text = "Album: \(result.album)"
            
            // get the image from the url
            if let url = NSURL(string: result.image) {
                if let data = NSData(contentsOf: url as URL) {
                    albumImageView.image = UIImage(data: data as Data)
                }        
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
