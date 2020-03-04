//
//  FeedCell.swift
//  instagram
//
//  Created by 신동규 on 2020/03/03.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

protocol FeedCellProtocol {
    func commentIconTapped(feedId:String)
}

class FeedCell: UICollectionViewCell {
    
    var checked = false
    
    var likeId:String?
    
    var delegate:FeedCellProtocol?
    
    var feedId:String? {
        didSet {
            checkILikeThisFeed()
        }
    }
    
    let db = Firestore.firestore()
    
    var userEmail:String? {
        didSet {
            fetchUser()
        }
    }
    
    var feedImageUrl:String? {
        didSet {
            DispatchQueue.main.async {
                do {
                    let url = URL(string: self.feedImageUrl!)
                    guard url != nil else { return }
                    let data = try Data(contentsOf: url!)
                    self.feedImage.image = UIImage(data: data)
                }catch {
                    
                }
            }
            
        }
    }
    
    
    var captionText:String? {
        didSet {
            captionLabel.text = self.captionText!
        }
    }
    
    lazy var profileImageView:UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    lazy var heartImage:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "like_unselected")
        imageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.heartTapped))
        imageView.addGestureRecognizer(tapRecognizer)
        return imageView
    }()
    
    lazy var commentImage:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "comment")
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentIconTapped))
        imageView.addGestureRecognizer(tapRecognizer)
        return imageView
    }()
    
    lazy var planeImage:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "send2")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var username:UILabel = {
        let label = UILabel()
        label.text = "Treduler"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var dotdotdotImage:UIImageView = {
        let imageView = UIImageView()
        let dotdotdotImage = UIImage(named: "dotdotdot")
        imageView.contentMode = .scaleAspectFit
        imageView.image = dotdotdotImage
        return imageView
    }()
    
    lazy var feedImage:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    lazy var bookmarkImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "ribbon")
        return imageView
    }()
    
    var likes = 0
    
    lazy var likeLabel:UILabel = {
        let label = UILabel()
        label.text = "\(likes) likes"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.text = "Treduler"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var captionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "this is caption..."
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        configView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView(){
        let view = UIView()
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        view.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 46).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        profileImageView.layer.cornerRadius = 23
        
        addSubview(username)
        username.translatesAutoresizingMaskIntoConstraints = false
        username.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        username.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        addSubview(dotdotdotImage)
        dotdotdotImage.translatesAutoresizingMaskIntoConstraints = false
        dotdotdotImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        dotdotdotImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        dotdotdotImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(feedImage)
        feedImage.translatesAutoresizingMaskIntoConstraints = false
        feedImage.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        feedImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        feedImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        feedImage.heightAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        
        let heartAndCommentAndPaperPlaneContainer = UIView()
        heartAndCommentAndPaperPlaneContainer.backgroundColor = .systemRed
        addSubview(heartAndCommentAndPaperPlaneContainer)
        heartAndCommentAndPaperPlaneContainer.translatesAutoresizingMaskIntoConstraints = false
        heartAndCommentAndPaperPlaneContainer.topAnchor.constraint(equalTo: feedImage.bottomAnchor, constant: 0).isActive = true
        heartAndCommentAndPaperPlaneContainer.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        heartAndCommentAndPaperPlaneContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(commentImage)
        addSubview(planeImage)
        addSubview(heartImage)
        
        commentImage.translatesAutoresizingMaskIntoConstraints = false
        planeImage.translatesAutoresizingMaskIntoConstraints = false
        heartImage.translatesAutoresizingMaskIntoConstraints = false
        
        heartImage.leftAnchor.constraint(equalTo: heartAndCommentAndPaperPlaneContainer.leftAnchor, constant: 10).isActive = true
        heartImage.centerYAnchor.constraint(equalTo: heartAndCommentAndPaperPlaneContainer.centerYAnchor).isActive = true
        commentImage.leftAnchor.constraint(equalTo: heartImage.rightAnchor, constant: 20).isActive = true
        commentImage.centerYAnchor.constraint(equalTo: heartAndCommentAndPaperPlaneContainer.centerYAnchor, constant: 0).isActive = true
        planeImage.leftAnchor.constraint(equalTo: commentImage.rightAnchor, constant: 20).isActive = true
        planeImage.centerYAnchor.constraint(equalTo: heartAndCommentAndPaperPlaneContainer.centerYAnchor).isActive = true
        
        addSubview(bookmarkImageView)
        bookmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        bookmarkImageView.topAnchor.constraint(equalTo: feedImage.bottomAnchor, constant: 10).isActive = true
        bookmarkImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        addSubview(likeLabel)
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        likeLabel.topAnchor.constraint(equalTo: heartAndCommentAndPaperPlaneContainer.bottomAnchor, constant: 0).isActive = true
        likeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        
        let usernameAndCaptionContainer = UIView()
        addSubview(usernameAndCaptionContainer)
        addSubview(usernameLabel)
        addSubview(captionLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameAndCaptionContainer.translatesAutoresizingMaskIntoConstraints = false
        usernameAndCaptionContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        usernameAndCaptionContainer.topAnchor.constraint(equalTo: likeLabel.bottomAnchor, constant: 0).isActive = true
        usernameAndCaptionContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: usernameAndCaptionContainer.leftAnchor, constant: 10).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: usernameAndCaptionContainer.centerYAnchor).isActive = true
        captionLabel.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 5).isActive = true
        captionLabel.centerYAnchor.constraint(equalTo: usernameAndCaptionContainer.centerYAnchor).isActive = true
        
    }
    
    @objc func commentIconTapped(){
        guard self.feedId != nil else { return }
        delegate?.commentIconTapped(feedId: self.feedId!)
    }
    
    func checkILikeThisFeed(){
        if checked == true { return }
        self.checked = true
        if let email = Auth.auth().currentUser?.email, let feedId = self.feedId {
            db.collection("likes").getDocuments { (querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        guard let fi = data["feedId"] as? String,
                        let ci = data["id"] as? String,
                        let ue = data["userEmail"] as? String
                            else { return }
                        
                        if feedId == fi {
                            self.likes += 1
                        }
                        
                        if feedId == fi, email == ue {
                            // 내가 좋아요를 누른 게시물임
                            self.likeId = ci
                            self.heartImage.image = UIImage(named: "like_selected")
                            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.fullheartTapped))
                            self.heartImage.addGestureRecognizer(tapRecognizer)
                        }
                        
                    }
                    self.likeLabel.text = "\(self.likes) likes"
                }
            }
        }
    }
    
    @objc func fullheartTapped(){
        guard self.likeId != nil else { return }
        db.collection("likes").document(self.likeId!).delete { (error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                self.likes -= 1
                self.likeLabel.text = "\(self.likes) likes"
                self.heartImage.image = UIImage(named: "like_unselected")
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.heartTapped))
                self.heartImage.addGestureRecognizer(tapRecognizer)
            }
        }
    }
    
    @objc func heartTapped(){
        print("here")
        guard let email = Auth.auth().currentUser?.email,
            let feedId = self.feedId else { return }
        
        var ref: DocumentReference?
        
        ref = db.collection("likes").addDocument(data: [
            "feedId": feedId,
            "userEmail": email
            ], completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }else {
                    print("Document added with ID: \(ref!.documentID)")
                    self.db.collection("likes").document(ref!.documentID).updateData([
                        "id":ref!.documentID
                    ]) { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }else {
                            print("Document successfully updated")
                            self.likes += 1
                            self.likeLabel.text = "\(self.likes) likes"
                            self.heartImage.image = UIImage(named: "like_selected")
                            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.fullheartTapped))
                            self.heartImage.addGestureRecognizer(tapRecognizer)
                        }
                    }
                }
        })
        
    }
    
    
    
    func fetchUser(){
        if let email = self.userEmail {
            db.collection("users").getDocuments { (querySnapsot, error) in
                if let error = error {
                    print("There was error fetching users from database Error: ", error.localizedDescription)
                }else {
                    for document in querySnapsot!.documents {
                        
                        let data = document.data()
                        guard let useremail = data["email"] as? String,
                        let profileImageUrl = data["profileImageUrl"] as? String,
                        let username = data["username"] as? String
                            else { return }
                        
                        if email == useremail {
                                
                                DispatchQueue.main.async {
                                    do{
                                        let url = URL(string: profileImageUrl)
                                        guard url != nil else { return }
                                        let data = try Data(contentsOf: url!)
                                        self.profileImageView.image = UIImage(data: data)
                                        self.username.text = username
                                        self.usernameLabel.text = username
                                    }catch {
                                        
                                    }   
                                }
                        }
                    }
                }
            }
        }
    }
}
