//
//  WeatherVC.swift
//  Weather Finder
//
//  Created by Matthew Jennell on 4/2/17.
//  Copyright © 2017 Matt Jennell. All rights reserved.
//

import UIKit
import CoreData

class WeatherVC: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var currentWeather: WeatherModel?
    
    //==================================SETUP==================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadWeather()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupWeather() {
        if let currentWeather = currentWeather {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMMM dd"
            dateLabel.text = "\(formatter.string(from: Date()))"
            
            cityStateLabel.text = "\((currentWeather.city).capitalized), \((currentWeather.state).uppercased())"
            
            currentTempLabel.text = "\(Int(convertFromKelvinToFahrenheit(kelvin: currentWeather.currentTemp)))"
            
            currentWeatherImageView.image = UIImage(named: currentWeather.image)
            
            descriptionTextView.text = "The current weather is \(currentWeather.description). The wind is coming out of the \(convertFromDegreesToDirection(degrees: currentWeather.windDirection)) at \((convertMStoMPH(ms: currentWeather.windSpeed).roundToDecimal(2))) mph. The humidity is at \(currentWeather.humidity)%."
        }
    }
    
    //==================================ALERT==================================

    func popAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }

    
    //==================================DATABASE==================================
    
    func loadWeather() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext

        // gather all weather objects
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Weather")
        
        do {
            // setup the weather based on the city, state last searched
            // should only be one object
            let weatherObjects = try managedContext.fetch(fetchRequest)
            if weatherObjects.count > 0 {
                let weather = weatherObjects.first
                var city = weather?.value(forKey: "city") as? String ?? ""
                let state = weather?.value(forKey: "state") as? String ?? ""
                city = city.replacingOccurrences(of: " ", with: "_")
                searchForCity(city: city, state: state)
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllWeatherObjects() {
        // delete all weather objects in database
        // only need to have one weather object be persistent
        // avoids database build up
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func saveWeather(city: String, state: String) {
        
        deleteAllWeatherObjects()
        
        // save the city, state of last search
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Weather",
                                       in: managedContext)!
        
        let weather = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        weather.setValue(city, forKeyPath: "city")
        weather.setValue(state, forKeyPath: "state")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //==================================JSON==================================

    func searchForCity(city: String, state: String) {
        // connect to url
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city),\(state),us&APPID=b8d4804ac78e16bfb8a6e27ea93c0eb9")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    // get JSON from our url result
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        // setup a weather struct
                        self.currentWeather = WeatherModel()
                        
                        self.currentWeather!.city = city.replacingOccurrences(of: "_", with: " ")
                        self.currentWeather!.state = state.uppercased()
                        
                        if let weather = json["weather"] as? [[String: Any]] {
                            self.currentWeather!.description = weather[0]["description"] as? String ?? ""
                            self.currentWeather!.image = weather[0]["icon"] as? String ?? ""
                        }
                        
                        if let wind = json["wind"] as? [String: Any] {
                            self.currentWeather!.windSpeed = wind["speed"] as? Double ?? 0.0
                            self.currentWeather!.windDirection = wind["deg"] as? Double ?? 0.0
                        }
                        
                        if let main = json["main"] as? [String: Any] {
                            self.currentWeather!.currentTemp = main["temp"] as? Double ?? 0.0
                            self.currentWeather!.humidity = main["humidity"] as? Int ?? 0
                        }
                        
                        DispatchQueue.main.sync {
                            self.setupWeather()
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
        let searchInput = searchTextField.text ?? ""
        let splitInput = searchInput.components(separatedBy: ",")
        var city: String = ""
        var state: String = ""
        
        // format the search to the desired API input
        // throwing alerts here are just a quick implementation to avoid crashes
        // FIX: populate a tableview with possible choices
        if splitInput.count != 2 {
            popAlert(title: "Invalid Input", message: "Please make sure your input is in the City, State format")
        } else {
            city = splitInput[0].trimmingCharacters(in: CharacterSet.whitespaces)
            state = splitInput[1].trimmingCharacters(in: CharacterSet.whitespaces).lowercased()
            let cityFormatted = city.replacingOccurrences(of: " ", with: "_")
            if state.characters.count != 2 {
                popAlert(title: "Invalid State", message: "Please use the USPS Abbreviation for the state")
            } else {
                saveWeather(city: city, state: state)
                searchForCity(city: cityFormatted, state: state)
            }
        }
    }

    //==================================CONVERSIONS==================================

    func convertMStoMPH(ms: Double) -> Double {
       return ms / 0.44704
    }
    
    func convertFromKelvinToFahrenheit(kelvin: Double) -> Double {
        return (kelvin * 9/5 - 459.67).roundToDecimal(2)
    }
    
    func convertFromDegreesToDirection(degrees: Double) -> String {
        if degrees < 33.75 {
            return "North"
        } else if degrees >= 33.75 && degrees < 56.25 {
            return "North East"
        } else if degrees >= 56.25 && degrees < 123.75 {
            return "East"
        } else if degrees >= 123.75 && degrees < 146.25 {
            return "South East"
        } else if degrees >= 146.25 && degrees < 213.75 {
            return "South"
        } else if degrees >= 213.75 && degrees < 236.25 {
            return "South West"
        } else if degrees >= 236.25 && degrees < 303.75 {
            return "West"
        } else if degrees >= 303.75 && degrees < 326.25 {
            return "North West"
        } else {
            return "North"
        }
        
    }
}
