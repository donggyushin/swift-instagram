//
//  UserProfileVC.swift
//  instagram
//
//  Created by 신동규 on 2020/03/01.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "ProfileHeader"

class UserProfileVC: UICollectionViewController {
    
    var posts = [Post]()
    
    var userFromSearch:User?
    
    var userEmail:String?
    var userProfileUrl:String?
    var username:String?
    var fullname:String?
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 200)
        
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        self.collectionView!.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        if (self.userFromSearch != nil){
            self.navigationItem.title = userFromSearch!.username
            fetchCurrentUsersPosts()
        }else {
            fetchUserInfo()
            fetchMyPosts()
        }
        
    }

  

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.posts.count
    }
    

    
   

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCollectionViewCell
    
        // Configure the cell
        cell.imageForCell = self.posts[indexPath.row].imageurl
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    func fetchUserInfo(){
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        db.collection("users").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    guard let email2 = data["email"] as? String,
                    let name = data["username"] as? String,
                    let full = data["name"] as? String,
                    let profileurl = data["profileImageUrl"] as? String
                    else {
                        return
                    }
                    
                    if email2 == email {
                        self.userEmail = email
                        self.username = name
                        self.userProfileUrl = profileurl
                        self.fullname = full
                        break;
                    }
                }
                
                self.navigationItem.title = self.username
                
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(integer: 0))
                }
                
            }
        }
        
    }
    
    func fetchCurrentUsersPosts(){
        
        let currentUserEmail:String = self.userFromSearch!.email!
        
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let imageurl = data["imageurl"] as? String,
                    let useremail = data["useremail"] as? String,
                    let text = data["text"] as? String,
                    let date = data["date"] as? String,
                    let id = data["id"] as? String
                    else { return }
                    
                    if currentUserEmail == useremail {
                        let post = Post(id:id, imageurl: imageurl, text: text, useremail: useremail, date:date)
                        self.posts.append(post)
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(integer: 0))
                }
                
            }
        }
        
    }
    
    func fetchMyPosts(){
        
        guard let myemail:String = Auth.auth().currentUser?.email else { return }
        
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let imageurl = data["imageurl"] as? String,
                    let useremail = data["useremail"] as? String,
                    let text = data["text"] as? String,
                    let date = data["date"] as? String,
                    let id = data["id"] as? String
                    else { return }
                    
                    if myemail == useremail {
                        let post = Post(id:id, imageurl: imageurl, text: text, useremail: useremail, date:date)
                        self.posts.append(post)
                    }
                    
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
        }
    }

}


extension UserProfileVC {

        override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
            
            if let userFromSearch = self.userFromSearch {
                header.fullname = userFromSearch.fullname!
                header.profileImageUrl = userFromSearch.profileImageUrl!
                header.email = userFromSearch.email!
                
                header.delegate = self
                
                return header
            }
            
            if let fullname = self.fullname {
                header.fullname = fullname
            }
            
            if let profileimageurl = self.userProfileUrl {
                header.profileImageUrl = profileimageurl
            }
            
            if let userEmail = self.userEmail {
                header.email = userEmail
            }
            
            header.delegate = self
            
            
            return header
        }
}

extension UserProfileVC: ProfileHeaderProtocol {
    func followingsTapped(email:String) {
        let followingVC = FollowingVC()
        followingVC.targetEmail = email
        navigationController?.pushViewController(followingVC, animated: true)
    }
    
    func followersTapped(email:String) {
        let followingVC = FollowingVC()
        followingVC.following = false
        followingVC.targetEmail = email
        navigationController?.pushViewController(followingVC, animated: true)
    }
    
    
    
    
}

extension UserProfileVC: UICollectionViewDelegateFlowLayout {
    // MARK: 컬렉션뷰 셀 사이즈
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 2.0) / 3
        return CGSize(width: width, height: width)
    }
    
    //Use for interspacing
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

        
}

