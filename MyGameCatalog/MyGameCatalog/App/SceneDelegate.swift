//
//  SceneDelegate.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 02/03/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileStoryboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        let favoriteStoryboard = UIStoryboard(name: "FavoriteViewController", bundle: nil)
            
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "Main") as! MainViewController
        let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        let favoriteViewController = favoriteStoryboard.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        
        let mainNavController = UINavigationController(rootViewController: mainViewController)
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        let favoriteNavController = UINavigationController(rootViewController: favoriteViewController)

        
        mainNavController.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house.fill" ), tag: 0)
        favoriteNavController.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "bookmark.fill"), tag: 1)
        profileNavController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mainNavController, favoriteNavController, profileNavController]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}

