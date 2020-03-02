//
//  SelectImageHeaderCell.swift
//  instagram
//
//  Created by 신동규 on 2020/03/03.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

protocol SelectImageHeaderCellProtocol {
    func cancleButtonTapped()
}

class SelectImageHeaderCell: UICollectionViewCell {
    
    var delegate:SelectImageHeaderCellProtocol?
    
    var selectedImage:UIImage? {
        didSet {
            SelectedImageView.image = self.selectedImage!
        }
    }
    
    lazy var SelectedImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var cancleButton:UIButton = {
        let button = UIButton()
        button.setTitle("cancle", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(cancleButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    lazy var submitButton:UIButton = {
        let button = UIButton()
        button.setTitle("submit", for: .normal)
        button.isUserInteractionEnabled = true
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(SelectedImageView)
        SelectedImageView.translatesAutoresizingMaskIntoConstraints = false
        SelectedImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        SelectedImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        SelectedImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        SelectedImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
    
        addSubview(cancleButton)
        cancleButton.translatesAutoresizingMaskIntoConstraints = false
        cancleButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        cancleButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
//        cancleButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
//        cancleButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancleButton.layer.cornerRadius = 10
        
        addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.rightAnchor.constraint(equalTo: cancleButton.leftAnchor, constant: -8).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancleButtonTapped(){
        self.delegate?.cancleButtonTapped()
    }
}
