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
    
    var resultsAray: [SearchableRecord] = []
    var isearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timelineSearchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resultsAray = PostController.shared.posts
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isearching ? resultsAray.count : PostController.shared.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell
        let dataSource = isearching ? resultsAray : PostController.shared.posts
        let post = dataSource[indexPath.row]
        cell?.post = post as? Post
        return cell ?? UITableViewCell()
    }
    
    // MARK: - Search Bar Delegate Functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let posts = PostController.shared.posts
        let filteredPosts = posts.filter{ $0.matches(searchTerm: searchText) }.compactMap{ $0 as SearchableRecord }
        resultsAray = filteredPosts
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsAray = PostController.shared.posts
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
