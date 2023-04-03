//
//  FeedCoordinator.swift
//  Vk
//
//  Created by Табункин Вадим on 24.06.2022.
//

import UIKit


public final class FeedCoordinator: Coordinator{

    weak var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let user: User
    
    init(navigationController: UINavigationController, user: User) {
        self.navigationController = navigationController
        self.user = user
    }

    func start() {
        let vc = FeedViewController(user: user)
        vc.coordinator = self
        vc.tabBarItem = UITabBarItem(title: "Feed".localized, image: UIImage(systemName: "newspaper")?.withAlignmentRectInsets(.init(top: 0, left: 0, bottom: 0, right: 0)), tag: 0 )
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: false)
    }

    func PostVC(post: Post, user: User) {
        let vc = PostViewController(post: post, user: user)
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    func photoVC(user: User, isFriend: Bool) {
        let vc = PhotosViewController(user: user, isFriend: isFriend)
        vc.feedCoordinator = self
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(vc, animated: true)
    }

    func profileVC(user: User, isFriend: Bool) {
        let vc = ProfileViewController(user: user, isFriend: isFriend)
        vc.feedCoordinator = self
        vc.view.backgroundColor = .backgroundColor
        if isFriend {
            navigationController.navigationBar.isHidden = false
        } else {
            navigationController.navigationBar.isHidden = true
        }
        vc.tabBarItem = UITabBarItem(title: "Profile".localized, image: UIImage(systemName: "person")?.withAlignmentRectInsets(.init(top: 0, left: 0, bottom: 0, right: 0)), tag: 0 )
        navigationController.pushViewController(vc, animated: true)
    }

    func infoVC(user: User) {
        let vc = InfoViewController(user: user)
        vc.feedCoordinator = self
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(vc, animated: false)
    }
    
    func pop (){
        navigationController.popViewController(animated: true)
    }
}
