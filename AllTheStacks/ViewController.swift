//
//  ViewController.swift
//  AllTheStacks
//
//  Created by Adam Ahrens on 8/25/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    @IBAction func buttonPressed(sender: AnyObject) {
        guard let button = sender as? UIButton else { return }
        
        print(button.titleLabel?.text)
    }
    
    var managedObjectContext: NSManagedObjectContext {
        get {
            return CoreDataManager.sharedManager.backgroundManagedObjectContext
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        setupFetchedResultsController()
        
        // Fetch fires!
        guard let url = NSURL(string: "http://opendata.minneapolismn.gov/datasets/b527484ac4eb490ea321b35fd5bcec43_0.geojson") else {
            // Bad URL, Create Logging operation
            return
        }
        
        // Good URL, Add the operation
        let fetchFireDetails = NetworkOperation(url: url)
        
        // Don't want to perform the CoreData operation
        // Until the Network Operation Completes
        let coreDataOperation = CoreDataOperation(model: Fire.self)
        coreDataOperation.addDependency(fetchFireDetails)
        
        // Need to pass data to the CoreDataOperations
        fetchFireDetails.coreDataOperations.append(coreDataOperation)
        
        // Add the operations to be executed
        OperationManager.sharedManager.addOperation(fetchFireDetails)
        OperationManager.sharedManager.addOperation(coreDataOperation)
        
    }
    
    func setupFetchedResultsController() {
        let request = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Fire", inManagedObjectContext: managedObjectContext)
        request.entity = entity
        
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
        
        refreshMap()

    }
    
    func refreshMap() {
        guard let fetchedResultsController = fetchedResultsController else { return }
        if let fires = fetchedResultsController.fetchedObjects as? [Fire] where fires.count > 0 {
            for fire in fires {
                mapView.removeAnnotation(fire) // just in case it's on there already
                mapView.addAnnotation(fire)
            }
   
            let zoomRect = fires.reduce(MKMapRectNull) { (mapRect: MKMapRect, fire: Fire) in
                let point = MKMapRect(origin: MKMapPointForCoordinate(fire.coordinate), size: MKMapSizeMake(0, 0))
                return MKMapRectUnion(mapRect, point)
            }
            
            self.mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(74, 10, 10, 10), animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let fireViewController = segue.destinationViewController as? FireViewController, fire = sender as? Fire where segue.identifier == "fireDetailsIdentifier" {
            fireViewController.fire = fire
        }
    }
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        refreshMap()
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Fire else { return nil }
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationViewIdentifier")
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
        return pin
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let fire = view.annotation as? Fire else { return }
        
        performSegueWithIdentifier("fireDetailsIdentifier", sender: fire)
        
    }
}
