//
//  CommentVC.swift
//  instagram
//
//  Created by 신동규 on 2020/03/04.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "aslkdjaslkd"

class CommentVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let db = Firestore.firestore()
    
    var comments = [Comment]()
    
    var feedId:String? {
        didSet {
            print(self.feedId!)
            fetchComments(feedIdString: self.feedId!)
        }
    }
    
    
    
    lazy var commentTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "add comment"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.delegate = self
        return tf
    }()
    
    lazy var postButton:UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(postTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var textFieldContainer:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        view.addSubview(commentTextField)
        view.backgroundColor = .white
        
        view.addSubview(self.postButton)
        self.postButton.translatesAutoresizingMaskIntoConstraints = false
        self.postButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.postButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.postButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.postButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        commentTextField.rightAnchor.constraint(equalTo: self.postButton.leftAnchor, constant: 10).isActive = true
        commentTextField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        commentTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Comment"
        self.collectionView.backgroundColor = .white
        self.collectionView!.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(CommentHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return textFieldContainer
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let maxLabelSize = CGSize(width: collectionView.frame.width, height: 1000)
        let contentNSSString = self.comments[indexPath.row].caption as NSString
        let expectedLabelSize = contentNSSString.boundingRect(with: maxLabelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [.font : UIFont.systemFont(ofSize: 12)], context: nil)
        
        
        return CGSize(width: collectionView.frame.width, height: expectedLabelSize.height + 8)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
    
        // Configure the cell
        cell.comment = comments[indexPath.row]
    
        return cell
    }
    
    
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! CommentHeader
        
        if let feedId = self.feedId {
            header.feedId = feedId
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 70)
    }
    
    func postComment(userEmail:String, caption:String, feedId:String){
        var ref:DocumentReference?
        
        ref = db.collection("comments").addDocument(data: [
            "userEmail" : userEmail,
            "caption": caption,
            "feedId" : feedId
        ]) {
            err in
            if let err = err {
                print("Error adding document: \(err)")
            }else {
                print("Document added with ID: \(ref!.documentID)")
                let comment = Comment(caption: caption, feedId: feedId, userEmail: userEmail)
                self.comments.append(comment)
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchComments(feedIdString:String){
        
        
        db.collection("comments").getDocuments { (qs, er) in
            if let er = er {
                print(er.localizedDescription)
            }else {
                for document in qs!.documents {
                    let data = document.data()
                    guard let caption = data["caption"] as? String,
                    let useremail = data["userEmail"] as? String,
                    let feedId = data["feedId"] as? String
                        else { return }
                    if feedIdString == feedId {
                        let comment = Comment(caption: caption, feedId: feedId, userEmail: useremail)
                        self.comments.append(comment)
                    }
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func postTapped(){
        if let commentString = self.commentTextField.text {
            if commentString != "" {
                print("return tapped")
                if let feedId = self.feedId {
                    if let email = Auth.auth().currentUser!.email {
                        postComment(userEmail: email, caption: commentString, feedId: feedId)
                    }
                }
                
                self.commentTextField.text = ""
                
            }
        }
    }
    
    

}

extension CommentVC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let commentString = self.commentTextField.text {
            if commentString != "" {
                print("return tapped")
                if let feedId = self.feedId {
                    if let email = Auth.auth().currentUser!.email {
                        postComment(userEmail: email, caption: commentString, feedId: feedId)
                    }
                }
                
                self.commentTextField.text = ""
                return true
            }
        }
        return false
    }
}
