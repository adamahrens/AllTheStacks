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
    
    // CoreData Operations
    var coreDataOperations = [CoreDataOperation]()
    var imageFetchOperations = [ImageFetcherOperation]()
    
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

        do {
            let request = NSURLRequest(URL: url)
            var response: NSURLResponse?
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            
            guard let httpResponse = response as? NSHTTPURLResponse else {
                return
            }
            
            // What's the Response
            let localizedResponse = NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode)
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
                
                for dependency in coreDataOperations {
                    dependency.dictionary = serialized
                }
                
                for imageDependency in imageFetchOperations {
                    imageDependency.dictionary = serialized
                }
            } catch {
                // Handle JSON parsing error
            }
        } catch {
            // Handle NSURLConnection request error
        }
    }
}
