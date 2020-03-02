//
//  ProfileHeader.swift
//  instagram
//
//  Created by 신동규 on 2020/03/01.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class ProfileHeader: UICollectionViewCell {
    
    var fullname:String? {
        didSet {
            
            nameLabel.text = self.fullname!
        }
    }
    
    var profileImageUrl:String? {
        didSet {
            let url = URL(string: self.profileImageUrl!)
            
            guard url != nil else {
                print("Fail to create url")
                return
                
            }
            
            do{
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                
                guard image != nil else {
                    print("Fail to make image")
                    return
                }
                
                profileImageView.image = image!
            }catch {
                print("Fail to make data")
            }
            
        }
    }
    
    let profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let postsLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        
        let mutableAttrString = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        mutableAttrString.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        label.attributedText = mutableAttrString
        
        return label
    }()
    let followersLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        
        let mutableAttrString = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        mutableAttrString.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        label.attributedText = mutableAttrString
        
        return label
    }()
    
    let followingLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        
        let mutableAttrString = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        mutableAttrString.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        label.attributedText = mutableAttrString
        
        return label
    }()
    
    
    let editButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Edit profile", for: .normal)
        button.titleLabel?.textColor = UIColor.black
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 5
        return button
        
    }()
    
    let gridButton:UIButton = {
        let button = UIButton()
        
        let origImage = UIImage(named: "grid")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .systemBlue
        
        return button
    }()
    
    let listButton:UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "list")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor(red: 147/255, green: 147/255, blue: 147/255, alpha: 1.0) /* #939393 */
        
        
        
        return button
    }()
    
    let bookMarkButton:UIButton = {
        
        let button = UIButton()
        let origImage = UIImage(named: "ribbon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor(red: 147/255, green: 147/255, blue: 147/255, alpha: 1.0) /* #939393 */
        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("header view loaded")
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 14, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        profileImageView.layer.cornerRadius = 30
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 7, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 100, height: 0)
        configureUserStats()
        addSubview(editButton)
        editButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 13, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        configureBottomButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureBottomButtons(){
        let topBorder = UIView()
        topBorder.backgroundColor = .lightGray
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = .lightGray
        
        let stackview = UIStackView(arrangedSubviews: [gridButton, listButton, bookMarkButton])
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        
        addSubview(topBorder)
        addSubview(bottomBorder)
        addSubview(stackview)
        
        stackview.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 45)
        topBorder.anchor(top: stackview.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomBorder.anchor(top: stackview.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    
    func configureUserStats(){
        let stackview = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        stackview.backgroundColor = .red
        addSubview(stackview)
        stackview.anchor(top: self.topAnchor, left: nameLabel.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
    }
    
    
    
}
