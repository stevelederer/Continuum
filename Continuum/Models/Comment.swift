//
//  Comment.swift
//  Continuum
//
//  Created by Steve Lederer on 1/1/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import Foundation

class Comment {
    var text: String
    var timestamp: Date
    weak var post: Post?
    
    init(text: String, timestamp: Date = Date(), post: Post) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
    }
}
