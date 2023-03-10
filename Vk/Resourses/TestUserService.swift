//
//  TestUserService.swift
//  StorageService
//
//  Created by Табункин Вадим on 05.06.2022.
//

import Foundation
import UIKit

class TestUserService: UserService {
    public let currentUser = User(nickname: "Petr_I",
                                  fullName: "Petr".localized,
                                  profession: "KING",
                                  avatar: UIImage(named: "Petr_1") ?? UIImage(),
                                  status: "PetrStatus".localized)
//    (fullName: "Petr".localized, avatar: UIImage(named: "Petr_1") ?? UIImage(), status: "PetrStatus".localized)
    func setUser(fullName: String) -> User? {
        if fullName == currentUser.fullName {
            return currentUser
        } else {
            return nil
        }
    }
}
