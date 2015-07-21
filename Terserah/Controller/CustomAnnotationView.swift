//
//  CustomAnnotationView.swift
//  Terserah
//
//  Created by Febria Roosita Dwi on 7/20/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CustomAnnotationView: MKAnnotationView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        var frame = self.frame
        frame.size = CGSizeMake(60, 60)
        self.frame = frame
        self.backgroundColor = UIColor.clearColor()
        self.centerOffset = CGPointMake(-5,-5);
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        //drawing code
        UIImage(named: "bread.png")?.drawInRect(CGRectMake( 30, 30, 30, 30))
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
