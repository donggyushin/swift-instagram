//
//  FollowingCell.swift
//  instagram
//
//  Created by 신동규 on 2020/03/02.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class FollowingCell: UITableViewCell {
    
    var user:User? {
        didSet {
            UsernameLabel.text = self.user!.username
            FullnameLabel.text = self.user!.fullname
            
            do{
                let url = URL(string: self.user!.profileImageUrl)
                
                guard url != nil else { return }
                
                let data = try Data(contentsOf: url!)
                
                ProfileImageView.image = UIImage(data: data)
            }catch {
                
            }
            
        }
    }
    
    
    let ProfileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        return imageView

    }()
    
    let UsernameLabel:UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    let FullnameLabel:UILabel = {
        let label = UILabel()
        label.text = "fullname"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(ProfileImageView)
        ProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        ProfileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        ProfileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        ProfileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        ProfileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        ProfileImageView.layer.cornerRadius = 24
        
        addSubview(UsernameLabel)
        addSubview(FullnameLabel)
        UsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        FullnameLabel.translatesAutoresizingMaskIntoConstraints = false
        UsernameLabel.leftAnchor.constraint(equalTo: ProfileImageView.rightAnchor, constant: 12).isActive = true
        UsernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        FullnameLabel.leftAnchor.constraint(equalTo: ProfileImageView.rightAnchor, constant: 12).isActive = true
        FullnameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
