//
//  ViewController.swift
//  Music Search
//
//  Created by Matthew Jennell on 3/31/17.
//  Copyright © 2017 Matt Jennell. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var itemSource: [SearchResult] = []
    private var selectedTrack: SearchResult?
    
    //==================================SETUP==================================

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cells
        tableView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "ResultCellID")

        // setup UI look
        activityIndicator.hidesWhenStopped = true
        searchButton.layer.borderWidth = 1
        searchButton.layer.cornerRadius = 5
        searchButton.layer.borderColor = UIColor.blue.cgColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(SearchVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func gatherSearchResults(searchTerm: String) {
        // let user know app is working
        activityIndicator.startAnimating()
        
        // connect to url
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://itunes.apple.com/search?term=tom+waits")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    // get JSON from our url result
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        if let resultsArray = json["results"] as? [[String: Any]] {
                            // gather all tracks
                            // look for songs that contain the search term in the track name
                            // I limitied it to only look for tracks with the search term
                            // you could through any/all keys for search term as well
                            for dict in resultsArray {
                                let trackName = (dict["trackName"] as! String).lowercased()
                                if trackName.contains(searchTerm) {
                                    let resultItem = SearchResult(trackName: dict["trackName"] as? String ?? "", albumName: dict["collectionName"] as? String ?? "", artistName: dict["artistName"] as? String ?? "", imageLink: dict["artworkUrl100"] as? String ?? "")
                                    self.itemSource.append(resultItem)
                                }
                            }
                            DispatchQueue.main.sync {
                                // update the UI from the main thread
                                self.activityIndicator.stopAnimating()
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                } catch {
                    print("error getting JSON")
                }
            }
            
        })
        task.resume()
    }
    
    //==================================ACTIONS==================================

    @IBAction func searchButtonPressed(_ sender: Any) {
        if searchTextField.text == nil || searchTextField.text == "" {
            // invalid search
            let alertVC = UIAlertController(title: "Invalid Search", message: "You did not enter a valid search term, please try again.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        } else {
            // valid search
            itemSource = []
            gatherSearchResults(searchTerm: searchTextField.text!.lowercased())
        }
    }
    
    //==================================TABLEVIEW==================================
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCellID", for: indexPath) as! SearchResultCell
        cell.result = itemSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = itemSource[indexPath.row]
        if selected.lyrics == nil {
            // invalid lyrics link
            let alertVC = UIAlertController(title: "Lyrics Not Found", message: "The lyric page you are looking for is unavailable", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        } else {
            // valid lyric link
            selectedTrack = selected
            self.performSegue(withIdentifier: "displayLyricsSegue", sender: self)
        }
    }

    //==================================SEGUES==================================

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayLyricsSegue" {
            // set the selected song
            let lyricVC = segue.destination as! LyricsVC
            lyricVC.selectedTrack = selectedTrack!
        }
    }
    
    //==================================KEYBOARD==================================

    func keyboardWillShow(_ notification: Notification) {
        // get keyboard height and move bottom constraint up
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        bottomConstraint.constant = keyboardHeight
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = 0
    }
}

