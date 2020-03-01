//
//  SignUpVC.swift
//  instagram
//
//  Created by 신동규 on 2020/03/01.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let db = Firestore.firestore()
    
    var imageSelected:Bool = false
    
    let plusPhotoBtn:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal),for: .normal)
        button.addTarget(self, action: #selector(handlePickProfile), for: .touchUpInside)
        return button
    }()
    
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        return tf
    }()
    
    let fullnameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        tf.autocorrectionType = .no
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "User Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        tf.autocorrectionType = .no
        return tf
    }()
    
    let signUpButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton:UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?   ", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor:UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1) ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowSignIp), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        
        view.addSubview(plusPhotoBtn)
        plusPhotoBtn.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        plusPhotoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        configureViewComponents()
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        alreadyHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    func configureViewComponents(){
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,fullnameTextField,usernameTextField ,passwordTextField, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoBtn.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 280)
        
    }
    
    @objc func handleShowSignIp(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let profileImg = plusPhotoBtn.imageView?.image else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Fail to create user with error: ", error.localizedDescription)
            }
            
            if let result = result {
                print("Success create new user with firebase: ", result)
                let uploadData = profileImg.jpegData(compressionQuality: 0.3)
                guard uploadData != nil else {
                    return
                }
                
                let filename:String = UUID().uuidString
                
                let profileRef = Storage.storage().reference().child("profile_image").child(filename)
                
                let uploadTask = profileRef.putData(uploadData!, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("Fail to store image data to fire store")
                        print(error)
                    }
                    
                    profileRef.downloadURL { (url, error) in
                        if let url = url {
                            print("download url: ", url.absoluteString)
                            let dictionaryValues = [
                                "name": fullname,
                                "username":username,
                                "profileImageUrl": url.absoluteString
                            ]
                            
                            
                            self.db.collection("users").addDocument(data: dictionaryValues, completion: { (error) in
                                if let error = error {
                                    print("There was error saving user data to firebase database")
                                    print(error)
                                }
                                print("Success saving user data to firebase database")
                                self.navigationController?.popViewController(animated: true)
                            })
                            
                            
                            
                        }
                    }
                }
                
                uploadTask.resume()
                
            }
        }
        
    }
    
    @objc func validateForm(){
        guard emailTextField.hasText, passwordTextField.hasText, fullnameTextField.hasText, usernameTextField.hasText, imageSelected == true else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let profileImage = info[.editedImage] as? UIImage else {
            imageSelected = false
            return
            
        }
        imageSelected = true
        plusPhotoBtn.layer.cornerRadius = plusPhotoBtn.frame.width / 2
        plusPhotoBtn.layer.masksToBounds = true
        plusPhotoBtn.layer.borderColor = UIColor.black.cgColor
        plusPhotoBtn.layer.borderWidth = 1.5
        plusPhotoBtn.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePickProfile(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }


}
