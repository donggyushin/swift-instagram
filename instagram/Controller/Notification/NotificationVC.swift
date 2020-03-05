//
//  NotificationVC.swift
//  instagram
//
//  Created by 신동규 on 2020/03/01.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

private let NotificationCellIdentifier = "asdkljasdlkj"

class NotificationVC: UITableViewController {
    
    let db = Firestore.firestore()
    
    var likes = [Like]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Notifications"
        
        fetchLikes()
        
        tableView.separatorStyle = .none

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCellIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return likes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCellIdentifier, for: indexPath) as! NotificationCell
        
        let like = self.likes[indexPath.row]
        
        cell.like = like
        
        return cell
    }
    
    func fetchLikes(){
        guard let myEmail = Auth.auth().currentUser?.email else { return }
        db.collection("likes").getDocuments { (querySnapshor, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                for document in querySnapshor!.documents {
                    let data = document.data()
                    guard let feedId = data["feedId"] as? String,
                    let feedUserEmail = data["feedUserEmail"] as? String,
                    let likeId = data["id"] as? String,
                        let userEmail = data["userEmail"] as? String else { return }
                    
                    if myEmail == feedUserEmail {
                        let like = Like(feedId: feedId, feedUserEmail: feedUserEmail, id: likeId, userEmail: userEmail)
                        self.likes.append(like)
                    }
                    
                    
                }
                self.tableView.reloadData()
            }
        }
    }

   

}
