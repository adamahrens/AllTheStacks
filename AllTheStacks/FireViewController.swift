//
//  FireViewController.swift
//  AllTheStacks
//
//  Created by Steven Vlaminck on 8/26/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class FireViewController: UIViewController {
    
    @IBAction func buttonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var addressLabel: UILabel!
    var fire: Fire? {
        didSet {
            if let fire = fire {
                setupFetchedResultsController()
                let locationLookup = LocationLookupOperation(location: CLLocation(latitude: fire.coordinate.latitude, longitude: fire.coordinate.longitude), fire: fire)
                OperationManager.sharedManager.addOperation(locationLookup)
            }
        }
    }

    var fetchedResultsController: NSFetchedResultsController?
    var managedObjectContext: NSManagedObjectContext {
        get {
            return CoreDataManager.sharedManager.mainManagedObjectContext
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = fire?.fireDescription
        
        // Reverse GeoLocate the address

    }
    
    func updateFireViews() {
        addressLabel.text = fire?.address?.name
    }
    
    func setupFetchedResultsController() {
        let request = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Fire", inManagedObjectContext: managedObjectContext)
        request.entity = entity
        
        if let fire = fire {
            request.predicate = NSPredicate(format: "id==\(fire.id!)")
        }
        
        let sort = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sort]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("¯\\_(ツ)_/¯")
        }
        
        self.fetchedResultsController = fetchedResultsController
        
    }


    
}

extension FireViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        updateFireViews()
    }
}
