//
//  CommentCell.swift
//  instagram
//
//  Created by 신동규 on 2020/03/04.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    lazy var usernameAndCommentContainer:UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.text = "Da hae"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var commentLabel:UILabel = {
        let label = UILabel()
        label.text = "test comment"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(){
        addSubview(usernameAndCommentContainer)
        addSubview(usernameLabel)
        addSubview(commentLabel)
        usernameAndCommentContainer.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameAndCommentContainer.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        usernameAndCommentContainer.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        usernameAndCommentContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        usernameAndCommentContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: usernameAndCommentContainer.leftAnchor, constant: 10).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: usernameAndCommentContainer.centerYAnchor).isActive = true
        commentLabel.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 7).isActive = true
        commentLabel.centerYAnchor.constraint(equalTo: usernameAndCommentContainer.centerYAnchor).isActive = true
    }
    
}
