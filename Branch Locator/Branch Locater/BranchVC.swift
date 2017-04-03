//
//  BranchVC.swift
//  Branch Locator
//
//  Created by Matthew Jennell on 4/1/17.
//  Copyright © 2017 Matt Jennell. All rights reserved.
//

import UIKit

class BranchVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var labelLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var atmLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var lobbyHoursTextView: UITextView!
    @IBOutlet weak var driveUpHoursTextView: UITextView!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    
    var branch: Branch?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Branch"
        // Do any additional setup after loading the view.
        if let branch = branch {
            nameLabel.text = "Name: \(branch.name)"
            bankLabel.text = "Bank: \(branch.bank)"
            labelLabel.text = "Label: \(branch.label)"
            typeLabel.text = "Type: \(branch.type)"
            addressLabel.text = "Address: \(branch.address)"
            cityLabel.text = "City: \(branch.city)"
            stateLabel.text = "State: \(branch.state)"
            zipLabel.text = "Zip: \(branch.zip)"
            accessLabel.text = "Access: \(branch.access)"
            lobbyHoursTextView.text = "Lobby Hours: \(branch.lobbyHours.flatMap({$0}).joined(separator: "\n"))"
            driveUpHoursTextView.text = "Drive Up Hours: \(branch.driveHours.flatMap({$0}).joined(separator: "\n"))"
            atmLabel.text = "ATMs: \(branch.atms)"
            serviceLabel.text = "\(branch.services.flatMap({$0}).joined())"
            phoneLabel.text = "Phone: \(branch.phone)"
            distanceLabel.text = "Distance: \(branch.distance)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
