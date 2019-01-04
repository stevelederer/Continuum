//
//  PostController.swift
//  Continuum
//
//  Created by Steve Lederer on 1/1/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit
import CloudKit

extension PostController {
    static let PostsChangedNotification = Notification.Name("PostsChangedNotification")
}

class PostController {
    
    static let shared = PostController()
    
    var posts: [Post] = [] {
        didSet {
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: PostController.PostsChangedNotification, object: self)
            }
        }
    }
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - CloudKit Availability
    
    func checkAccountStatus(completion: @escaping (_ isLoggedIn: Bool) -> ()) {
        CKContainer.default().accountStatus { (status, error) in
            if let error = error {
                print("❌ There was an error checking account status in \(#function) ; \(error.localizedDescription) ❌")
                completion(false)
                return
            } else {
                let errorText = "Sign in to iCloud in Settings"
                switch status {
                case .available:
                    completion(true)
                case .couldNotDetermine:
                    self.presentErrorAlert(errorTitle: errorText, errorMessage: "Error with iCloud account status")
                    completion(false)
                case .noAccount:
                    let noAccount = "No account found"
                    self.presentErrorAlert(errorTitle: errorText, errorMessage: noAccount)
                    completion(false)
                case .restricted:
                    self.presentErrorAlert(errorTitle: errorText, errorMessage: "Restricted iCloud account")
                    completion(false)
                    
                }
            }
        }
    }
    
    func presentErrorAlert(errorTitle: String, errorMessage: String) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.showAlertMessage(title: errorTitle, message: errorMessage)
            }
        }
    }
    
    // MARK: - Create
    
    func createPostWith(photo: UIImage, captionText: String, completion: @escaping (Post?) -> Void) {
        let post = Post(photo: photo, caption: captionText)
        self.posts.append(post)
        publicDB.save(CKRecord(post)) { (_, error) in
            if let error = error {
                print("❌ Error saving post record in  \(#function) ; \(error.localizedDescription) ; \(error)❌")
                completion(nil)
                return
            }
            completion(post)
        }
    }
    
    func addComment(_ text: String, to post: Post, completion: @escaping (Comment?) -> Void) {
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
        publicDB.save(CKRecord(comment)) { (_, error) in
            if let error = error {
                print("❌ There was an error saving comment in \(#function) ; \(error.localizedDescription) ; \(error) ❌")
                completion(nil)
                return
            }
            completion(comment)
        }
    }
    
    
    // MARK: - Fetch
    
    func fetchAllPostsFromCloudKit(completion: @escaping ([Post]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Post.PostKeys.recordType, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("❌ There was an error fetching posts from CloudKit in \(#function) ; \(error.localizedDescription) ❌")
                completion(nil)
                return
            }
            guard let records = records else { completion(nil) ; return }
            let posts = records.compactMap{ Post(record: $0) }
            self.posts = posts
            completion(posts)
        }
    }
    
    func fetchCommentsFor(post: Post, completion: @escaping (_ success: Bool) -> ()) {
        let postReference = post.recordID
        let predicate = NSPredicate(format: "postReference == %@", postReference)
        let commentRecordIDs = post.comments.compactMap{ ($0.recordID) }
        let secondPredicate = NSPredicate(format: "!(recordID IN %@)", commentRecordIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, secondPredicate])
        let query = CKQuery(recordType: Comment.CommentKeys.recordType, predicate: compoundPredicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("❌ There was an error fetching comments for post \(post) in \(#function) ; \(error.localizedDescription) ❌")
                completion(false)
                return
            }
            guard let records = records else { completion(false) ; return }
            
            let fetchedComments = records.compactMap{ Comment(record: $0) }
            post.comments.append(contentsOf: fetchedComments)
            completion(true)
        }
    }
    
}
