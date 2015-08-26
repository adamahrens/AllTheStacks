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

    @IBOutlet weak var mapView: MKMapView!
    
    var fire: Fire? {
        didSet {
            if let fire = fire {
                setupFetchedResultsController()
                title = fire.fireDescription
                
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
        
        guard let fire = fire else {
            return
        }
        
        descriptionLabel.text = fire.fireDescription

        mapView.delegate = self
        mapView.scrollEnabled = false
        mapView.zoomEnabled = false
        mapView.pitchEnabled = false
        mapView.rotateEnabled = false

        mapView.addAnnotation(fire)
        mapView.setVisibleMapRect(MKMapRect(origin: MKMapPointForCoordinate(fire.coordinate), size: MKMapSizeMake(0, 3000)), animated: false)
        mapView.setCenterCoordinate(fire.coordinate, animated: false)
        descriptionLabel.text = fire.fireDescription
        
        // Fetch some addresses
        let url = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=cae917bfb457529b14265845da90e096&lat=\(fire.latitude!.doubleValue)&lon=\(fire.longitude!.doubleValue)&format=json&nojsoncallback=1")
        let networkOperation = NetworkOperation(url: url!)
        
        let imageFetcherOperation = ImageFetcherOperation()
        imageFetcherOperation.addDependency(networkOperation)
        
        // Let it know
        networkOperation.imageFetchOperations.append(imageFetcherOperation)
        
        // We dont want the image to start until we have the data
        OperationManager.sharedManager.addOperation(imageFetcherOperation)
        OperationManager.sharedManager.addOperation(networkOperation)
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

extension FireViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Fire else { return nil }
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationViewIdentifier")
        pin.canShowCallout = false
        return pin
    }
    
}


