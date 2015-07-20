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
    var businessUrl : NSURL!
    var businessPhone : String!
    var businessAddress : String!
    
    init(dictionary : NSDictionary){
        
        // declare all the dictionary
        businessId = dictionary["id"] as? String
        businessName = dictionary["name"] as? String
        
        let imgBusinessURL = dictionary["image_url"] as? String
        if(imgBusinessURL != nil){
            businessUrl = NSURL(string: imgBusinessURL!)
        } else {
            businessUrl = nil
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
    
    class func getRealDataFromYelp(term: String, sort: YelpSortMode?, category: [String]!,completion: ([Restaurant]!, NSError!) -> Void) {
        YelpAPI.sharedInstance.getDataFromYelp(term, sort: sort, category: category, completion: completion)
    }
}