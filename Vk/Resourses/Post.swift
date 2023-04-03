
//
//  Post.swift
//  Navigation
//
//  Created by Табункин Вадим on 03.03.2022.
//

import UIKit


public struct Post {
    public let userID: String
    public var postIndex: Int
    public var avatar: UIImage
    public var author: String
    public var image: UIImage
    public var description: String
    public var likes: Int
    public var comments: Int

    public init(userID: String, postIndex: Int, avatar: UIImage, author: String, image: UIImage, description: String,likes: Int,views: Int) {
        self.userID = userID
        self.postIndex = postIndex
        self .avatar = avatar
        self .author = author
        self .image = image
        self .description = description
        self .likes = likes
        self .comments = views
    }
}

//var images = [UIImage(imageLiteralResourceName: "img_1"), UIImage(imageLiteralResourceName: "img_2"), UIImage(imageLiteralResourceName: "img_3"), UIImage(imageLiteralResourceName: "img_4")]
