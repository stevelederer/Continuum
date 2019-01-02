//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Steve Lederer on 1/1/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        selectImageButton.setTitle("Select Image", for: .normal)
        postImageView.image = nil
    }
    
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        self.photo = UIImage(named: "kelev")
        postImageView.image = self.photo
        selectImageButton.setTitle("", for: .normal)
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        guard let photo = photo, let caption = captionTextField.text, !caption.isEmpty else { return }
        PostController.shared.createPostWith(photo: photo, captionText: caption) { (post) in

        }
        self.tabBarController?.selectedIndex = 0
    }
}
