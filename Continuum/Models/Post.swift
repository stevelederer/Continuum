//
//  Post.swift
//  Continuum
//
//  Created by Steve Lederer on 1/1/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit
import CloudKit

class Post {
    
    // MARK: - Keys
    enum PostKeys {
        static let recordType = "Post"
        static let caption = "caption"
        static let timestamp = "timestamp"
        static let photoData = "photoData"
    }
    
    // MARK: - Properties
    
    var recordID = CKRecord.ID(recordName: UUID().uuidString)
    var caption: String
    var photoData: Data?
    var timestamp: Date
    var comments: [Comment] = []
    var tempURL: URL?
    
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
    
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            self.tempURL = fileURL
            do {
                try photoData?.write(to: fileURL)
            } catch let error {
                print("❌ Error writing to temp url \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    deinit {
        if let url = tempURL {
            do {
                try FileManager.default.removeItem(at: url)
            } catch let error {
                print("error deleting temp file, or may cause memory leak: \(error)")
            }
        }
    }
    
    // MARK: - Fetching
    
    init?(record: CKRecord) {
        guard let caption = record[PostKeys.caption] as? String,
            let timestamp = record[PostKeys.timestamp] as? Date,
            let imageAsset = record[PostKeys.photoData] as? CKAsset else { return nil }
        guard let photoData = try? Data(contentsOf: imageAsset.fileURL) else { return nil }
        
        self.caption = caption
        self.timestamp = timestamp
        self.photoData = photoData
        self.comments = []
        self.recordID = record.recordID
    }
}

extension Post: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if caption.lowercased().contains(searchTerm.lowercased()) {
            return true
        }
        
        for comment in self.comments {
            if comment.matches(searchTerm: searchTerm) {
                return true
            }
        }
        return false
    }
}

extension CKRecord {
    convenience init(_ post: Post) {
        self.init(recordType: Post.PostKeys.recordType, recordID: post.recordID)
        
        self.setValue(post.caption, forKey: Post.PostKeys.caption)
        self.setValue(post.timestamp, forKey: Post.PostKeys.timestamp)
        self.setValue(post.imageAsset, forKey: Post.PostKeys.photoData)
    }
}
