//
//  User.swift
//  Vk
//
//  Created by Табункин Вадим on 31.05.2022.
//

import UIKit


class User {
    var userID: String
    var nickName: String
    var fullName: String

    var gender: String
    var dateOfBirth: String
    var city: String

    var profession: String
    var avatar: UIImage
    var status: String
    var userPosts: [Post] = []
    var userPhotos: [UIImage] = []

    var numberOfPhoto: Int
    var numberOfPublications: Int
    var numberOfScribes: Int
    var numberOfSubscriptions: Int
    
    init(userID: String, nickname: String, fullName: String, gender: String, dateOfBirth: String, city: String, profession: String, avatar: UIImage, status: String, numberOfPhoto: Int, numberOfPublications: Int, numberOfScribes: Int, numberOfSubscriptions: Int) {
        self.userID = userID
        self.nickName = nickname
        self.fullName = fullName
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        self.city = city
        self.profession = profession
        self.avatar = avatar
        self.status = status
        self.numberOfPhoto = numberOfPhoto
        self.numberOfPublications = numberOfPublications
        self.numberOfScribes = numberOfScribes
        self.numberOfSubscriptions = numberOfSubscriptions
    }

}
