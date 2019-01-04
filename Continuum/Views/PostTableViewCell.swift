//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by Steve Lederer on 1/1/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var postCommentCountLabel: UILabel!
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let post = post else { return }
        
        PostController.shared.fetchCommentsFor(post: post) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.postCommentCountLabel.text = "\(post.comments.count) Comments"
                }
            }
        }
        postImageView.image = post.photo
        postCaptionLabel.text = post.caption
    }
}
