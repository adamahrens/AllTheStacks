//
//  LocationLookupOperation.swift
//  AllTheStacks
//
//  Created by Adam Ahrens on 8/26/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import UIKit
import CoreLocation

final class LocationLookupOperation: NSOperation {
    
    private let location: CLLocation
    private let fire: Fire
    
    init(location: CLLocation, fire: Fire) {
        self.location = location
        self.fire = fire
    }
    
    override func main() {
        let geolocation = CLGeocoder()
        geolocation.reverseGeocodeLocation(location) { placemarks, error in
            if let placemarks = placemarks where placemarks.count > 0 {
                if let placemark = placemarks.first {
                    print("Name = \(placemark.name)")
                    print("Locality = \(placemark.locality)")
                    print("Country = \(placemark.country)")
                    print("Postal Code = \(placemark.postalCode)")
                }
            }
        }
    }
}
