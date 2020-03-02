//
//  SelectImageVC.swift
//  instagram
//
//  Created by 신동규 on 2020/03/02.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "Cell"
private let headerIdentifier = "header"

class SelectImageVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var images = [UIImage]()
    var selectedImage:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotos()
        self.collectionView!.register(SelectImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(SelectImageHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SelectImageCell
    
        // Configure the cell
        cell.imageCell = images[indexPath.row]
        cell.delegate = self
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 3.0 )/4, height: (collectionView.frame.width - 3.0) / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    // For header size (required)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.size.width, height:collectionView.frame.size.width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SelectImageHeaderCell
        headerView.delegate = self
        if let selectedimage = self.selectedImage {
            headerView.selectedImage = selectedimage
        }
        return headerView

    }
    
    fileprivate func getPhotos() {

        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        // .highQualityFormat will return better quality photos
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if results.count > 0 {
            for i in 0..<results.count {
                let asset = results.object(at: i)
                let size = CGSize(width: 700, height: 700)
                manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { (image, _) in
                    if let image = image {
                        self.images.append(image)
                        if (i == results.count - 1){
                            self.collectionView.reloadData()
                        }
                        if(self.selectedImage == nil){
                            self.selectedImage = image
                        }
                    } else {
                        print("error asset to image")
                    }
                }
            }
        } else {
            print("no photos to display")
        }

    }
    
}

extension SelectImageVC:SelectImageHeaderCellProtocol {
    func cancleButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
}


extension SelectImageVC:SelectImageCellProtocol {
    func tappedImageCell(image: UIImage) {
        self.selectedImage = image
        collectionView.reloadData()
    }
    
    
}
