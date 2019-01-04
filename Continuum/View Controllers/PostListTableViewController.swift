//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by Steve Lederer on 1/1/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var timelineSearchBar: UISearchBar!
    
    var resultsArray: [SearchableRecord]?
    
    var isearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timelineSearchBar.delegate = self
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postsChanged(_:)), name: PostController.PostsChangedNotification, object: nil)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 450
        
        fetchAllPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func postsChanged(_ notification: Notification) {
        tableView.reloadData()
        print("Posts Changed")
    }
    
    func fetchAllPosts() {
        PostController.shared.fetchAllPostsFromCloudKit { (posts) in
            if posts == nil {
                self.showAlertMessage(title: "Error Fetching Posts", message: "There was an error, so you better figure that out.")

            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isearching ? resultsArray?.count ?? 0 : PostController.shared.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell
        let dataSource = isearching ? resultsArray : PostController.shared.posts
        let post = dataSource?[indexPath.row]
        cell?.post = post as? Post
        return cell ?? UITableViewCell()
    }
    
    // MARK: - Search Bar Delegate Functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            resultsArray = PostController.shared.posts
        } else {
            let posts = PostController.shared.posts
            let filteredPosts = posts.filter{ $0.matches(searchTerm: searchText) }.compactMap{ $0 as SearchableRecord }
            resultsArray = filteredPosts
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsArray = PostController.shared.posts
        tableView.reloadData()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isearching = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isearching = false
        searchBar.resignFirstResponder()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostDetailView" {
            let destinationViewController = segue.destination as? PostDetailTableViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let post = PostController.shared.posts[indexPath.row]
            destinationViewController?.post = post
        }
    }
    

}
