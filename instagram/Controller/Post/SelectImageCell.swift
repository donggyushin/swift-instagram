//
//  SelectImageCell.swift
//  instagram
//
//  Created by 신동규 on 2020/03/03.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

protocol SelectImageCellProtocol {
    func tappedImageCell(image:UIImage)
}

class SelectImageCell: UICollectionViewCell {
    
    var delegate:SelectImageCellProtocol?
    
    var imageCell:UIImage? {
        didSet {
            ImageCellView.image = self.imageCell!
        }
    }
    
    lazy var ImageCellView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageCellTapped))
        imageView.addGestureRecognizer(tapRecognizer)
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(ImageCellView)
        ImageCellView.translatesAutoresizingMaskIntoConstraints = false
        ImageCellView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        ImageCellView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        ImageCellView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        ImageCellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func imageCellTapped(){
        guard self.imageCell != nil else {
            return
        }
        self.delegate?.tappedImageCell(image: self.imageCell!)
    }
}
