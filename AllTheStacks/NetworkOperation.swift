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

        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard let data = data, let response = response as? NSHTTPURLResponse else {
                return
            }
            
            // What's the Response
            let localizedResponse = NSHTTPURLResponse.localizedStringForStatusCode(response.statusCode)
            let updatedMessage = "Fetched from \(self.url.absoluteString) with result of \(localizedResponse)"
            let logOperation = LogOperation(logMessage: updatedMessage)
            OperationManager.sharedManager.addOperation(logOperation)
            
            do {
                // Let's serialize the data like a boss
                let serialized = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
                let serializedOperation = LogOperation(logMessage: "\(serialized)")
                OperationManager.sharedManager.addOperation(serializedOperation)
                
                // Let's save it to CoreData
            } catch {
                
            }
        }
        
        // Start the task
        task.resume()
    }
}
