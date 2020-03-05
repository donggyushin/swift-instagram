//
//  NotificationCell.swift
//  instagram
//
//  Created by 신동규 on 2020/03/05.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

class NotificationCell: UITableViewCell {
    
    let db = Firestore.firestore()
    
    var like:Like? {
        didSet {
            fetchFeedLiked(like: self.like!)
            fetchUserLiked(like: self.like!)
        }
    }
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var captionLabel:UILabel = {
        let label = UILabel()
        label.text = "liked your post."
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var feedImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView(){
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(captionLabel)
        addSubview(feedImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        feedImageView.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.layer.cornerRadius = 20
        
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        captionLabel.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 8).isActive = true
        captionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        feedImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        feedImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        feedImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        feedImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func fetchFeedLiked(like:Like){
        db.collection("posts").document(like.feedId).getDocument { (documentSnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                let data = documentSnapshot!.data()!
                guard let imageurl = data["imageurl"] as? String else { return }
                
                DispatchQueue.main.async {
                    do {
                        let url = URL(string: imageurl)
                        guard url != nil else { return }
                        let data = try Data(contentsOf: url!)
                        self.feedImageView.image = UIImage(data: data)
                        
                    }catch {
                        
                    }
                }
            }
        }
    }
    
    func fetchUserLiked(like:Like){
        db.collection("users").getDocuments { (querySnapshor, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                for document in querySnapshor!.documents {
                    let data = document.data()
                    guard let email = data["email"] as? String,
                    let profileImageUrl = data["profileImageUrl"] as? String,
                        let username = data["username"] as? String else { return }
                    
                    if like.userEmail == email {
                        
                        DispatchQueue.main.async {
                            do{
                                let url = URL(string: profileImageUrl)
                                guard url != nil else { return }
                                let data = try Data(contentsOf: url!)
                                self.profileImageView.image = UIImage(data: data)
                                
                                self.usernameLabel.text = username
                                
                                
                            }catch {
                                
                            }
                        }
                        
                        return
                        
                    }
                    
                }
            }
        }
    }
    
}
