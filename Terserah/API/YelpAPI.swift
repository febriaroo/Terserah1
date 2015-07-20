//
//  YelpAPI.swift
//  Terserah
//
//  Created by Febria Roosita Dwi on 7/17/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//

import Foundation
import UIKit

// Yelp API Data for Authentification
let yelpConsumerKey = "4NfKOsHsLC8JRaTUK0ib9Q"
let yelpConsumerSecret = "bZOxKiEGCUZI5H2B8cHFgtIIszA"
let yelpToken = "bIDJQFRYYARA-E5NFqUtTYZoAyZCMy_d"
let yelpTokenSecret = "1G4xB2kup172heZu-MJCVyu71D8"
let yelpSignatureMethod = "hmac-sha1"

let yelpMethodName = "search"
let yelpTimestamp = NSDate().timeIntervalSince1970

enum YelpSortMode: Int {
    case BestMatched = 0, Distance, HighestRated
}

class YelpAPI: BDBOAuth1RequestOperationManager{
    // Customer Key and secret
    var accessToken : String!
    var accessSecret : String!

    class var sharedInstance : YelpAPI {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : YelpAPI? = nil
        }
        
        dispatch_once(&Static.token) {
            Static.instance = YelpAPI(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
            println ("Yelp API dispatch: success")
        }
        return Static.instance!
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!)
    {
        // Set the accessSecret and accessToken for the initialitation
        self.accessSecret = accessSecret
        self.accessToken = accessToken
        
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        
        // call the init class in BDBOAuth1RequestOperationManager
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret)
        
        // get the token!
        var token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        
        // using for HTTP Request
        self.requestSerializer.saveAccessToken(token)
    }
    
    func getDataFromYelp(term: String, completion: ([Restaurant]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        // this function will return a request for HTTP using AFHTTPRequestOperation
        
        return getDataFromYelp(term, sort: nil, category: nil, completion: completion)
    }

    func getDataFromYelp(term: String, sort: YelpSortMode?, category: [String]!,completion: ([Restaurant]!, NSError!) -> Void) -> AFHTTPRequestOperation {
    
        // Default the location to San Francisco
        var parameters: [String : AnyObject] = ["term": term, "ll": "37.785771,-122.406165"]
        
        if sort != nil {
            parameters["sort"] = sort!.rawValue
        }
        
        if category != nil && category!.count > 0 {
            parameters["category_filter"] = ",".join(category!)
        }
        
        println(parameters)
        
        return self.GET("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var dictionaries = response["businesses"] as? [NSDictionary]
            if dictionaries != nil {
                completion(Restaurant.restaurants(array: dictionaries!), nil)
            }
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(nil, error)
        })
    }


    
}
