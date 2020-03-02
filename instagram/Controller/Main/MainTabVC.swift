//
//  MainTabVC.swift
//  instagram
//
//  Created by 신동규 on 2020/03/01.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class MainTabVC: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        configureViewControllers()
    }
    
    func configureViewControllers(){
        
        // home feed controller
        let unselectedHome = UIImage(named: "home_unselected")
        let selectedHome = UIImage(named: "home_selected")
        
        guard unselectedHome != nil, selectedHome != nil else {
            return
        }
        
        let feedVC = configureNavController(unselectedImage: unselectedHome!, selectedImage: selectedHome!, rootViewController: FeedVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // search feed controller
        let selectedFeedImage = UIImage(named: "search_selected")
        let unselectedFeedImage = UIImage(named: "search_unselected")
        
        guard selectedFeedImage != nil, unselectedFeedImage != nil else {
            return
        }
        
        let searchVC = configureNavController(unselectedImage: unselectedFeedImage!, selectedImage: selectedFeedImage!, rootViewController: SearchVC())
        
        // post controller
        let selectedPostImage = UIImage(named: "plus_unselected")
        let unselectedPostImage = UIImage(named: "plus_unselected")
        
        guard selectedPostImage != nil, unselectedFeedImage != nil else {
            return
        }
        
        let postVC = configureNavController(unselectedImage: unselectedPostImage!, selectedImage: selectedPostImage!, rootViewController: SelectImageVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // notification controller
        let selectedNotification = UIImage(named: "like_selected")
        let unselectedNotification = UIImage(named: "like_unselected")
        let notificationVC = configureNavController(unselectedImage: unselectedNotification!, selectedImage: selectedNotification!, rootViewController: NotificationVC())
        
        // profile controller
        let selectedProfile = UIImage(named: "profile_selected")
        let unselectedProfile = UIImage(named: "profile_unselected")
        let profileVC = configureNavController(unselectedImage: unselectedProfile!, selectedImage: selectedProfile!, rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let controllers = [
        feedVC, searchVC, postVC, notificationVC, profileVC]
        
        viewControllers = controllers
        tabBar.tintColor = .black
        
    }
    
    func configureNavController(unselectedImage:UIImage, selectedImage:UIImage,
                                rootViewController:UIViewController = UIViewController()) -> UINavigationController {
        // construct nav controller
        
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        return navController
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers!.firstIndex(of: viewController)
        
        if(index == 2) {
            let selectImageVC = SelectImageVC(collectionViewLayout: UICollectionViewFlowLayout())
            selectImageVC.modalPresentationStyle = .fullScreen
            present(selectImageVC, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    

}
