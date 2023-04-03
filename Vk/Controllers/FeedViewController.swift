//
//  FeedViewController.swift
//  Navigation
//
//  Created by Табункин Вадим on 03.03.2022.
//

import UIKit


class FeedViewController: UIViewController, PostProtocol {

    weak var coordinator: FeedCoordinator?
    private let user: User
    private var countRow = 0
    private var userNumber = 0
    private var loadMoreStatus = false
    private var refreshControl:UIRefreshControl!
    private var loadUser = User(userID: "", nickname: "", fullName: "", gender: "", dateOfBirth: "", city: "", profession: "", avatar: UIImage(named: "Avatar")!, status: "",numberOfPhoto: 0, numberOfPublications: 0, numberOfScribes: 0, numberOfSubscriptions: 0  )
    private lazy var upperHeader: UpperFeedHeaderView = UpperFeedHeaderView(reuseIdentifier: UpperFeedHeaderView.identifier)
    private var heder:FeedHeaderView = FeedHeaderView (reuseIdentifier: FeedHeaderView.identifier)
    private var feedPosts: [Post] = []
    private lazy var tableView = UIElementFactory().addFeedTable(dataSource: self, delegate: self)

    init (user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Delegate PostProtocol
    func openProfile(userID: String) {
        if user.userID == userID {

        } else {
            let firestoreCoordinator = FirestoreCoordinator()
            firestoreCoordinator.getUser(userID: userID) { user, error in
                guard let user = user else {return}
                self.coordinator?.profileVC(user: user, isFriend: true)
            }
        }
    }

    func liked(userID: String, postIndex: Int) {
        let coreDataCoordinator = CoreDataCoordinator()
        let index: Int? = {
            for (index, post) in  feedPosts.enumerated()  {
                if post.userID == userID && post.postIndex == postIndex {
                    return index
                }
            }
            return nil
        }()
        guard let index = index else { return }
        let indexFavoritPost = coreDataCoordinator.findPost(userID: userID, postIndex: postIndex)
        if let indexFavoritPost = indexFavoritPost {
            var post = self.feedPosts[index]
            post.likes += 1
            let firestoreCoordinator = FirestoreCoordinator()
            firestoreCoordinator.writePost(post: post)
            NotificationCenter.default.post(name: NSNotification.Name.turnDownLike, object: nil, userInfo: ["userID": userID, "postIndex": postIndex])
            coreDataCoordinator.deletePosts(index: indexFavoritPost)
        } else {
            var post = self.feedPosts[index]
            post.likes += 1
            let firestoreCoordinator = FirestoreCoordinator()
            firestoreCoordinator.writePost(post: post)
            NotificationCenter.default.post(name: NSNotification.Name.likedNotification, object: nil, userInfo: ["userID": userID, "postIndex": postIndex])
            coreDataCoordinator.sevePost(post: feedPosts[index])
        }
        NotificationCenter.default.post(name: NSNotification.Name.reloadPosts, object: nil)
        self.tableView.reloadData()
    }

    // MARK: Notification likes
    @objc func likedNotification(notification:Notification) {
        guard let userInfo = notification.userInfo else {return}
        for (index, post) in feedPosts.enumerated() {
            if post.userID == userInfo["userID"] as! String && post.postIndex == userInfo["postIndex"] as! Int {
                feedPosts[index].likes += 1
                self.tableView.reloadData()
            }
        }
    }

    @objc func turnDownLike(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        for (index, post) in feedPosts.enumerated() {
            if post.userID == userInfo["userID"] as! String && post.postIndex == userInfo["postIndex"] as! Int {
                feedPosts[index].likes -= 1
                self.tableView.reloadData()
            }
        }
    }

    @objc func reloadPosts() {
        tableView.reloadData()
    }

    // MARK: Load content
    @objc func refresh() {
        self.loadMoreStatus = false
        self.upperHeader.reloadStories()
        loadStories()
        countRow = 0
        userNumber = 0
        feedPosts = []
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }

    func loadMore() {
        if !loadMoreStatus  {
            self.loadMoreStatus = true
            let firestoreCoordinator = FirestoreCoordinator()
            firestoreCoordinator.getUsersArray { usersArray, error in
                guard let user = usersArray["user\(self.userNumber)"] else {
                    self.loadMoreStatus = false
                    return}
                firestoreCoordinator.getUser(userID: user) { user, error in
                    guard let user = user else {
                        self.loadMoreStatus = false
                        return
                    }
                    self.loadUser = user
                    firestoreCoordinator.getPost(userID: user.userID, postIndex: self.countRow) { post, error in
                        guard let post = post else {
                            self.userNumber += 1
                            self.countRow = 0
                            self.loadMoreStatus = false
                            return
                        }
                        var newLoadPost = post
                        newLoadPost.avatar = user.avatar
                        newLoadPost.author = user.fullName
                        self.feedPosts.append(newLoadPost)
                        self.countRow += 1
                        self.loadMoreStatus = false
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    func loadStories () {
        if !loadMoreStatus {
            self.loadMoreStatus = true
            let firestoreCoordinator = FirestoreCoordinator()
            firestoreCoordinator.getUsersArray { usersArray, error in
                for i in usersArray {
                    guard let user = usersArray[i.key] else {
                        self.loadMoreStatus = false
                        return
                    }
                    firestoreCoordinator.getUser(userID: user) { user, error in
                        guard let user = user else {
                            self.loadMoreStatus = false
                            return
                        }
                        self.upperHeader.setStories(addAvatar: user.avatar)
                        self.loadMoreStatus = false
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPosts), name: Notification.Name.reloadPosts, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(likedNotification(notification:)), name: Notification.Name.likedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(turnDownLike(notification:)), name: Notification.Name.turnDownLike, object: nil)
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        loadStories()
        loadMore()
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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

extension FeedViewController : UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 {
            loadMore()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var autiHeight:CGFloat {
            UITableView.automaticDimension
        }
        return autiHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.coordinator?.PostVC(post: self.feedPosts[indexPath.row], user: self.user)
    }
}

extension FeedViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 180
            
        } else {
            return 50
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return upperHeader
        } else {
            return FeedHeaderView()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.feedPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PostTableViewCell
        cell = (tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier , for: indexPath) as! PostTableViewCell)
        cell.delegate = self
        cell.setupCell(model: self.feedPosts[indexPath.row], autor: self.feedPosts[indexPath.row].author, avatar: self.feedPosts[indexPath.row].avatar)
        cell.updateImageViewConstraint(view.bounds.size)
        return cell
    }
}
