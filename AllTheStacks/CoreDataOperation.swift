//
//  CoreDataOperation.swift
//  AllTheStacks
//
//  Created by Adam Ahrens on 8/25/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import UIKit

final class CoreDataOperation: NSOperation {
    
    // The CoreDataModel class to create
    private let model: AnyClass
    
    // The data we need to add to the CoreData
    var dictionary: NSDictionary?
    
    init(model: AnyClass) {
        self.model = model
    }
    
    override func main() {
        guard let dataDictionary = dictionary else {
            return
        }
        
        // Lets make a Fire
        if model == Fire.self {
            Fire.create(dataDictionary, managedObjectContext: CoreDataManager.sharedManager.backgroundManagedObjectContext)
            
            // Save it
            CoreDataManager.sharedManager.saveBackgroundChanges()
            CoreDataManager.sharedManager.saveChanges()
        }
    }
}
