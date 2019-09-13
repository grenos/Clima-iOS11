//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation


/// our class conforms to the rules of CLLocationManagerDelegate
class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    // let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    let APP_ID = "2de17f54441ca48dc37a4971a4d2a1dd"

    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()

    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// delegates
        // https://medium.com/@jamesrochabrun/implementing-delegates-in-swift-step-by-step-d3211cbac3ef
        // Delegates are a design pattern that allows one object
        // to send messages to another object when a specific event happens.
        // to use the functionality of the CLLocationManager we need to
        // set this class as its delegate
        // hence accessing the delgate prop we set it to = self(this class)
        locationManager.delegate = self
        // set gps accuracy
        // -- the better the accuracy the slower to get a position
        // -- the more battery it consumes
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // auth popup for gps use
        // need to change the info on the plist file
        // add -- Privacy - Location When In Use Usage Description
        // add -- Privacy - Location Usage Description
        locationManager.requestWhenInUseAuthorization()
        // starts looking for gps coordinates
        // its an async method (not on the main thred)
        // on completion of the proccess informs its delegate (this class)
        // like a .then()
        locationManager.startUpdatingLocation()
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    // Write the didUpdateLocations method here:
    // tells the delegate that new location data is available
    // .then()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let location = locations[locations.count - 1]
        
        // control that the data we got are correct-ish
        // if not stop updating the location
        // otherwise we drain the phone's battery
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
        }
        
        // get coordinates to send to api request
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        /// dictionary
        // an array that behaves like an object
        // has keys and values
        // here we declare the structure of the data // key: string and value: string
        let params: [String : String] = ["lat": String(latitude), "lon": String(longitude), "appid": APP_ID]
    }
    
    
    //Write the didFailWithError method here:
    // tells the delegate that the location manager was unable to find a location
    // .error()
    func locationManager( _ manager: CLLocationManager, didFailWithError error: Error){
        print(error)
        cityLabel.text = "Location Unanvailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


