//
//  OperationManager.swift
//  AllTheStacks
//
//  Created by Adam Ahrens on 8/25/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import Foundation

final class OperationManager {
    
    //MARK: Singleton
    static let sharedManager = OperationManager()
    
    //MARK: Private Var
    let backgroundQueue = NSOperationQueue()
    
    init() {
        
        /*
        * The default maximum number of operations is determined dynamically by the NSOperationQueue object based on current system conditions.
        * A system with a great number of cores can handle more operations.
        */
        backgroundQueue.name = "Appsbyahrens Operation Queue"
    }
    
    //MARK: Public
    func addOperation(operation: NSOperation) {
        backgroundQueue.addOperation(operation)
    }
    
}