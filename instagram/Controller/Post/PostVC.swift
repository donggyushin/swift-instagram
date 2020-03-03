//
//  PostVC.swift
//  instagram
//
//  Created by 신동규 on 2020/03/01.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

protocol PostVCProtocol {
    func dismissPostView()
}

class PostVC: UIViewController {
    
    var delegate:PostVCProtocol?
    
    let postStorageRef = Storage.storage().reference().child("post")
    let db = Firestore.firestore()
    
    var selectedImage:UIImage? {
        didSet {
            SelectedImageView.image = self.selectedImage!
        }
    }
    
    lazy var SelectedImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var TextField:UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        return textView
    }()
    
    lazy var SubmitButton:UIButton = {
        let button = UIButton()
        button.setTitle("Upload", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var loadingIndicator:UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        return activity
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(SelectedImageView)
        view.addSubview(TextField)
        view.addSubview(SubmitButton)
        view.addSubview(loadingIndicator)
        
        SelectedImageView.translatesAutoresizingMaskIntoConstraints = false
        TextField.translatesAutoresizingMaskIntoConstraints = false
        SubmitButton.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        SelectedImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        SelectedImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        SelectedImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        SelectedImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        TextField.leftAnchor.constraint(equalTo: SelectedImageView.rightAnchor, constant: 0).isActive = true
        TextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        TextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        TextField.heightAnchor.constraint(equalToConstant: 150).isActive = true
        SubmitButton.topAnchor.constraint(equalTo: SelectedImageView.bottomAnchor, constant: 10).isActive = true
        SubmitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    
    @objc func uploadTapped(){
        loadingIndicator.startAnimating()
        SubmitButton.isEnabled = false
        SubmitButton.setTitleColor(.gray, for: .normal)
        
        // 이미지를 업로드한다.
        let uuid:String = UUID.init().uuidString
        let imageUploadRef = postStorageRef.child(uuid)
        
        let imageData = self.selectedImage!.jpegData(compressionQuality: 1)
        
        guard imageData != nil else { return }
        
        let uploadTask = imageUploadRef.putData(imageData!, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print("error: faile to upload image to the storage")
                return
                
            }
            
            imageUploadRef.downloadURL { (url, error) in
                // 다운로드 url
                guard let downloadUrl = url else {
                    return
                }
                // download URL을 얻은 후
                
                
                
                // post 데이터베이스에 정보를 저장한다.
                var ref:DocumentReference? = nil
                let data:[String:Any] = [
                    "useremail": Auth.auth().currentUser!.email!,
                    "imageurl" : downloadUrl.absoluteString,
                    "text" : self.TextField.text!
                ]
                ref = self.db.collection("posts").addDocument(data: data, completion: { (error) in
                    if let error = error {
                        print("Error adding document: \(error)")
                    }else {
                        print("Document added with ID: \(ref!.documentID)")
                        // post view를 모두 dismiss 한다
                        self.delegate?.dismissPostView()
                        self.dismiss(animated: false, completion: nil)
                    }
                })
                
                // post - useremail, imageurl, text
            }
            
        }
        
        uploadTask.resume()
        
        
        
    }
    


}
