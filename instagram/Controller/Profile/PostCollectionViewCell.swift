//
//  PostCollectionViewCell.swift
//  instagram
//
//  Created by 신동규 on 2020/03/03.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

protocol PostCollectionViewCellProtocol {
    func feedCellTaped(feedId:String)
}

class PostCollectionViewCell: UICollectionViewCell {
    
    var feedId:String?
    
    var delegate:PostCollectionViewCellProtocol?
    
    var imageForCell:String? {
        didSet {
            
            do {
                let url = URL(string: self.imageForCell!)
                
                guard url != nil else {
                    return
                }
                
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                
                PostImageView.image = image
                
            }catch {
                
            }
            
        }
    }
    
    lazy var PostImageView:UIImageView = {
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
        
        addSubview(PostImageView)
        PostImageView.translatesAutoresizingMaskIntoConstraints = false
        PostImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        PostImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        PostImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        PostImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func imageCellTapped() {
        guard self.feedId != nil else { return }
        delegate?.feedCellTaped(feedId: self.feedId!)
    }
    
}
