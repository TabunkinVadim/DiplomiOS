//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Табункин Вадим on 03.03.2022.
//

import UIKit
import SwiftUI
import FirebaseAuth
import Firebase


class ProfileViewController: UIViewController, ProfileViewControllerProtocol, PostProtocol, ProfileHeaderActivityProtocol {
    private var isFriend: Bool
    var countRow = 0
    var loadMoreStatus = false
    weak var coordinator: ProfileCoordinator?
    weak var feedCoordinator: FeedCoordinator?
    var user: User

    lazy var header: ProfileHeaderView = ProfileHeaderView(reuseIdentifier: ProfileHeaderView.identifier)

    lazy var tableView: UITableView = {
        $0.toAutoLayout()
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .backgroundColor
        $0.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileHeaderView.identifier)
        $0.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.identifier)
        $0.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        return $0
    }(UITableView(frame: .zero, style: .grouped))

    init (user: User, isFriend: Bool) {
        self.user = user
        self.isFriend = isFriend
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Delegate ProfileViewControllerProtocol
    func infoProfile() {
        self.coordinator?.infoVC(user: self.user)
        self.feedCoordinator?.infoVC(user: self.user)
    }

    func editProfile() {
        self.coordinator?.editProfileControllerVC(user: user)
    }

    func moreProfile() {
        self.coordinator?.alert(title: "SingOut".localized, massage: "wantToGoOut".localized, yesAction: { _ in
            do {
                try Firebase.Auth.auth().signOut()
            } catch {
                print("Error".localized)
            }
            self.coordinator?.pop()
        }, cancelAction: { _ in
        })
    }

    // MARK: Delegate ProfileHeaderActivityProtocol
    func newEntry() {
        coordinator?.newPostVC(user: user)
    }

    func newHistory() {
    }

    func newPhoto() {
        let photoPicer: UIImagePickerController = {
            $0.delegate = self
            return $0
        }(UIImagePickerController())
        self.present(photoPicer, animated: true, completion: nil)
    }

    // MARK: Delegate PostProtocol
    func openProfile(userID: String) {
    }

    func liked(userID: String, postIndex: Int) {
        let coreDataCoordinator = CoreDataCoordinator()
        let index: Int? = {
            for (index, post) in  user.userPosts.enumerated()  {
                if post.userID == userID && post.postIndex == postIndex {
                    return index
                }
            }
            return nil
        }()
        guard let index = index else {
            return
        }

        let indexFavoritPost = coreDataCoordinator.findPost(userID: userID, postIndex: postIndex)
        if let indexFavoritPost = indexFavoritPost {
            var post = self.user.userPosts[index]
            post.likes -= 1
            let firestoreCoordinator = FirestoreCoordinator()
            firestoreCoordinator.writePost(post: post)
            NotificationCenter.default.post(name: NSNotification.Name.turnDownLike, object: nil, userInfo: ["userID": userID, "postIndex": postIndex])
            coreDataCoordinator.deletePosts(index: indexFavoritPost)
        } else {
            var post = self.user.userPosts[index]
            post.likes += 1
            let firestoreCoordinator = FirestoreCoordinator()
            firestoreCoordinator.writePost(post: post)
            NotificationCenter.default.post(name: NSNotification.Name.likedNotification, object: nil, userInfo: ["userID": userID, "postIndex": postIndex])
            coreDataCoordinator.sevePost(post: user.userPosts[index])
        }
        NotificationCenter.default.post(name: NSNotification.Name.reloadPosts, object: nil)
        self.tableView.reloadData()
    }

    // MARK: Notification likes
    @objc func likedNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        for (index, post) in user.userPosts.enumerated() {
            if post.userID == userInfo["userID"] as! String && post.postIndex == userInfo["postIndex"] as! Int {
                user.userPosts[index].likes += 1
                self.tableView.reloadData()
            }
        }
    }

    @objc func turnDownLike(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        for (index, post) in user.userPosts.enumerated() {
            if post.userID == userInfo["userID"] as! String && post.postIndex == userInfo["postIndex"] as! Int {
                user.userPosts[index].likes -= 1
                self.tableView.reloadData()
            }
        }
    }

    @objc func reloadPosts() {
        tableView.reloadData()
    }

    // MARK: Load content
    func loadMore() {
        if !loadMoreStatus  {
            self.loadMoreStatus = true
            let firestoreCoordinator = FirestoreCoordinator()
            firestoreCoordinator.getPost(userID: self.user.userID, postIndex: self.countRow) { post, error in
                guard var post = post else {
                    self.loadMoreStatus = false
                    return}
                post.avatar = self.user.avatar
                post.author = self.user.fullName
                self.user.userPosts.append(post)
                self.countRow += 1
                self.header.layoutSubviews()
                self.loadMoreStatus = false
                self.tableView.reloadData()
            }
        }
    }

    private func loadPhoto () {
        let firestoreCoordinator = FirestoreCoordinator()
        firestoreCoordinator.getImages(user: self.user) { images, error in
            self.user.userPhotos = images
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        header.delegateEditProfile = self
        header.activityView.delegateActivity = self
        title = self.user.nickName
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIElementFactory().addIconButtom(icon: UIImage(systemName: "line.3.horizontal") ?? UIImage(),
                                                                                                         color: .appOrange,
                                                                                                         cornerRadius: 0) {
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIElementFactory().addIconButtom(icon: UIImage(systemName: "arrow.left") ?? UIImage(),
                                                                                                             color: .appOrange,
                                                                                                             cornerRadius: 0) {
            self.coordinator?.pop()
            self.feedCoordinator?.pop()
        })
        loadPhoto()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPosts), name: Notification.Name.reloadPosts, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(likedNotification(notification:)), name: Notification.Name.likedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(turnDownLike(notification:)), name: Notification.Name.turnDownLike, object: nil)
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        if isFriend {
            self.navigationController?.navigationBar.isHidden = false
        } else {
            self.navigationController?.navigationBar.isHidden = true
        }
        let firestoreCoordinator = FirestoreCoordinator()
        firestoreCoordinator.getUser(userID: self.user.userID) { user, error in
            guard let user = user else {return}
            self.header.setProfileHeader(nickName: user.nickName, name: user.fullName, avatar: user.avatar, profession: user.profession, numberOfPublications: user.numberOfPublications, numberOfScribes: user.numberOfScribes, numberOfSubscriptions: user.numberOfSubscriptions, isFriend: self.isFriend)
            self.tableView.reloadData()
        }
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

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 {
            loadMore()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberRows = 0
        if section == 0 {
            numberRows = 1
        } else {
            numberRows = user.userPosts.count
        }
        return numberRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            var cell: PhotosTableViewCell
            cell = tableView.dequeueReusableCell( withIdentifier: PhotosTableViewCell.identifier, for: indexPath) as! PhotosTableViewCell
            cell.setPhotoCell(userPhotos: self.user.userPhotos)
            cell.contentView.backgroundColor = .backgroundCellColor
            return cell
        } else {
            var cell: PostTableViewCell
            cell = (tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier , for: indexPath) as! PostTableViewCell)
            cell.delegate = self
            cell.setupCell(model: user.userPosts[indexPath.row], autor: user.fullName, avatar: user.avatar)
            cell.updateImageViewConstraint(view.bounds.size)
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            header.setProfileHeader(nickName: user.nickName, name: user.fullName, avatar: user.avatar, profession: user.profession, numberOfPublications: user.numberOfPublications, numberOfScribes: user.numberOfScribes, numberOfSubscriptions: user.numberOfSubscriptions, isFriend: self.isFriend)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if isFriend {
                return 250
            } else  {
                return 360
            }
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var autiHeight:CGFloat {
            UITableView.automaticDimension
        }
        return autiHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            coordinator?.photoVC(user: self.user, isFriend: isFriend)
            feedCoordinator?.photoVC(user: self.user, isFriend: isFriend)

        } else {
            coordinator?.PostVC(post: self.user.userPosts[indexPath.row], user: self.user)
            feedCoordinator?.PostVC(post: self.user.userPosts[indexPath.row], user: self.user)
        }
    }
}

public extension NSNotification.Name {
    static let reloadPosts = NSNotification.Name("reloadPosts")
    static let turnDownLike = NSNotification.Name("turnDownLike")
    static let likedNotification = NSNotification.Name("likedNotification")
}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.user.numberOfPhoto += 1
            self.user.userPhotos.append(image)
            let firestoreCoordinator = FirestoreCoordinator()
            firestoreCoordinator.writeUser(userID: self.user.userID, user: self.user)
            loadPhoto()
        }
        dismiss(animated: true, completion: nil)
    }
}
