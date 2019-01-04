//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Steve Lederer on 1/1/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var post: Post? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Setup
    
    func updateViews() {
        guard let post = post else { return }
        if let photo = post.photo {
            photoImageView?.image = photo
        }
        tableView.reloadData()
    }
    
    // MARK: - Alert Controllers
    
    func presentNewCommentAlert() {
        
        let newCommentAlertController = UIAlertController(title: "New Comment", message: nil, preferredStyle: .alert)
        
        newCommentAlertController.addTextField { (commentTextField) in
            commentTextField.placeholder = "Add your comment here..."
            commentTextField.autocapitalizationType = .sentences
            commentTextField.autocorrectionType = .default
        }
        
        let addNewCommentAction = UIAlertAction(title: "Okay", style: .default) { (_) in
            guard var commentText = newCommentAlertController.textFields?.first?.text, let post = self.post else { return }
            guard !commentText.isEmpty else { self.presentMissingCommentAlert() ; return }
            
            PostController.shared.addComment(commentText, to: post, completion: { (comment) in
                DispatchQueue.main.async {
                    guard let comment = comment else { return }
                    commentText = comment.text
                    self.tableView.reloadData()
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        newCommentAlertController.addAction(addNewCommentAction)
        newCommentAlertController.addAction(cancelAction)
        
        self.present(newCommentAlertController, animated: true)
    }
    
    func presentMissingCommentAlert() {
        let missingCommentAlertController = UIAlertController(title: "Oops!", message: "You forgot to enter a comment. Please try again.", preferredStyle: .alert)
        missingCommentAlertController.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (_) in
            self.presentNewCommentAlert()
        }))
        self.present(missingCommentAlertController, animated: true)
    }
    
    // MARK: - Button Actions
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        presentNewCommentAlert()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let post = post, let photo = post.photo else { return }
        let activityViewController = UIActivityViewController(activityItems: [photo, post.caption], applicationActivities: nil)
        self.present(activityViewController, animated: true)
    }
    
    @IBAction func followPostButtonTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post?.comments.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        guard let comments = post?.comments else { return UITableViewCell() }
        let comment = comments[indexPath.row]
        cell.textLabel?.text = comment.text
        cell.detailTextLabel?.text = "\(dateFormatter.string(from: comment.timestamp))"
        return cell
    }
}
