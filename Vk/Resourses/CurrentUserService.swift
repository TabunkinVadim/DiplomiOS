//
//  CurrentUserService.swift
//  Vk
//
//  Created by Табункин Вадим on 31.05.2022.
//

import Foundation
import UIKit

class CurrentUserService: UserService {
    public let currentUser = User(nickname: "Ivan_Kalita",
                                  fullName: "Ivan".localized,
                                  profession: "King",
                                  avatar: UIImage(named: "Ivan_Kalita") ?? UIImage(),
                                  status: "IvanStatus".localized)
//    (fullName: "Ivan".localized, avatar: UIImage(named: "Ivan_Kalita") ?? UIImage(), status: "IvanStatus".localized)
    func setUser(fullName: String) -> User? {
        if fullName == currentUser.fullName {
            return currentUser
        } else {
            return nil
        }
    }
}
