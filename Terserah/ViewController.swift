//
//  ViewController.swift
//  Terserah
//
//  Created by Febria Roosita Dwi on 7/14/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//
//  need to update the Info.plist so the pop up show up (Add NSLocationWhenInUseUsageDescription )

import UIKit
import CoreLocation // For Get the user location
import MapKit // For Showing Maps
import OAuthSwift // For Oauth Request

class ViewController: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()

    // Variable for the distance of maps
    let regionRadius: CLLocationDistance = 1000
    
    // Variable for get the Restaurant List
     var businesses: [Restaurant]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get UserLocation
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
       
        Restaurant.getRealDataFromYelp("Restaurants", sort: .Distance, category: ["asianfusion", "burgers"]) { (Restaurant: [Restaurant]!, error: NSError!) -> Void in
            self.businesses = Restaurant
            
            for business in Restaurant {
                println(business.businessName!)
                println(business.businessAddress!)
                println()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function to get the Update Location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                println("ERROR nih! \(error.localizedDescription)")
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Error with data")
            }
        })
    }
    
    // Function to show the location data
    func displayLocationInfo(placemarks: CLPlacemark)
    {
        self.locationManager.stopUpdatingLocation()
        
        println(placemarks.locality)
        println(placemarks.postalCode)
        println(placemarks.administrativeArea)
        println(placemarks.country)
        
        // Show in Maps
        println("Latitude \(placemarks.location.coordinate.latitude)")
        centerMapOnLocation(placemarks.location)
        
        // Add the pin into user location
        let hereMe = MKPointAnnotation()
        hereMe.coordinate = placemarks.location.coordinate
        hereMe.title = "I'm here!"
        mapView.addAnnotation(hereMe)
        
        // cobaYelp()
        
    }
    
    // Function to show the error if it failed.
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error nih :( " + error.localizedDescription)
    }

    // Function for center the location (Radius)
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}

