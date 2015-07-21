//
//  customAnnotation.swift
//  Terserah
//
//  Created by Febria Roosita Dwi on 7/20/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class customAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?)
    {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
   
}
