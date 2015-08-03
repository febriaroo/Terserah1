//
//  Restaurant.swift
//  Terserah
//
//  Created by Febria Roosita Dwi on 7/16/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//

import Foundation
import UIKit

class Restaurant: NSObject {
    var businessId : String!
    var businessName : String!
    var businessImage : String!
    var businessCoordinateLongitude : Double!
    var businessCoordinateLatitude : Double!
    var businessUrl : NSURL!
    var businessImageUrl : NSURL!
    var businessPhone : String!
    var businessAddress : String!
    
    init(dictionary : NSDictionary){
        
        // declare all the dictionary
        businessId = dictionary["id"] as? String
        businessName = dictionary["name"] as? String
        
        let ratingBusinessURL = dictionary["rating_img_url_small"] as? String
        if(ratingBusinessURL != nil){
            businessUrl = NSURL(string: ratingBusinessURL!)
        } else {
            businessUrl = nil
        }
        let imgBusinessURL = dictionary["image_url"] as? String
        if(imgBusinessURL != nil){
            businessImageUrl = NSURL(string: imgBusinessURL!)
        } else {
            businessImageUrl = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            var street: String? = ""
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            self.businessAddress = address
        }
        //println()
        //println(dictionary)
        let coordinate = location!["coordinate"] as? NSDictionary
        if coordinate != nil {
            businessCoordinateLatitude  = coordinate!["latitude"] as? Double
            businessCoordinateLongitude = coordinate!["longitude"] as? Double
        }
        //println("Koodinate : \(businessCoordinateLatitude),\(businessCoordinateLongitude)")
        
    }
    
    // Declare and add the Restaurant
    class func restaurants(#array: [NSDictionary]) -> [Restaurant] {
        var theRestaurants = [Restaurant] ()
        for dictionary in array {
            var restaurant = Restaurant(dictionary: dictionary)
            theRestaurants.append(restaurant)
        }
        return theRestaurants
    }
    
    class func getDataFromYelp(term: String, completion: ([Restaurant]!, NSError!) -> Void) {
        YelpAPI.sharedInstance.getDataFromYelp(term, completion: completion)
    }
    
    class func getRealDataFromYelp(term: String, sort: YelpSortMode?, location: String!, category: [String]!,completion: ([Restaurant]!, NSError!) -> Void) {
        YelpAPI.sharedInstance.getDataFromYelp(term, sort: sort, location: location, category: category, completion: completion)
    }
}