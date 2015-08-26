//
//  Address.swift
//  AllTheStacks
//
//  Created by Adam Ahrens on 8/26/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import Foundation
import CoreData

class Address: NSManagedObject {
    class func create(dictionary : [String: String], managedObjectContext: NSManagedObjectContext) -> Address {
        
        let entityDescription = NSEntityDescription.entityForName("Address", inManagedObjectContext: managedObjectContext)
        let address = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext) as! Address
        address.name = dictionary["Name"]
        address.city = dictionary["Locality"]
        address.postalCode = dictionary["Postal"]
        address.country = dictionary["Country"]
        return address
    }
}
