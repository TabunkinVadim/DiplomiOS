//
//  User.swift
//  Vk
//
//  Created by Табункин Вадим on 31.05.2022.
//

import Foundation
import UIKit
import StorageService

class User {
    var nickname: String
    var fullName: String
    var profession: String
    var avatar: UIImage
    var status: String
    var userPosts: [Post] = []
    var userPhoto: [UIImage] = []
    
    init(nickname: String, fullName: String, profession: String, avatar: UIImage, status: String) {
        self.nickname = nickname
        self.fullName = fullName
        self.profession = profession
        self.avatar = avatar
        self.status = status

    }

}
