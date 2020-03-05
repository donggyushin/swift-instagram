//
//  OneFeedVC.swift
//  instagram
//
//  Created by 신동규 on 2020/03/04.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

class OneFeedVC: UIViewController {
    
    var likeId:String?
    
    var user:User? {
        didSet {
            
                
                DispatchQueue.main.async {
                    do {
                        let url = URL(string: self.user!.profileImageUrl)
                        guard url != nil else { return }
                        let data = try Data(contentsOf: url!)
                        self.profileImageView.image = UIImage(data: data)
                        self.usernameLabel.text = self.user!.username
                        self.usernameLabel2.text = self.user!.username
                    }catch {
                        
                    }
                    
                }
                
            
            
        }
    }
    
    var post:Post? {
        didSet {
            fetchUserData(email: self.post!.useremail)
            
                
                DispatchQueue.main.async {
                    do {
                        let url = URL(string: self.post!.imageurl)
                        guard url != nil else { return }
                        let data = try Data(contentsOf: url!)
                        self.feedimageview.image = UIImage(data: data)
                        self.captionLabel.text = self.post!.text
                    }catch {
                        
                    }
                    
                }
                
            
                
            
        }
    }
    
    var feedId:String? {
        didSet {
            self.fetchPost(feedId: self.feedId!)
        }
    }
    
    let db = Firestore.firestore()
    
    lazy var feedView:UIView = {
        let uiview = UIView()
        return uiview
    }()
    
    lazy var profileImageAndUserNameView:UIView = {
        let uiv = UIView()
        uiv.backgroundColor = .white
        return uiv
    }()
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.text = "Treduler"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var feedimageview:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var iconContainer:UIView = {
        let uiview = UIView()
        return uiview
    }()
    
