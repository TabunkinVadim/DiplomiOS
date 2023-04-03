//
//  FirestoreCoordinator.swift
//  Vk
//
//  Created by Табункин Вадим on 06.01.2023.
//

import FirebaseCore
import FirebaseFirestore
import UIKit


class  FirestoreCoordinator {
    let database = Firestore.firestore()

    func writeUsersArray (userID: String) {
        self.getUsersArray { users, error in
            var isNew = true
            for index in 0 ... users.count {
                if users["user\(index)"] == userID {
                    isNew = false
                    return
                }
            }
            if isNew {
                let usersCount = users.count
                var newusers = users
                newusers["user\(usersCount)"] = userID
                let docRef = self.database.document("users/users")
                docRef.setData(newusers)
            }
        }
    }

    func getUsersArray (complection: @escaping ([String: String], Error?) -> Void) {
        var users: [String: String] = [:]
        let docRef = database.document("users/users")
        docRef.getDocument {snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                let errorData = NSError(domain: "Не обноружено записей", code: 405)
                complection ([:], errorData)
                return
            }
            for index in 0... {
                guard let user = data["user\(index)"] as? String else {
                    complection ( users, error)
                    return}
                users["user\(index)"] =  user
            }
            complection (users, error)
        }
    }

    func writeUser (userID: String, user: User) {
        let docRef = database.document("users/\(userID)")
        docRef.setData(["userID": userID,
                        "nickName": user.nickName,
                        "fullName": user.fullName,
                        "gender": user.gender,
                        "dateOFBirth": user.dateOfBirth,
                        "city": user.city,
                        "profession": user.profession,
                        "avatar": user.avatar.jpegData(compressionQuality: 0.1)!,
                        "status": user.status,
                        "numberOfPhoto": user.numberOfPhoto,
                        "numberOfPublications": user.numberOfPublications,
                        "numberOfScribes": user.numberOfScribes,
                        "numberOfSubscriptions": user.numberOfSubscriptions])

        for post in user.userPosts {
            writePost(post: post)
        }

        for (index, image) in user.userPhotos.enumerated() {
            writeImage(userID: userID, imageIndex: index, image: image)
        }
    }

    func getUser(userID: String, complection: @escaping (User?, Error?) -> Void) {
        let docRef = database.document("users/\(userID)")
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                let errorData = NSError(domain: "Даных по учетной записи не обнаружено. Будет создана новая учетная запись", code: 408)
                complection (nil, errorData)
                return
            }

            guard let nickName = data["nickName"] as? String else {return}
            guard let fullName = data["fullName"] as? String else {return}
            guard let gender = data["gender"] as? String else {return}
            guard let dateOfBirth = data["dateOFBirth"] as? String else {return}
            guard let city = data["city"] as? String else {return}
            guard let profession = data["profession"] as? String else {return}
            guard let avatar = UIImage(data: (data["avatar"] as? Data)!) else {return}
            guard let status = data["status"] as? String else {return}
            guard let numberOfPhoto = data["numberOfPhoto"] as? Int else {return}
            guard let numberOfPublications = data["numberOfPublications"] as? Int else {return}
            guard let numberOfScribes = data["numberOfScribes"] as? Int else {return}
            guard let numberOfSubscriptions = data["numberOfSubscriptions"] as? Int else {return}

            complection ( User(userID: userID, nickname: nickName, fullName: fullName, gender: gender, dateOfBirth: dateOfBirth, city: city, profession: profession, avatar: avatar, status: status, numberOfPhoto: numberOfPhoto, numberOfPublications: numberOfPublications, numberOfScribes: numberOfScribes, numberOfSubscriptions: numberOfSubscriptions), error)
        }
    }

    func writePost(post: Post) {
        let docRef = database.document("users/\(post.userID)/posts/post\(post.postIndex)")
        docRef.setData(["userID": post.userID,
                        "postIndex": post.postIndex,
                        "author": post.author,
                        "image": post.image.jpegData(compressionQuality: 0.1) as Any,
                        "description": post.description,
                        "likes": post.likes,
                        "comments": post.comments])
    }

    func getPost (userID: String, postIndex: Int, complection: @escaping (Post?, Error?) -> Void) {

        let docRef = database.document("users/\(userID)/posts/post\(postIndex)")
        docRef.getDocument {snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                let errorData = NSError(domain: "Не обноружено записей", code: 405)
                complection (nil, errorData)
                return
            }
            guard let userID = data["userID"] as? String else {return}
            guard let postIndex = data["postIndex"] as? Int else {return}
            guard let author = data["author"] as? String else {return}
            guard let image = UIImage(data: (data["image"] as? Data)!) else {return}
            guard let description = data["description"] as? String else {return}
            guard let likes = data["likes"] as? Int else {return}
            guard let views = data["comments"] as? Int else {return}

            complection (Post(userID: userID, postIndex: postIndex, avatar: UIImage(named: "Avatar")!, author: author, image: image, description: description, likes: likes, views: views), error)
        }
    }

    func writeImage(userID: String, imageIndex: Int, image: UIImage) {
        let docRef = database.document("users/\(userID)/images/image\(imageIndex)")
        docRef.setData(["image": image.jpegData(compressionQuality: 0.1)!])
    }

    func getImages (user: User, complection: @escaping ([UIImage], Error?) -> Void) {
        var images: [UIImage] = [] {didSet{
            complection (images, nil)
        }}
        for index in 0 ... user.numberOfPhoto  {
            let docRef = database.document("users/\(user.userID)/images/image\(index)")
            docRef.getDocument {snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    let errorData = NSError(domain: "Не обноружено записей", code: 405)
                    complection (images, errorData)
                    return
                }
                guard let image = UIImage(data: (data["image"] as? Data)!) else {
                    complection ( images, error)
                    return}
                images.append(image)
            }
            complection (images, nil)
        }
    }

    func writeComment(post: Post, commentIndex: Int, comment: Comment) {
        let docRef = database.document("users/\(post.userID)/posts/post\(post.postIndex)/comments/comment\(commentIndex)")
        docRef.setData(["avatar": comment.avatar.jpegData(compressionQuality: 0.1) as Any,
                        "author": comment.author ,
                        "comment": comment.comment,
                        "commentDate": comment.commentDate,
                        "likeCount": comment.likeCount])
    }

    func getComment (post: Post, commentIndex: Int, complection: @escaping (Comment?, Error?) -> Void) {

        let docRef = database.document("users/\(post.userID)/posts/post\(post.postIndex)/comments/comment\(commentIndex)")
        docRef.getDocument {snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                let errorData = NSError(domain: "Не обноружено записей", code: 405)
                complection (nil, errorData)
                return
            }
            guard let avatar = UIImage(data: (data["avatar"] as? Data)!) else {return}
            guard let author = data["author"] as? String else {return}
            guard let comment = data["comment"] as? String else {return}
            guard let commentDate = data["commentDate"] as? String else {return}
            guard let likeCount = data["likeCount"] as? Int else {return}

            complection (Comment(avatar: avatar, author: author, comment: comment, commentDate: commentDate, likeCount: likeCount), error)
        }
    }
}
