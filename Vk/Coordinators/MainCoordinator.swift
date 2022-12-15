//
//  MainCoordinator.swift
//  Vk
//
//  Created by Табункин Вадим on 23.06.2022.
//

import Foundation
import UIKit
import Firebase


final class MainCoordinator: Coordinator {
    static let shared = MainCoordinator(navigationController: UINavigationController())
    
    var childCoordinators =  [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        if Firebase.Auth.auth().currentUser != nil {
            tapBarVC()
//            startVC()
        } else {
            startVC()
        }
    }

    func startVC() {
        let vc = StartViewController()
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
        //        vc.tabBarItem = UITabBarItem(title: "Profile".localized, image: UIImage(systemName: "person")?.withAlignmentRectInsets(.init(top: 0, left: 0, bottom: 0, right: 0)), tag: 0 )
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: false)
    }

    func inputVC() {
        let vc = InputViewController()
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: false)
    }

    func registerVC() {
        let vc = RegisterViewController()
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: false)
    }

    func verificationVC(userNumber: String, verificationID: String?) {
        let vc = VerificationViewController(userNumber: userNumber, verificationID: verificationID)
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: false)
    }

    func tapBarVC() {
        //        let vc = StartViewController()
        //        vc.coordinator = self
        //        navigationController.navigationBar.isHidden = true
        //        navigationController.pushViewController(vc, animated: false)
        let loginFactory = MyLoginFactory()
        let checkModel = CheckModel()
        let vc = MainTabBarController(loginCheker: loginFactory.getLoginChek(), checkModel: checkModel)
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: false)
    }

    func profile(navigationController: UINavigationController, loginCheker: LoginInspector)-> ProfileCoordinator {
        let child = ProfileCoordinator(navigationController: navigationController, loginCheker: loginCheker)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
        return child
    }
    
    func feed(navigationController: UINavigationController, checkModel: CheckModel) -> FeedCoordinator{
        let child = FeedCoordinator(navigationController: navigationController, checkModel: checkModel)
        childCoordinators.append(child)
        child.start()
        return child
    }
    func favorite(navigationController: UINavigationController) -> FavoritePostsCoordinator {
        let child = FavoritePostsCoordinator(navigationController: navigationController)
        childCoordinators.append(child)
        child.start()
        return child
    }
    func map(navigationController: UINavigationController) -> MapCoordinator {
        let child = MapCoordinator(navigationController: navigationController)
        childCoordinators.append(child)
        child.start()
        return child
    }
    
    func childDidFinish(_ child:Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    func errorAlert (title: String, error: Error?, cancelAction:((UIAlertAction) -> Void)?) {
            let alert: UIAlertController = {
                $0.title = title
                if let error = error {
                    $0.message = error.localizedDescription
                } else { $0.message = "UnknownError".localized }
                return $0
            }(UIAlertController())
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: cancelAction))
            navigationController.present(alert, animated: true)
        }

}
