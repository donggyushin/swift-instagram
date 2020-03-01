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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        configureLogoutButton()
    }

   

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
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
  

}
