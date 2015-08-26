//
//  NetworkOperation.swift
//  AllTheStacks
//
//  Created by Adam Ahrens on 8/25/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import Foundation

final class NetworkOperation: NSOperation {
    
    // The URL to fetch data
    private let url: NSURL
    
    init(url: NSURL) {
        self.url = url
    }
    
    /*
    * All subclasses of NSOperation must implement main
    * This is the "single" task you want to accomplish
    */
    override func main() {
        // Operation may have been put in a queue and not executed yet
        // Check if it's still valid
        if self.cancelled {
            return
        }

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) { data, response, error in
            guard let data = data, let response = response as? NSHTTPURLResponse else {
                return
            }
            
            // What's the Response
            let localizedResponse = NSHTTPURLResponse.localizedStringForStatusCode(response.statusCode)
            let updatedMessage = "Fetched from \(self.url.absoluteString) with result of \(localizedResponse)"
            let logOperation = LogOperation(logMessage: updatedMessage)
            
            
            do {
                // Let's serialize the data like a boss
                let serialized = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
                let serializedOperation = LogOperation(logMessage: "\(serialized)")
                
                // More dependencies
                logOperation.addDependency(serializedOperation)
                OperationManager.sharedManager.addOperation(serializedOperation)
                OperationManager.sharedManager.addOperation(logOperation)
                
                // See if we have any CoreData Dependencies
                // That we need to pass the data to
                for dependency in self.dependencies {
                    if let coreDataDependency = dependency as? CoreDataOperation {
                        coreDataDependency.dictionary = serialized
                    }
                }
            } catch {
                
            }
        }
        
        // Start the task
        task.resume()
    }
}
