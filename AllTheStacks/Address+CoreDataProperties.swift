//
//  Address+CoreDataProperties.swift
//  AllTheStacks
//
//  Created by Adam Ahrens on 8/26/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Address {

    @NSManaged var name: String?
    @NSManaged var city: String?
    @NSManaged var postalCode: String?
    @NSManaged var country: String?
    @NSManaged var fire: Fire?

}
