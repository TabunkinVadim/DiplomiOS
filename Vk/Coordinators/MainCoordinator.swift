//
//  MainCoordinator.swift
//  Vk
//
//  Created by Табункин Вадим on 23.06.2022.
//

import UIKit
import Firebase


final class MainCoordinator {

    static let shared = MainCoordinator(navigationController: UINavigationController())
    var childCoordinators =  [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(){
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
            } else {
                self.errorAlert(title: "Error".localized, buttomTitle: "Ok".localized, error: NSError(domain: "Кто-то вышел из вашего аккаунта", code: 180)) { _ in
                    self.navigationController.popViewController(animated: true)
                }
            }
        }

        if let userAuth = Auth.auth().currentUser{
            let firestoreCoordinator = FirestoreCoordinator()
            firestoreCoordinator.getUser(userID: userAuth.uid) { user, error in
                guard let user = user else {
                    self.startVC()
                    return
                }
                self.tapBarVC(user: user)
            }
        } else {
            startVC()
        }
    }

    func startVC() {
        let vc = StartViewController()
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
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

    func verificationVC(userNumber: String, verificationID: String?, isRegistration: Bool) {
        let vc = VerificationViewController(userNumber: userNumber, verificationID: verificationID, isRegistration: isRegistration)
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: false)
    }

    func tapBarVC(user: User) {
        let vc = MainTabBarController(user: user)
        vc.coordinator = self
        vc.tabBar.tintColor = .appOrange
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: false)
    }

    func profile(navigationController: UINavigationController, user: User)-> ProfileCoordinator {
        let child = ProfileCoordinator(navigationController: navigationController, user: user)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
        return child
    }
    
    func feed(navigationController: UINavigationController, user: User) -> FeedCoordinator{
        let child = FeedCoordinator(navigationController: navigationController, user: user)
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

    func errorAlert (title: String, buttomTitle: String, error: Error?, cancelAction:((UIAlertAction) -> Void)?) {
        let alert: UIAlertController = {
            $0.title = title
            if let error = error {
                $0.message = error.localizedDescription
            } else { $0.message = "UnknownError".localized }
            return $0
        }(UIAlertController())
        alert.addAction(UIAlertAction(title: buttomTitle, style: .cancel, handler: cancelAction))
        navigationController.present(alert, animated: true)
    }
}
