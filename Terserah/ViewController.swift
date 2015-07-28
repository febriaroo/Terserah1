//
//  ViewController.swift
//  Terserah
//
//  Created by Febria Roosita Dwi on 7/14/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//
//  need to update the Info.plist so the pop up show up (Add NSLocationWhenInUseUsageDescription )

import Foundation
import UIKit
import CoreLocation // For Get the user location
import MapKit // For Showing Maps
import OAuthSwift // For Oauth Request
import Darwin // For random number



class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // Name and address bar (Buttom one)
    

    @IBOutlet weak var nameLocationButtom: UILabel!
    @IBOutlet weak var addressLocationButtom: UILabel!

    // Navigation Bar Items
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var appLogo: UINavigationItem!
    
    // Other Items
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    var myDestination: MKPlacemark!
    
    // Variable for the distance of maps
    let regionRadius: CLLocationDistance = 1000
    
    // Variable for get the Restaurant List
    var businesses: [Restaurant]!
    
    // direction
    var directionku: [String]!
    
    // PM
    var pm: CLPlacemark!
    
    // show messagebox to shake it
    let actionSheetController: UIAlertView = UIAlertView(title: "Shake now!!", message: "Hi! shake it!", delegate: nil, cancelButtonTitle: "Ok!")
    var countShake = 0
    
    // variable longlat
    var longlat: [String]!
    
    var restaurantName:String!
    var restaurantLong:Double!
    var restaurantLat:Double!
    
    @IBAction func DirectionClick(sender: AnyObject) {
        if restaurantName != nil && restaurantLong != nil && restaurantLat != nil  {
            openMapForPlace(restaurantName, venueLat: restaurantLat, venueLng: restaurantLong)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let navBackgroundImage:UIImage! = UIImage(named: "testing")
        
        if countShake == 0 {
            actionSheetController.show()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: function to get the Update Location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                println("ERROR nih! \(error.localizedDescription)")
                return
            }
            
            if placemarks.count > 0 {
                self.pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(self.pm)
                self.locationManager.stopUpdatingLocation()
            } else {
                println("Error with data")
            }
        })
    }
    
    //MARK: Function to show the location data
    func displayLocationInfo(placemarks: CLPlacemark)
    {
        self.locationManager.stopUpdatingLocation()
        
        // println(placemarks.locality)
        // println(placemarks.postalCode)
        // println(placemarks.administrativeArea)
        // println(placemarks.country)
        
        // Show in Maps
        
    }

    //Mark: get Restaurant data after get User Location!
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        self.getData("\(userLocation.location.coordinate.latitude)",location_long : "\(userLocation.location.coordinate.longitude)")
    }
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        openMapForPlace(restaurantName, venueLat: restaurantLat, venueLng: restaurantLong)
    }
    // MARK: GetRestaurantDataFromYelp
    
    func getData(location_lat: String!, location_long: String!) {
        
        var concatLocation = "" + location_lat + "," + location_long
        
        Restaurant.getRealDataFromYelp("Restaurants", sort: .Distance, location: concatLocation, category: ["asianfusion", "burgers"]) { (Restaurant: [Restaurant]!, error: NSError!) -> Void in
            self.businesses = Restaurant
            
            var businessCount: Int = Restaurant.count
            let yourBusinessId = Int(arc4random_uniform(UInt32(businessCount)))
            println(yourBusinessId)
            var i:Int = 0
            
            for business in Restaurant {
                //println(business.businessName!)
                //println(business.businessAddress!)
                //println()
                if i == yourBusinessId {
                    
                    //show in map
                    let restaurantPosition = customAnnotation(coordinate: CLLocationCoordinate2DMake(business.businessCoordinateLatitude, business.businessCoordinateLongitude), title: business.businessName, subtitle: business.businessAddress)
                    self.mapView.viewForAnnotation(restaurantPosition)
                    self.mapView.addAnnotation(restaurantPosition)
                    var coordinateBusiness = CLLocation(latitude: business.businessCoordinateLatitude, longitude: business.businessCoordinateLongitude)
                    self.centerMapOnLocation(coordinateBusiness)
                    self.restaurantName = business.businessName
                    self.restaurantLong = business.businessCoordinateLongitude
                    self.restaurantLat = business.businessCoordinateLongitude
                    
                    // set the direction
                    let myPlacemark = MKPlacemark(placemark: self.pm!)!
                    self.myDestination = MKPlacemark(coordinate: CLLocationCoordinate2DMake(business.businessCoordinateLatitude, business.businessCoordinateLongitude), addressDictionary: nil)
                    let destMKMap = MKMapItem(placemark: self.myDestination)!
                    
                    var directionRequest:MKDirectionsRequest = MKDirectionsRequest()
                    directionRequest.setSource(MKMapItem.mapItemForCurrentLocation())
                    
                    directionRequest.setDestination(destMKMap)
                    
                    let dir = MKDirections(request: directionRequest)
                    dir.calculateDirectionsWithCompletionHandler() {
                        (response:MKDirectionsResponse!, error:NSError!) in
                        if response == nil {
                            println(error)
                            return
                        }
                        println("got directions")
                        let route = response.routes[0] as! MKRoute
                        let poly = route.polyline
                        self.mapView.addOverlay(poly)
                        for step in route.steps {
                            println("After \(step.distance) metres: \(step.instructions)")
                        }
                        // update label
                        self.nameLocationButtom.text = business.businessName
                        self.addressLocationButtom.text = business.businessAddress
                    }
                    break
                }
                i++
                
            }
        }
        println()
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
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation.isKindOfClass(MKUserLocation){
            return nil
        }
        
        var customAnnotationView = self.mapView?.dequeueReusableAnnotationViewWithIdentifier("CustomAnnotationView")
        
        if customAnnotationView == nil {
            customAnnotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotationView")
            customAnnotationView!.canShowCallout = true
            
        } else {
            customAnnotationView?.annotation = annotation
        }
        
        return customAnnotationView
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        var v : MKPolylineRenderer! = nil
        if let overlay = overlay as? MKPolyline {
            v = MKPolylineRenderer(polyline:overlay)
            v.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.8)
            v.lineWidth = 2
        }
        return v
    }
    
    func randomLocationForUser() {
        var businessCount: Int = businesses.count
        let yourBusinessId = Int(arc4random_uniform(UInt32(businessCount)))
        println(yourBusinessId)
    }
    
    // Detect the motion x
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        
        if motion == .MotionShake {
            //get UserLocation
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.mapView.showsUserLocation = true
            self.mapView.delegate = self
            self.mapView.userLocation.title = "I'm Here!"
            self.locationManager.startUpdatingLocation()
            countShake++
            // show messagebox to shake it
            actionSheetController.dismissWithClickedButtonIndex(-1, animated: true)
            
            let annotationsToRemove = mapView.annotations.filter { $0 !== self.mapView.userLocation }
            mapView.removeAnnotations( annotationsToRemove )
            
            self.getData("\(mapView.userLocation.location.coordinate.latitude)",location_long : "\(mapView.userLocation.location.coordinate.longitude)")
        
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //var DestViewController :ListDirectionViewController = segue.destinationViewController as! ListDirectionViewController
        
    }
    
    func openMapForPlace(venueName:String!, venueLat: Double!, venueLng:Double! ) {
        

        var latitute:CLLocationDegrees =  venueLat
        var longitute:CLLocationDegrees = venueLng
        
        let regionDistance:CLLocationDistance = 10000
        var coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        var options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        var mapItem = MKMapItem(placemark: myDestination)
        mapItem.name = "\(venueName)"
        mapItem.openInMapsWithLaunchOptions(options)
        
    }
}

