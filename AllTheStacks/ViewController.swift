//
//  ViewController.swift
//  AllTheStacks
//
//  Created by Adam Ahrens on 8/25/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch fires!
        guard let url = NSURL(string: "http://opendata.minneapolismn.gov/datasets/b527484ac4eb490ea321b35fd5bcec43_0.geojson") else {
            // Bad URL, Create Logging operation
            return
        }
        
        // Good URL, Add the operation
        let fetchFireDetails = NetworkOperation(url: url)
        OperationManager.sharedManager.addOperation(fetchFireDetails)
        
        // Don't want to perform the CoreData operation
        // Until the Network Operation Completes
        let coreDataOperation = CoreDataOperation(model: Fire.self)
        coreDataOperation.addDependency(fetchFireDetails)
        OperationManager.sharedManager.addOperation(coreDataOperation)
    }
}
