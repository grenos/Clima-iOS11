//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON



/// our class conforms to the rules of CLLocationManagerDelegate
/// and ChangeCityDelegate Protocol of the changeCityViewController
class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "2de17f54441ca48dc37a4971a4d2a1dd"

    
    //TODO: Declare instance variables here
    // init the locationManager class
    let locationManager = CLLocationManager()
    // init the dataModel class
    let weatherDataModel = WeatherDataModel()
    
    
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
        // hence accessing the delgate prop we set it to = self (this class)
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
    // call api here using Alamofire (like axios)
    func getWeatherData (url: String, parameters: [String : String]) {
        
        // makes an async call to the api
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            // keyword "in" means we are inside a closure (callback)
            // like writting res => {}
            response in
            if response.result.isSuccess {
                print("Succes retrieving data")
                // save the json response in a const
                // we need to convert it to a JSON because the returned .value has type any?
                // JSON is from swiftyJSON??
                let weatherJSON : JSON = JSON(response.result.value!)
                // here we need to reference self (the class) because we point to a function
                // out of this closure's scope (function that's at the body of the class)
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection issues"
            }
        }
    }

    
    

    //MARK: - JSON Parsing
    /***************************************************************/
   
    //Write the updateWeatherData method here:
    // pass the API info to the weather data model
    func updateWeatherData (json: JSON) {
        // we are looking inside the dictionary (objecct)
        // we are asking for the key "main" (has for value an object)
        // and then for the key "temp" inside the objet value of "main"
        // so in essence we are taking the temperature value
        // also with .double we convert it to double (integer with decimal)
        // because is still a JSON here
        /// we also use optional binding with the if statement
        // if the value from the api exists do the rest
        if let tempResult = json["main"]["temp"].double {
            // set the results of the api call temperature
            // to the var "temperature" we created in the data model class
            // the temperature relsult is in Kelvin
            // and in order to convert it to Celcius we need to subtract 273.15
            // we also convert the value from double to int
            // to be able to do math
            weatherDataModel.temperature = Int(tempResult - 273.15)
            
            // same thing for the city name
            // we convert it to string by using .stringValue
            weatherDataModel.city = json["name"].stringValue
            
            // same thing for the code for the current weather condition
            // we look for -- weather array --> its first Element(object) --> key id
            // weatherCondition var is declared as an Int so we convert to an Int
            weatherDataModel.weatherCondition = json["weather"][0]["id"].intValue
            
            // we update the value of the weatherIconName var from data model class
            // with the return of the method inside the data model class
            // passing the value of the weather condition var we set aboe
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.weatherCondition)
            
            // call the UI method after everything is setup
            updateUiWithWeatherData()
            
        } else {
            // tell the user that we cant get the weather
            cityLabel.text = "Weather Unavailable"
        }
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    // update UI with values set on the data model class
    func updateUiWithWeatherData () {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = String(weatherDataModel.temperature)
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    // Write the didUpdateLocations method here:
    // tells the delegate that new location data is available
    // .then()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        // locationManager returns an array with coordinates every time the gps is running
        // here we are accesing this array taking the latest location found (newest)
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
        // looks like an array - - behaves like an object
        // has keys and values
        // here we declare the structure of the data // key: string and value: string
        let params: [String : String] = ["lat": String(latitude), "lon": String(longitude), "appid": APP_ID]
        
        // call the method that calls the api
        getWeatherData(url: WEATHER_URL, parameters: params)
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
    func userEnteredNewCityNAme(city: String) {
        print(city)
    }

    
    ///every UIViewController has a method that's called "Prepare For Segue"
    // it performs the actions that will happen just before the segue action go ahead
    // like a componentDidUnmount
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //check if the segue indentifier is the one we want
        //and then perform an action
        if segue.identifier == "changeCityName" {
            //we set the destination of this segue as the ChangeCityVC
            //so we can have access to the controller's properties
            /// as! ChangeCityVC we tell the compiler that
            //destinationVC will be of type UIViewController
            let destinationVC = segue.destination as! ChangeCityViewController
            // before we segue to the other view controller
            // we set the this class as the delegate for the protocol with self
            destinationVC.delegate = self
        }
    }
    
    
    
    
}


