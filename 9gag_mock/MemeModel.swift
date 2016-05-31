//
//  MemeModel.swift
//  9gag_mock
//
//  Created by MIRKO on 5/27/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    
    struct Keys {
        static let id = "id"
        static let caption = "caption"
        static let images = "images"
        static let normalImg = "normal"
        static let votes = "votes"
        static let comments = "comments"
    }
    
    
    var id: String
    var caption: String
    var photoURL: String
    var authorId: String
    var comments: Int
    var votes: Int
    
    init(id: String, caption: String, photoURL: String, authorId: String, comments: Int, votes: Int) {
        // manual init method
        self.id = id
        self.caption = caption
        self.photoURL = photoURL
        self.authorId = authorId
        self.comments = comments
        self.votes = votes
    }
    
    init(data: [String : AnyObject]) {
        // init from dictionary converted from JSON data
        self.id = data[Keys.id] as! String
        self.caption = data[Keys.caption] as! String
        let images = data[Keys.images] as! [String:AnyObject]
        self.photoURL = images[Keys.normalImg] as! String
        let votes = data[Keys.votes] as! [String:AnyObject]
        self.votes = votes["count"] as! Int
        let comments = data[Keys.comments] as! [String:AnyObject]
        self.comments = comments["count"] as! Int
        self.authorId = "xiangormirko test"
        
    }
    

}