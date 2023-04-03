//
//  Comment.swift
//  Vk
//
//  Created by Табункин Вадим on 26.03.2023.
//

import UIKit


class Comment {
    var avatar: UIImage
    var author: String
    var comment: String
    var commentDate: String
    var likeCount: Int

    init(avatar: UIImage, author: String, comment: String, commentDate: String, likeCount: Int) {
        self.avatar = avatar
        self.author = author
        self.comment = comment
        self.commentDate = commentDate
        self.likeCount = likeCount
    }
}
