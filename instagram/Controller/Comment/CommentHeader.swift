//
//  CommentHeader.swift
//  instagram
//
//  Created by 신동규 on 2020/03/04.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class CommentHeader: UICollectionViewCell {
    
    lazy var divider:UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var usernameAndCaptionContainer:UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.text = "Da hae"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var captionLabel:UILabel = {
        let label = UILabel()
        label.text = "Caption text..."
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(){
        addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        divider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        addSubview(usernameLabel)
        addSubview(captionLabel)
        addSubview(usernameAndCaptionContainer)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameAndCaptionContainer.translatesAutoresizingMaskIntoConstraints = false
        usernameAndCaptionContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        usernameAndCaptionContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        usernameAndCaptionContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: usernameAndCaptionContainer.leftAnchor, constant: 10).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: usernameAndCaptionContainer.centerYAnchor).isActive = true
        captionLabel.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 7).isActive = true
        captionLabel.centerYAnchor.constraint(equalTo: usernameAndCaptionContainer.centerYAnchor).isActive = true 
    }
    
}