    lazy var heartIcon:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "like_unselected")
        iv.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(heartTapped))
        iv.addGestureRecognizer(tapRecognizer)
        return iv
    }()
    
    @objc func heartTapped(){
        likeFunction()
        
    }
    
    @objc func fullheartTapped(){
        unlikeFunction()
    }
    
    lazy var commentIcon:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "comment")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(commentIconTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    lazy var planeIcon:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "send2")
        return iv
    }()
    
    var likes:Int = 0
    
    lazy var likeLabel:UILabel = {
        let label = UILabel()
        label.text = "\(likes) likes"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var usernameandcaptioncontainer:UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var usernameLabel2:UILabel = {
        let label = UILabel()
        label.text = "Treduler"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var captionLabel:UILabel = {
        let label = UILabel()
        label.text = "caption for this feed..."
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkILikedThisFeedOrNot()
        navigationItem.title = "Feed"
        view.backgroundColor = .white
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func fetchPost(feedId:String){
        let postRef = db.collection("posts").document(feedId)
        
        postRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let data = document.data()!
                
                guard let date = data["date"] as? String,
                let useremail = data["useremail"] as? String,
                let imageurl = data["imageurl"] as? String,
                let id = data["id"] as? String,
                    let text = data["text"] as? String else { return }
                
                let post = Post(id: id, imageurl: imageurl, text: text, useremail: useremail, date: date)
                self.post = post
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func fetchUserData(email:String){
        db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let username = data["username"] as? String,
                        let email2 = data["email"] as? String,
                        let fullname = data["name"] as? String,
                        let proflileimageurl = data["profileImageUrl"] as? String
                        else { return }
                    if email == email2 {
                        self.user = User(username: username, email: email2, fullname: fullname, profileImageUrl: proflileimageurl)
                        return
                    }
                }
            }
        }
    }
    
    
    @objc func commentIconTapped(){
        guard let feedId = self.feedId else { return }
        let commentVC = CommentVC(collectionViewLayout: UICollectionViewFlowLayout())
        commentVC.feedId = feedId
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
    
    
    
    // MARK: configure view
    
    func configureView(){
        self.view.addSubview(feedView)
        feedView.translatesAutoresizingMaskIntoConstraints = false
        feedView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        feedView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        feedView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        feedView.heightAnchor.constraint(equalToConstant: self.view.frame.width + 200).isActive = true

        self.view.addSubview(profileImageAndUserNameView)
        profileImageAndUserNameView.translatesAutoresizingMaskIntoConstraints = false
        profileImageAndUserNameView.topAnchor.constraint(equalTo: feedView.topAnchor, constant: 0).isActive = true
        profileImageAndUserNameView.leftAnchor.constraint(equalTo: feedView.leftAnchor, constant: 0).isActive = true
        profileImageAndUserNameView.rightAnchor.constraint(equalTo: feedView.rightAnchor, constant: 0).isActive = true
        profileImageAndUserNameView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        self.view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leftAnchor.constraint(equalTo: profileImageAndUserNameView.leftAnchor, constant: 10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 46).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        profileImageView.layer.cornerRadius = 23
        profileImageView.centerYAnchor.constraint(equalTo: profileImageAndUserNameView.centerYAnchor).isActive = true
        
        self.view.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageAndUserNameView.centerYAnchor).isActive = true
        
        self.view.addSubview(feedimageview)
        feedimageview.translatesAutoresizingMaskIntoConstraints = false
        feedimageview.leftAnchor.constraint(equalTo: feedView.leftAnchor).isActive = true
        feedimageview.rightAnchor.constraint(equalTo: feedView.rightAnchor).isActive = true
        feedimageview.topAnchor.constraint(equalTo: profileImageAndUserNameView.bottomAnchor).isActive = true
        feedimageview.heightAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        self.view.addSubview(iconContainer)
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.topAnchor.constraint(equalTo: feedimageview.bottomAnchor).isActive = true
        iconContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        iconContainer.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.view.addSubview(heartIcon)
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        heartIcon.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor).isActive = true
        heartIcon.leftAnchor.constraint(equalTo: iconContainer.leftAnchor, constant: 13).isActive = true
        
        self.view.addSubview(commentIcon)
        commentIcon.translatesAutoresizingMaskIntoConstraints = false
        commentIcon.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor).isActive = true
        commentIcon.leftAnchor.constraint(equalTo: heartIcon.rightAnchor, constant: 20).isActive = true
        
        self.view.addSubview(planeIcon)
        planeIcon.translatesAutoresizingMaskIntoConstraints = false
        planeIcon.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor).isActive = true
        planeIcon.leftAnchor.constraint(equalTo: commentIcon.rightAnchor, constant: 20).isActive = true
        
        self.view.addSubview(likeLabel)
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        likeLabel.topAnchor.constraint(equalTo: iconContainer.bottomAnchor).isActive = true
        likeLabel.leftAnchor.constraint(equalTo: feedView.leftAnchor, constant: 10).isActive = true
        
        self.view.addSubview(usernameandcaptioncontainer)
        self.view.addSubview(usernameLabel2)
        self.view.addSubview(captionLabel)
        usernameandcaptioncontainer.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel2.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        usernameandcaptioncontainer.leftAnchor.constraint(equalTo: feedView.leftAnchor).isActive = true
        usernameandcaptioncontainer.topAnchor.constraint(equalTo: likeLabel.bottomAnchor, constant: 0).isActive = true
        usernameandcaptioncontainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        usernameLabel2.leftAnchor.constraint(equalTo: usernameandcaptioncontainer.leftAnchor, constant: 10).isActive = true
        usernameLabel2.centerYAnchor.constraint(equalTo: usernameandcaptioncontainer.centerYAnchor).isActive = true
        captionLabel.leftAnchor.constraint(equalTo: usernameLabel2.rightAnchor, constant: 7).isActive = true
        captionLabel.centerYAnchor.constraint(equalTo: usernameandcaptioncontainer.centerYAnchor).isActive = true
        
    }
    
    func checkILikedThisFeedOrNot(){
        if let feedId = self.feedId, let email = Auth.auth().currentUser?.email {
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
                            // 좋아요를 누른 게시물
                            self.likeId = ci
                            let fullHeartImage = UIImage(named: "like_selected")
                            self.heartIcon.image = fullHeartImage
                            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.fullheartTapped))
                            self.heartIcon.addGestureRecognizer(tapRecognizer)
                        }
                        
                    }
                    self.likeLabel.text = "\(self.likes) likes"
                }
            }
        }
    }
    
    func unlikeFunction(){
        guard self.likeId != nil else { return }
        let deleteRecognizer = UITapGestureRecognizer(target: self, action: #selector(nothingFunc))
        self.heartIcon.addGestureRecognizer(deleteRecognizer)
        db.collection("likes").document(self.likeId!).delete { (error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                self.likes -= 1
                self.likeLabel.text = "\(self.likes) likes"
                let fullHeartImage = UIImage(named: "like_unselected")
                self.heartIcon.image = fullHeartImage
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.heartTapped))
                self.heartIcon.addGestureRecognizer(tapRecognizer)
            }
        }
    }
    
    @objc func nothingFunc() { }
    
    func likeFunction(){
        guard self.feedId != nil else { return }
        guard self.post != nil else { return }
        let deleteRecognizer = UITapGestureRecognizer(target: self, action: #selector(nothingFunc))
        self.heartIcon.addGestureRecognizer(deleteRecognizer)
        var ref:DocumentReference?
        ref = db.collection("likes").addDocument(data: [
            "feedId" : self.feedId!,
            "userEmail" : Auth.auth().currentUser!.email!,
            "feedUserEmail" : self.post!.useremail
        ]) { err in
        if let err = err {
            print("Error adding document: \(err)")
        } else {
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
                    let fullHeartImage = UIImage(named: "like_selected")
                    self.heartIcon.image = fullHeartImage
                    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.fullheartTapped))
                    self.heartIcon.addGestureRecognizer(tapRecognizer)
                }
            }
            }
        }
    }
    
}
