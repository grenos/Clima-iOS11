//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit


/// IN order to pass data between two classes
/// we need to set one of them to be the delegate
// so in this case the "weather view controller" will be the delegate of "Change city view controller"
// so the delegate can handle the methods of the ChangeCityViewController
///to do that we need to declare a protocol (what methods can the delegate access)
// this is NOT like calling a function of one class from another class
// instead we give access to the delegate to implement fully this method
protocol ChangeCityDelegate {
    func userEnteredNewCityNAme (city: String)
}


class ChangeCityViewController: UIViewController {
    
    //Declare the delegate variable here:
    // and make it an optional
    var delegate: ChangeCityDelegate?
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        //1 Get the city name the user entered in the text field
        let cityName = changeCityTextField.text!
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        /// if the delegat is not nil then do...
        // called optional chaining 
        // a different way to optional binding
        delegate?.userEnteredNewCityNAme(city: cityName)
        
        
        // this basically says close the modal and go back to main page
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
