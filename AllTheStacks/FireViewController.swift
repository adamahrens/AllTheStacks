//
//  FireViewController.swift
//  AllTheStacks
//
//  Created by Steven Vlaminck on 8/26/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import UIKit

class FireViewController: UIViewController {
    
    @IBAction func buttonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var fire: Fire? {
        didSet {
            print(fire)
            // update view
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
}
