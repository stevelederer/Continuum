//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by Steve Lederer on 1/1/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refresh()
    }
    
    func refresh() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.shared.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell
        let post = PostController.shared.posts[indexPath.row]
        cell?.post = post
        return cell ?? UITableViewCell()
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
