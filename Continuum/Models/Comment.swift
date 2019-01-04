//
//  Comment.swift
//  Continuum
//
//  Created by Steve Lederer on 1/1/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import Foundation
import CloudKit

class Comment {
    
    // MARK: - Keys
    enum CommentKeys {
        static let recordType = "Comment"
        static let text = "text"
        static let timestamp = "timestamp"
        static let postReferenceKey = "postReference"
    }
    
    var recordID = CKRecord.ID(recordName: UUID().uuidString)
    var text: String
    var timestamp: Date
    weak var post: Post?
    
    init(text: String, timestamp: Date = Date(), post: Post?) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
    }
    
    convenience required init?(record: CKRecord) {
        guard let text = record[CommentKeys.text] as? String,
            let timestamp = record.creationDate else { return nil }
        self.init(text: text, timestamp: timestamp, post: nil)
        self.recordID = record.recordID
    }
}

extension Comment: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        return self.text.lowercased().contains(searchTerm.lowercased())
    }
}

extension CKRecord {
    convenience init(_ comment: Comment) {
        guard let post = comment.post else {
            fatalError("Comment does not have a Post relatioship")
        }
        self.init(recordType: Comment.CommentKeys.recordType, recordID: comment.recordID)
        
        self.setValue(comment.text, forKey: Comment.CommentKeys.text)
        self.setValue(comment.timestamp, forKey: Comment.CommentKeys.timestamp)
        self.setValue(CKRecord.Reference(recordID: post.recordID, action: .deleteSelf), forKey: Comment.CommentKeys.postReferenceKey)
    }
}
