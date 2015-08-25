//
//  CoreDataManager.swift
//  AllTheStacks
//
//  Created by Adam Ahrens on 8/25/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    // Singleton
    static let sharedManager = CoreDataManager()
    
    // Public
    let managedObjectContext : NSManagedObjectContext
    
    // Private
    private let persistentStoreCoordinator : NSPersistentStoreCoordinator?
    private let model: NSManagedObjectModel
    private var persistentStore: NSPersistentStore?
    
    init () {
        let modelURL = NSBundle.mainBundle().URLForResource("FILL IN LATER", withExtension: "momd")
        model = NSManagedObjectModel(contentsOfURL: modelURL!)!
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        if let applicationURL = applicationDocumentsDirectory() {
            let storeURL = applicationURL.URLByAppendingPathComponent("FILL IN LATER")
            let migrationOptions = [NSPersistentStoreUbiquitousContentNameKey: "FILL IN LATER", NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            do {
                persistentStore = try persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: migrationOptions)
            } catch {
                // Not good
                print("Unable to create Persistent Store")
            }
        } else {
            print("Could't find application directory")
        }
    }
    
    func applicationDocumentsDirectory() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls.first!
    }
    
    func saveChanges() -> Bool {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                return true
            } catch {
                print("Unable to save Managed Object Context changes \(error)")
                return false
            }
        }
        
        return false
    }
}