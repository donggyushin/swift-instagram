//
//  FollowingVC.swift
//  instagram
//
//  Created by 신동규 on 2020/03/02.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

private let cellIdenrifier = "laskdj"

class FollowingVC: UITableViewController {
    let db = Firestore.firestore()
    var users = [User]()
    var targetEmail = ""
    var following = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(following){
            navigationItem.title = "Following"
            fetchFollowings()
        }else {
            navigationItem.title = "Followers"
            fetchingFollowers()
        }
        

        
        tableView.separatorStyle = .none
        tableView.register(FollowingCell.self, forCellReuseIdentifier: cellIdenrifier)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        userProfileVC.userFromSearch = user
        
        navigationController?.pushViewController(userProfileVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdenrifier, for: indexPath) as! FollowingCell
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
    
    func fetchingFollowers(){
        let targetEmail = self.targetEmail
        var emails = [String]()
        
        db.collection("followers").getDocuments { (qs, er) in
            if let er = er {
                print("Error getting documents: \(er)")
            }else {
                for document in qs!.documents {
                    let data = document.data()
                    if let from = data["from"] as? String, let to = data["to"] as? String {
                        if to == targetEmail {
                            emails.append(from)
                        }
                    }
                }
                
                for email in emails {
                    self.db.collection("users").whereField("email", isEqualTo: email).getDocuments { (qs, er) in
                        if let er = er {
                            print("Error getting documents: \(er)")
                        }else {
                            for document in qs!.documents {
                                let data = document.data()
                                
                                
                                if let username = data["username"] as? String, let email = data["email"] as? String, let fullname = data["name"] as? String,
                                    let profileurl = data["profileImageUrl"] as? String {
                                    let user = User(username: username, email: email, fullname: fullname, profileImageUrl: profileurl)
                                    
                                    self.users.append(user)
                                }
                            }
                            
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }

   
    
    func fetchFollowings(){
        
        let targetEmail:String = self.targetEmail
        var userEmails = [String]()
        
        db.collection("following").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let from = data["from"] as? String, let to = data["to"] as? String {
                        if (from == targetEmail) {
                            userEmails.append(to)
                        }
                    }
                }
                
                
                for email in userEmails {
                    self.db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        }else {
                            for document in querySnapshot!.documents {
                                let data = document.data()
                                
                                
                                
                                if let username = data["username"] as? String, let email = data["email"] as? String, let fullname = data["name"] as? String,
                                    let profileurl = data["profileImageUrl"] as? String {
                                    let user = User(username: username, email: email, fullname: fullname, profileImageUrl: profileurl)
                                    
                                    self.users.append(user)
                                }
                                
                            }
                            
                            self.tableView.reloadData()
                        }
                    }
                }
                
                
            }
        }
    }
    
    
    
    

}
