//
//  9GAG.swift
//  9gag_mock
//
//  Created by MIRKO on 5/27/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit

class GAG : NSObject {
    
    // all networking convenience methods
    
    typealias CompletionHander = (result: AnyObject!, error: NSError?) -> Void
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: - All purpose task method for data
    
    func taskForResource(section: String, last: String, completionHandler: CompletionHander) -> NSURLSessionDataTask {
        

        let urlString = Constants.BASE_URL + "/" + section + "/" + last
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if let error = downloadError {
                print(error)
            } else {
                GAG.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    // Parsing the JSON
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: CompletionHander) {
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
        }
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    // MARK: - All purpose task method for images
    
    func taskForImageWithSize(filePath: String, completionHandler: (imageData: NSData?, error: NSError?) ->  Void) -> NSURLSessionTask {
        
        let url = NSURL(string: filePath)
        let request = NSURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if let _ = downloadError {
                print("error fetching image")
            } else {
                completionHandler(imageData: data, error: nil)
            }
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> GAG {
        
        struct Singleton {
            static var sharedInstance = GAG()
        }
        
        return Singleton.sharedInstance
    }
    
    static let sharedCache: NSCache = {
        let cache = NSCache()
        cache.name = "ImageCache"
        cache.countLimit = 100 // Max 100 images in memory.
        cache.totalCostLimit = 500*1024*1024 // Max 500MB used.
        return cache
    }()
    

    
}

extension NSURL {
    
    typealias ImageCacheCompletion = UIImage -> Void
    
    /// Retrieves a pre-cached image, or nil if it isn't cached.
    /// You should call this before calling fetchImage.
    var cachedImage: UIImage? {
        return GAG.sharedCache.objectForKey(
            absoluteString) as? UIImage
    }
    
    /// Fetches the image from the network.
    /// Stores it in the cache if successful.
    /// Only calls completion on successful image download.
    /// Completion is called on the main thread.
    func fetchImage(completion: ImageCacheCompletion) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(self) {
            data, response, error in
            if error == nil {
                if let  data = data,
                    image = UIImage(data: data) {
                    GAG.sharedCache.setObject(
                        image,
                        forKey: self.absoluteString,
                        cost: data.length)
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(image)
                    }
                }
            }
        }
        task.resume()
    }
    
}