//
//  FeedVC.swift
//  instagram
//
//  Created by 신동규 on 2020/03/01.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class FeedVC: UICollectionViewController {
    
    let db = Firestore.firestore()
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        navigationItem.title = "Feed"
        configureLogoutButton()
        fetchingPosts()
    }

   

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
    
        // Configure the cell
    
        return cell
    }

    func configureLogoutButton(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(logoutUser))
    }
    
    @objc func logoutUser(){
        
        
        let alert = UIAlertController(title: "Notification", message: "Are you sure to logout?", preferredStyle: .actionSheet)
        let success = UIAlertAction(title: "Yes", style: .default) { (_) in
                do{
                    try Auth.auth().signOut()
                    let loginVC = UINavigationController(rootViewController: LoginVC())
                    loginVC.modalPresentationStyle = .fullScreen
                    self.present(loginVC, animated: true, completion: nil)
                }catch let signOutError as NSError{
                    print("Error signing out", signOutError)
                }
        }
        
        let cancel = UIAlertAction(title: "Nope", style: .cancel, handler: nil)
        alert.addAction(success)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func fetchingPosts(){
        let myEmail = Auth.auth().currentUser!.email!
        var emails = [String]()
        emails.append(myEmail)
        
        // 내가 팔로우하는 모든 email들을 찾아낸다.
        db.collection("following").getDocuments { (querySnapshot, error) in
            guard error == nil else { return }
            for document in querySnapshot!.documents {
                
                let data = document.data()
                guard let from = data["from"] as? String,
                let to = data["to"] as? String
                else { return }
                if from == myEmail {
                    emails.append(to)
                }
            }
            
            for email in emails {
                // 해당 email들이 가지고 있는 포스트들을 모두 찾는다.
                self.db.collection("posts").getDocuments { (querySnapshot, error) in
                    guard error == nil else { return }
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        guard let date = data["date"] as? String,
                        let imageurl = data["imageurl"] as? String,
                        let text = data["text"] as? String,
                        let useremail = data["useremail"] as? String,
                        let id = data["id"] as? String
                        else { return }
                        
                        if email == useremail {
                            let post = Post(id:id, imageurl: imageurl, text: text, useremail: useremail, date: date)
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
  

}


extension FeedVC:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        
        return CGSize(width: width, height: width + 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
