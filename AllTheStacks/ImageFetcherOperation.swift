//
//  ImageFetcherOperation.swift
//  AllTheStacks
//
//  Created by Adam Ahrens on 8/26/15.
//  Copyright © 2015 Appsbyahrens. All rights reserved.
//

import UIKit

class ImageFetcherOperation: NSOperation {

    var dictionary: NSDictionary?
    
    override func main() {
        // Time to fetch the actual images
        guard let dictionary = dictionary else {
            return
        }
        
        if let photos = dictionary["photos"] as? NSDictionary {
            if let allPhotos = photos["photo"] as? NSArray {
                for photo in allPhotos {
                    if let photo = photo as? NSDictionary {
                        print(photo["id"])
                        
                        let farmId = photo["farm"] as? Int
                        let photoId = photo["id"] as? String
                        let serverId = photo["server"] as? String
                        let secret = photo["secret"] as? String
                        let urlString = "https://farm\(farmId!).staticflickr.com/\(serverId!)/\(photoId!)_\(secret!)_b.jpg"
                        
                        let url = NSURL(string: urlString)!
                        let urlSession = NSURLSession.sharedSession()
                        let dataTask = urlSession.downloadTaskWithURL(url) { url, response, error   in
                            if let imageURL = url {
                                let data = NSData(contentsOfURL: imageURL)
                                if let data = data {
                                    let image = UIImage(data: data)
                                    
                                    NSNotificationCenter.defaultCenter().postNotificationName("ImageDownloaded", object: image)
                                }
                            }
                        }
                        
                        dataTask.resume()
                    }
                }
            }
        }
    }
}
