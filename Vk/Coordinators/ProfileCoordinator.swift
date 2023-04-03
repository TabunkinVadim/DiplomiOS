//
//  ProfileCoordinator.swift
//  Vk
//
//  Created by Табункин Вадим on 23.06.2022.
//

import UIKit
import Firebase


final class ProfileCoordinator: Coordinator{

    weak var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let user: User
    
    init(navigationController: UINavigationController, user: User) {
        self.navigationController = navigationController
        self.user = user
    }
    
    func start() {
        self.profileVC(user: user)
    }

    func profileVC(user: User) {
        let vc = ProfileViewController(user: user, isFriend: false)
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = true
        vc.tabBarItem = UITabBarItem(title: "Profile".localized, image: UIImage(systemName: "person")?.withAlignmentRectInsets(.init(top: 0, left: 0, bottom: 0, right: 0)), tag: 0 )
        navigationController.pushViewController(vc, animated: true)
    }

    func infoVC(user: User) {
        let vc = InfoViewController(user: user)
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(vc, animated: false)
    }

    func editProfileControllerVC(user: User) {
        let vc = EditProfileViewController(user: user)
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(vc, animated: false)
    }

    func newPostVC(user: User) {
        let vc = NewPostViewController(user: user)
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
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
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(vc, animated: true)
    }


    func singUpAlert(yesAction:((UIAlertAction) -> Void)?, cancelAction:((UIAlertAction) -> Void)?) {
        let alert: UIAlertController = {
            $0.title = "Создание аккаунта"
            $0.message = "Вы хотите создать аккаунт?"
            return $0
        }(UIAlertController())
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: yesAction))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: cancelAction))
        navigationController.present(alert, animated: true)
    }

    func errorAlert (error: Error?, cancelAction:((UIAlertAction) -> Void)?) {
        let alert: UIAlertController = {
            $0.title = "Ошибка"
            if let error = error {
                $0.message = error.localizedDescription
            } else { $0.message = "Неизвесная ошибка" }
            return $0
        }(UIAlertController())
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: cancelAction))
        navigationController.present(alert, animated: true)
    }

    func didfinish() {
        parentCoordinator?.childDidFinish(self)
    }

    func pop (){
        navigationController.popViewController(animated: true)
    }
}
