//
//  SearchVC.swift
//  instagram
//
//  Created by 신동규 on 2020/03/01.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

private let searchCellIdenrifier = "asdlkajsaskdj"

class SearchVC: UITableViewController {

    let db = Firestore.firestore()
    
    var users:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        navigationItem.title = "Explore"
        
        tableView.register(SearchCell.self, forCellReuseIdentifier: searchCellIdenrifier)
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        userProfileVC.userFromSearch = user
        
        navigationController?.pushViewController(userProfileVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellIdenrifier, for: indexPath) as! SearchCell
        let user = users[indexPath.row]
        
        if let username = user.username, let fullname = user.fullname, let profileimageurl = user.profileImageUrl {
            cell.username = username
            cell.fullname = fullname
            cell.profileimageurl = profileimageurl
        }
        
        return cell
    }
    
    func fetchUsers(){
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let email = data["email"] as? String,
                    let username = data["username"] as? String,
                    let name = data["name"] as? String,
                    let profileImageUrl = data["profileImageUrl"] as? String
                    else {
                        return
                    }
                    
                    let user = User(username: username, email: email, fullname: name, profileImageUrl: profileImageUrl)
                    
                    self.users.append(user)
                    
                }
                self.tableView.reloadData()
            }
        }
    }

  

}
