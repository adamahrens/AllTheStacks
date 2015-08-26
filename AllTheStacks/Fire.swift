//
//  Fire.swift
//  AllTheStacks
//
//  Created by Adam Ahrens on 8/25/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Fire: NSManagedObject {
    class func create(dictionary : NSDictionary, managedObjectContext: NSManagedObjectContext) {
        guard let incidents = dictionary["features"] as? NSArray else {
            return
        }
        
        // Incident is a Dictionary
        for incident in incidents {
            if let id = incident["id"] as? Int, property = incident["properties"] as? NSDictionary {
                
                let fetchRequest = NSFetchRequest(entityName: "Fire")
                let predicate = NSPredicate(format: "id == \(id)")
                fetchRequest.predicate = predicate
                
                do {
                    let result = try CoreDataManager.sharedManager.mainManagedObjectContext.executeFetchRequest(fetchRequest)
                    if result.count > 0 {
                        return;
                    }
                } catch {
                    OperationManager.sharedManager.addOperation(LogOperation(logMessage: "Error finding exisiting fires"))
                }
                
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
            }
        }
    }
}

extension Fire: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude!), longitude: CLLocationDegrees(longitude!))
        }
    }
    
    var title: String? {
        get {
            return fireDescription
        }
    }
}
