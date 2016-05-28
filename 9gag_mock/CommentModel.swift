//
//  CommentModel.swift
//  9gag_mock
//
//  Created by MIRKO on 5/27/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation

class Comment {
    var id: String
    var text: String
    var authorId: String
    var postId: String
    
    init(id: String, text: String, authorId: String, postId: String) {
        self.id = id
        self.text = text
        self.authorId = authorId
        self.postId = postId
    }
}