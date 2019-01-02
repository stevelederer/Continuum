//
//  PostController.swift
//  Continuum
//
//  Created by Steve Lederer on 1/1/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class PostController {
    
    static let shared = PostController()
    
    var posts: [Post] = []
    
    func addComment(_ text: String, to post: Post, completion: @escaping (Comment) -> Void) {
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
        completion(comment)
    }
    
    func createPostWith(photo: UIImage, captionText: String, completion: @escaping (Post) -> Void) {
        let post = Post(photo: photo, caption: captionText)
        self.posts.append(post)
        completion(post)
    }
    
}
