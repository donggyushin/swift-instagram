//
//  CommentCell.swift
//  instagram
//
//  Created by 신동규 on 2020/03/04.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment:Comment? {
        didSet {
            commentLabel.text = self.comment!.caption
        }
    }
    
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
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
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
//        usernameLabel.centerYAnchor.constraint(equalTo: usernameAndCommentContainer.centerYAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: usernameAndCommentContainer.topAnchor, constant: 10).isActive = true
        commentLabel.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 7).isActive = true
        commentLabel.topAnchor.constraint(equalTo: usernameAndCommentContainer.topAnchor, constant: 10).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: usernameAndCommentContainer.rightAnchor, constant: 10).isActive = true
//        commentLabel.centerYAnchor.constraint(equalTo: usernameAndCommentContainer.centerYAnchor).isActive = true
        
        
        contentView.bottomAnchor.constraint(equalTo: usernameAndCommentContainer.bottomAnchor, constant: 10).isActive = true
    }
    
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
}
