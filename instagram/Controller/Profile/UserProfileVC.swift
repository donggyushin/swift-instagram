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
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        if (self.userFromSearch != nil){
            self.navigationItem.title = userFromSearch!.username
        }else {
            fetchUserInfo()
        }
        
    }

  

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    

    
   

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    func fetchUserInfo(){
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        
        
        db.collection("users").whereField("email", isEqualTo: email)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let data = document.data()
                        
                        guard let email = data["email"] as? String,
                        let name = data["username"] as? String,
                        let full = data["name"] as? String,
                        let profileurl = data["profileImageUrl"] as? String
                        else {
                            return
                        }
                        
                        
                        self.userEmail = email
                        self.username = name
                        self.userProfileUrl = profileurl
                        self.fullname = full
                        
                        
                        self.navigationItem.title = name
                        
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
