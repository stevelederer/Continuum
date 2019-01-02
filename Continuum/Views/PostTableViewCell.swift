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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViews() {
        guard let post = post else { return }
        postImageView.image = post.photo
        postCaptionLabel.text = post.caption
        postCommentCountLabel.text = "\(post.comments.count) Comments"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
