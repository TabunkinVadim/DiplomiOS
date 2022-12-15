//
//  FavoritePostsController.swift
//  Vk
//
//  Created by Табункин Вадим on 28.08.2022.
//

import Foundation
import UIKit
import StorageService

class FavoritePostsController: UIViewController, LikedProtocol {

    private var index: Int = 0
    private lazy var tableView: UITableView = {
        $0.toAutoLayout()
        $0.dataSource = self
        $0.delegate = self
        $0.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        return $0
    }(UITableView(frame: .zero, style: .grouped))

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPosts), name: Notification.Name.reloadPosts, object: nil)
        layout()
    }

    func liked(description: String) {
        let coreDataCoordinator = CoreDataCoordinator()
        let index = coreDataCoordinator.findPost(description: description)
        guard let index = index else {
            return
        }
        coreDataCoordinator.deletePosts(index: index)
        NotificationCenter.default.post(name: NSNotification.Name.turnDownLike, object: nil)
        NotificationCenter.default.post(name: NSNotification.Name.reloadPosts, object: nil)
    }

    @objc func reloadPosts() {
        tableView.reloadData()
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
        cell.setupCell(model: Post(author: favoritPost.autor!,
                                   image: UIImage(data: favoritPost.image!)!,
                                   description: favoritPost.descriptionPost!,
                                   likes: Int(favoritPost.likes),
                                   views: Int(favoritPost.postViews)),
                       set: 1)

        cell.updateImageViewConstraint(view.bounds.size)
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tap)
        return cell
    }
    @objc private func doubleTapped (){
        let coreDataCoordinator = CoreDataCoordinator()
        //        coreDataCoordinator.clearAllCoreData()
        coreDataCoordinator.deletePosts(index: index)

        NotificationCenter.default.post(name: NSNotification.Name.turnDownLike, object: nil)
        NotificationCenter.default.post(name: NSNotification.Name.reloadPosts, object: nil)
    }
}

extension FavoritePostsController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
    }
}
