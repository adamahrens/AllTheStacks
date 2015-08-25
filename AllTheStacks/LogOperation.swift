//
//  LogOperation.swift
//  AllTheStacks
//
//  Created by Adam Ahrens on 8/25/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import UIKit

final class LogOperation: NSOperation {
    private let message: String
    
    init(logMessage: String) {
        message = logMessage
    }
    
    override func main() {
        if cancelled {
            return
        }
        
        // Otherwise not cancelled
        print("*** \(message) ***")
    }
}
