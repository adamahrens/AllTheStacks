//
//  Fire.swift
//  AllTheStacks
//
//  Created by Adam Ahrens on 8/25/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import Foundation
import CoreData

class Fire: NSManagedObject {
    class func create(dictionary : NSDictionary, managedObjectContext: NSManagedObjectContext) {
        guard let incidents = dictionary["features"] as? NSArray else {
            return
        }
        
        // Incident is a Dictionary
        for incident in incidents {
            if let id = incident["id"] as? Int, property = incident["properties"] as? NSDictionary {
                // We have the id of the incident, look at the properties in
                let fireDescription = property["descript"] as? String
                let latitude = property["latitude"] as? Double
                let longitude = property["longitude"] as? Double
                
                let entityDescription = NSEntityDescription.entityForName("Fire", inManagedObjectContext: CoreDataManager.sharedManager.backgroundManagedObjectContext)
                let fire = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: CoreDataManager.sharedManager.backgroundManagedObjectContext) as! Fire
                
                fire.id = NSNumber(integer: id)
                fire.fireDescription = fireDescription
                fire.latitude = NSNumber(double: latitude!)
                fire.longitude = NSNumber(double: longitude!)
                
                // Save it
                CoreDataManager.sharedManager.saveBackgroundChanges()
            }
        }
    }
}
