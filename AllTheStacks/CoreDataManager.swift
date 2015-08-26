//
//  CoreDataManager.swift
//  AllTheStacks
//
//  Created by Adam Ahrens on 8/25/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import CoreData

class CoreDataManager: NSObject {
    
    // Singleton
    static let sharedManager = CoreDataManager()
    
    // Public
    let mainManagedObjectContext : NSManagedObjectContext        // Main Thread Only
    let backgroundManagedObjectContext : NSManagedObjectContext  // Background Saving
    
    // Private
    private let persistentStoreCoordinator : NSPersistentStoreCoordinator
    private let model: NSManagedObjectModel
    private var persistentStore: NSPersistentStore?
    
    override init () {

        let modelURL = NSBundle.mainBundle().URLForResource("FireModel", withExtension: "momd")
        model = NSManagedObjectModel(contentsOfURL: modelURL!)!
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        // Main Thread
        mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        // Background Thread
        backgroundManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        backgroundManagedObjectContext.mergePolicy = NSMergePolicy(mergeType: .MergeByPropertyStoreTrumpMergePolicyType)
        backgroundManagedObjectContext.parentContext = mainManagedObjectContext
        
        super.init()
        
        if let applicationURL = applicationDocumentsDirectory() {
            let storeURL = applicationURL.URLByAppendingPathComponent("FireModel")
            let migrationOptions = [NSPersistentStoreUbiquitousContentNameKey: "FireModel", NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            do {
                persistentStore = try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: migrationOptions)
            } catch {
                // Not good
                print("Unable to create Persistent Store")
            }
        } else {
            print("Could't find application directory")
        }
        
        
        
        // Monitor for changes in the Background Thread that will be merged into the main
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "backgroundManagedObjectContextDidSave:", name: NSManagedObjectContextDidSaveNotification, object: backgroundManagedObjectContext)
    }
    
    func backgroundManagedObjectContextDidSave(notification: NSNotification) {
        // Dont know the thread called on but want the backgroundContext
        // To propogate the changes to the main thread context
        if let _ = notification.userInfo {
            self.mainManagedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
        }
    }
    
    func applicationDocumentsDirectory() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls.first!
    }
    
    func saveBackgroundChanges() -> Bool {
        if backgroundManagedObjectContext.hasChanges {
            do {
                try backgroundManagedObjectContext.save()
                OperationManager.sharedManager.addOperation(LogOperation(logMessage: "Saved Background"))
                return true
            } catch {
                print("Unable to save Background Managed Object Context")
            }
        }
        
        return false
    }
    
    func saveChanges() -> Bool {
        if mainManagedObjectContext.hasChanges {
            do {
                try mainManagedObjectContext.save()
                return true
            } catch {
                print("Unable to save Managed Object Context changes \(error)")
                return false
            }
        }
        
        return false
    }
}