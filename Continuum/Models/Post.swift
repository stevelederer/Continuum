//
//  Post.swift
//  Continuum
//
//  Created by Steve Lederer on 1/1/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class Post {
    var caption: String
    var photoData: Data?
    var timestamp: Date
    var comments: [Comment] = []
    
    init(photo: UIImage, timestamp: Date = Date(), caption: String, comments: [Comment] = []) {
        self.timestamp = timestamp
        self.caption = caption
        self.comments = comments
        self.photo = photo
    }
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.6)
        }
    }
    
}
