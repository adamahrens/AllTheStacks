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
        let operation = NetworkOperation(url: url)
        OperationManager.sharedManager.addOperation(operation)
    }
}
