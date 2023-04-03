//
//  PostViewController.swift
//  Navigation
//
//  Created by Табункин Вадим on 03.03.2022.
//

import UIKit


class PostViewController: UIViewController, PostProtocol, UIGestureRecognizerDelegate {

    weak var coordinator: Coordinator?
    private let user: User
    private  var countRow = 0
    private var loadMoreStatus = false
    private var commentArray: [Comment] = []
    private var post: Post
    
    private lazy var tableView: UITableView = {
        $0.toAutoLayout()
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .backgroundColor
        $0.register(CommentFooterView.self, forHeaderFooterViewReuseIdentifier: CommentFooterView.identifier)
        $0.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        $0.register(CommentCountTableViewCell.self, forCellReuseIdentifier: CommentCountTableViewCell.identifier)
        return $0
    }(UITableView(frame: .zero, style: .plain))

    init(post: Post, user: User) {
        self.post = post
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            if post.userID == userInfo["userID"] as! String && post.postIndex == userInfo["postIndex"] as! Int {
                post.likes += 1
                self.tableView.reloadData()
            }
    }

    @objc func turnDownLike(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
            if post.userID == userInfo["userID"] as! String && post.postIndex == userInfo["postIndex"] as! Int {
                post.likes -= 1
                self.tableView.reloadData()
        }
    }

    @objc func reloadPosts() {
        tableView.reloadData()
    }


    // MARK: Load content
    private func loadMore() {
        if !loadMoreStatus  {
            self.loadMoreStatus = true
            let firestoreCoordinator = FirestoreCoordinator()
            firestoreCoordinator.getComment(post: self.post, commentIndex: self.countRow) { comment, error in
                guard let comment = comment else {
                    self.loadMoreStatus = false
                    return}
                self.commentArray.append(comment)
                self.countRow += 1
                self.loadMoreStatus = false
                self.tableView.reloadData()
            }
        }
    }


    func writeComment(post: Post, commentIndex: Int, user: User, comment: Comment) {
        self.post.comments += 1
        let firestoreCoordinator = FirestoreCoordinator()
        firestoreCoordinator.writePost(post: self.post)
        firestoreCoordinator.writeComment(post: post, commentIndex: commentIndex, comment: comment)
        firestoreCoordinator.getPost(userID: post.userID, postIndex: post.postIndex) { post, error in
            guard let post = post else {return}
            self.post = post
            self.tableView.reloadData()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        self.tableView.addGestureRecognizer(tap)
        view.backgroundColor = .lightGray
        title = "Publication".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIElementFactory().addIconButtom(icon: UIImage(systemName: "line.3.horizontal") ?? UIImage(),
                                                                                                         color: .appOrange,
                                                                                                         cornerRadius: 0) {
            print("More")
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIElementFactory().addIconButtom(icon: UIImage(systemName: "arrow.left") ?? UIImage(),
                                                                                                             color: .appOrange,
                                                                                                             cornerRadius: 0) {
            self.coordinator?.pop()
        })

        NotificationCenter.default.addObserver(self, selector: #selector(reloadPosts), name: Notification.Name.reloadPosts, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(likedNotification(notification:)), name: Notification.Name.likedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(turnDownLike(notification:)), name: Notification.Name.turnDownLike, object: nil)
        layout()
    }

    private func layout() {

        view.addSubviews(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // подписаться на уведомления
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(kbdShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(kbdHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // отписаться от уведомлений
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }

    // Изменение отступов при появлении клавиатуры
    @objc private func kbdShow(notification: NSNotification) {
        if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset.bottom = kbdSize.height - (self.tabBarController?.tabBar.frame.size.height)!
            tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbdSize.height, right: 0) }
    }

    @objc private func kbdHide(notification: NSNotification) {
        tableView.contentInset.bottom = .zero
        tableView.verticalScrollIndicatorInsets = .zero
    }
}

extension PostViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.writeComment(post: self.post, commentIndex: self.post.comments, user: self.user, comment: Comment(avatar: user.avatar, author: user.fullName, comment: textField.text!, commentDate: "\(NSDate())", likeCount: 0))
        view.endEditing(true)
        return true
    }
}

extension PostViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 {
            loadMore()
        }
    }
}

extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2 + self.commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            var cell: PostTableViewCell
            cell = (tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier , for: indexPath) as! PostTableViewCell)
            cell.delegate = self
            cell.setupCell(model: self.post, autor: self.post.author, avatar: self.post.avatar)
            cell.updateImageViewConstraint(view.bounds.size)
            return cell
        } else  if (indexPath.row == 1) {
            var cell: CommentCountTableViewCell
            cell = tableView.dequeueReusableCell(withIdentifier: CommentCountTableViewCell.identifier, for: indexPath) as! CommentCountTableViewCell
            cell.setCommentsCount(commentsCount: self.post.comments)
            return cell
        } else {
            let cell: CommentTableViewCell
            cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
            cell.setComment(postAutorAvatar: self.commentArray[indexPath.row - 2].avatar,
                            postAutor: self.commentArray[indexPath.row - 2].author,
                            postLikeCount: self.commentArray[indexPath.row - 2].likeCount,
                            postComment: self.commentArray[indexPath.row - 2].comment,
                            postDate: self.commentArray[indexPath.row - 2].commentDate)
            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return CommentFooterView(reuseIdentifier: CommentFooterView.identifier, delegate: self)
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        48
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var autiHeight:CGFloat {
            UITableView.automaticDimension
        }
        return autiHeight
    }

}
