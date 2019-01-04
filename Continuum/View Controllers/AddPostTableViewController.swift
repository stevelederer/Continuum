//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Steve Lederer on 1/1/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
    @IBOutlet weak var captionTextField: UITextField!
    
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        captionTextField.text = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoSelectVC" {
            guard let destinationVC = segue.destination as? PhotoSelectViewController else { return }
            destinationVC.delegate = self
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        guard let photo = photo, let caption = captionTextField.text, !caption.isEmpty else { return }
        PostController.shared.createPostWith(photo: photo, captionText: caption) { (_) in
            
        }
        self.tabBarController?.selectedIndex = 0
    }
}

extension AddPostTableViewController: PhotoSelectViewControllerDelegate {
    func photoSelected(photo: UIImage) {
        self.photo = photo
    }
    
    
}
