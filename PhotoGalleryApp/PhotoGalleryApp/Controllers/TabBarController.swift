//
//  TabBarController.swift
//  PhotoGalleryApp
//
//  Created by Matvei Khlestov on 09.06.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
    }
    
    private func generateTabBar() {
        let layout = UICollectionViewFlowLayout()
        
        let photosVC = PhotosCollectionViewController(collectionViewLayout: layout)
        let favouriteVC = FavouriteViewController()
        
        viewControllers = [
            generateVC(
                rootViewController: photosVC,
                title: "Photos",
                image: UIImage(systemName: "photo.fill.on.rectangle.fill")
            ),
            
            generateVC(
                rootViewController: favouriteVC,
                title: "Favoruites",
                image: UIImage(systemName: "heart.fill")
            )
        ]
    }
    
    private func generateVC(rootViewController: UIViewController,
                            title: String, image: UIImage?) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
}
