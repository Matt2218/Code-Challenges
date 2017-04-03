//
//  ViewController.swift
//  Branch Locator
//
//  Created by Matthew Jennell on 4/1/17.
//  Copyright © 2017 Matt Jennell. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var itemSource: [Branch] = []
    var itemSourceIds: [String] = []
    var selectedPin: Branch?
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        // delegates
        locationManager.delegate = self
        mapView.delegate = self

        // location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //==================================LOCATION==================================

    func centerMap(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 10000, 10000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .notDetermined && status != .denied && status != .restricted {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locationManager.location != nil {
            gatherBranchLocations(location: locationManager.location!)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func gatherBranchLocations(location: CLLocation) {
        // location
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        centerMap(location: location)
        
        // get JSON information
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://m.chase.com/PSRWeb/location/list.action?lat=\(lat)&lng=\(long)")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    // get JSON from our url result
                    if let jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    {
                        
                        if let resultsArray = jsonObject["locations"] as? [[String: Any]] {
                            // gather all branches
                            // look for branches based on location lat/long
                            for dict in resultsArray {
                                let branchResult = Branch(state: dict["state"] as? String ?? "",
                                                          type: dict["locType"] as? String ?? "",
                                                          label: dict["label"] as? String ?? "",
                                                          address: dict["address"] as? String ?? "",
                                                          city: dict["city"] as? String ?? "",
                                                          zip: dict["zip"] as? String ?? "",
                                                          name: dict["name"] as? String ?? "",
                                                          lat: dict["lat"] as? String ?? "",
                                                          lng: dict["lng"] as? String ?? "",
                                                          bank: dict["bank"] as? String ?? "",
                                                          branchType: dict["type"] as? String ?? "",
                                                          lobbyHours: dict["lobbyHrs"] as? [String] ?? [],
                                                          driveHours: dict["driveUpHrs"] as? [String] ?? [],
                                                          atms: dict["atms"] as? Int ?? 0,
                                                          services: dict["services"] as? [String] ?? [],
                                                          access: dict["access"] as? String ?? "",
                                                          phone: dict["phone"] as? String ?? "",
                                                          distance: dict["distance"] as? Double ?? 0.0)
                                
                                // not the best way to handle this
                                // using lat\long as id so that we don't append location twice
                                if !self.itemSourceIds.contains(branchResult.lat + branchResult.lng) {
                                    self.itemSourceIds.append(branchResult.lat + branchResult.lng)
                                    self.itemSource.append(branchResult)
                                }
                            }
                            
                            DispatchQueue.main.sync {
                                // add pins to map
                                for pin in self.itemSource {
                                    self.mapView.addAnnotation(pin)
                                }
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
    
    //==================================MAP==================================

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedPin = view.annotation as? Branch
        self.performSegue(withIdentifier: "mapToBranchSegue", sender: self)
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        gatherBranchLocations(location: CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude))
    }
    
    //==================================SEGUES==================================
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapToBranchSegue" {
            let branchVC = segue.destination as! BranchVC
            branchVC.branch = selectedPin!
        }
    }
    
}

