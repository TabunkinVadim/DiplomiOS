//
//  FavoritePostsController.swift
//  Vk
//
//  Created by Табункин Вадим on 28.08.2022.
//

import Foundation
import UIKit

class FavoritePostsController: UIViewController, PostProtocol {

    private var index: Int = 0
    private lazy var tableView: UITableView = {
        $0.toAutoLayout()
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .backgroundColor
        $0.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        return $0
    }(UITableView(frame: .zero, style: .grouped))

    // MARK: Delegate PostProtocol
    func openProfile(userID: String) {

    }

    func liked(userID: String, postIndex: Int) {
        let coreDataCoordinator = CoreDataCoordinator()
        let index = coreDataCoordinator.findPost(userID: userID, postIndex: postIndex)
        guard let index = index else {
            return
        }
        coreDataCoordinator.deletePosts(index: index)

        let firestoreCoordinator = FirestoreCoordinator()
        firestoreCoordinator.getPost(userID: userID, postIndex: postIndex) { post, error in
            guard var post = post else {return}
            post.likes -= 1
            firestoreCoordinator.writePost(post: post)
            NotificationCenter.default.post(name: NSNotification.Name.turnDownLike, object: nil, userInfo:["userID": userID, "postIndex": postIndex])
            NotificationCenter.default.post(name: NSNotification.Name.reloadPosts, object: nil)
        }
    }

    // MARK: Notification likes
    @objc func reloadPosts() {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPosts), name: Notification.Name.reloadPosts, object: nil)
        layout()
    }

    private func layout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

extension FavoritePostsController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let coreDataCoordinator = CoreDataCoordinator()
        return coreDataCoordinator.getPostCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coreDataCoordinator = CoreDataCoordinator()
        var cell: PostTableViewCell
        cell = (tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier , for: indexPath) as! PostTableViewCell)
        let favoritPost = coreDataCoordinator.getPost(postIndex: indexPath.row)
        guard  let favoritPost = favoritPost else {return UITableViewCell()}
        cell.delegate = self
        cell.setupCell(model: Post(userID: favoritPost.userID ?? "0",
                                   postIndex: Int(favoritPost.postIndex),
                                   avatar: UIImage(data: favoritPost.autorAvatar!)!,
                                   author: favoritPost.autor!,
                                   image: UIImage(data: favoritPost.image!)!,
                                   description: favoritPost.descriptionPost!,
                                   likes: Int(favoritPost.likes),
                                   views: Int(favoritPost.postViews)),
                       autor: favoritPost.autor!,
                       avatar: UIImage(data: favoritPost.autorAvatar!)!)
        cell.updateImageViewConstraint(view.bounds.size)
        return cell
    }
}

extension FavoritePostsController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
    }
}
