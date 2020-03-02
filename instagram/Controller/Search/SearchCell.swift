//
//  SearchCell.swift
//  instagram
//
//  Created by 신동규 on 2020/03/02.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    var username:String? {
        didSet {
            self.usernameLabel.text = self.username!
        }
    }
    
    var fullname:String? {
        didSet {
            self.fullnameLabel.text = self.fullname!
        }
    }
    
    var profileimageurl:String? {
        didSet {
            let url = URL(string: self.profileimageurl!)
            
            guard url != nil else { return }
            
            do{
            
                let data = try Data(contentsOf: url!)
                
                let image = UIImage(data: data)
                
                guard image != nil else {
                    return
                }
                
                self.profileImageView.image = image!
                
            }catch {
                
            }
            
            
        }
    }
    
    let profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    let usernameLabel:UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let fullnameLabel:UILabel = {
        let label = UILabel()
        label.text = "fullname"
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 24
        
        
        addSubview(usernameLabel)
        addSubview(fullnameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -11).isActive = true
        fullnameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullnameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        fullnameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 11).isActive = true
        fullnameLabel.textColor = UIColor.gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        print("awake")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }
    
    

}
