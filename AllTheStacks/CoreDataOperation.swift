//
//  CoreDataOperation.swift
//  AllTheStacks
//
//  Created by Adam Ahrens on 8/25/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import UIKit

final class CoreDataOperation: NSOperation {
    private var dictionary: NSDictionary?
    private var array: NSArray?
    
    convenience init(dictionary: NSDictionary) {
       self.init()
        self.dictionary = dictionary
    }
    
    convenience init(array: NSArray) {
        self.init()
        self.array = array
    }
    
    override func main() {
        
    }
}
