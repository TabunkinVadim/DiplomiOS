//
//  FeedViewController.swift
//  Navigation
//
//  Created by Табункин Вадим on 03.03.2022.
//
import StorageService
import UIKit

class FeedViewController: UIViewController, LikedProtocol {

    

    var upperHeader: UpperFeedHeaderView = UpperFeedHeaderView(reuseIdentifier: UpperFeedHeaderView.identifier)
    var heder:FeedHeaderView = FeedHeaderView (reuseIdentifier: FeedHeaderView.identifier)
    var personalPosts: [Post] = posts
    private var index: Int = 0
    private lazy var tableView = UIElementFactory().addFeedTable(dataSource: self, delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPosts), name: Notification.Name.reloadPosts, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(likedNotification), name: Notification.Name.likedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(turnDownLike), name: Notification.Name.turnDownLike, object: nil)
//        header.delegateClose = self
        layout()
    }

    @objc func reloadPosts() {
        tableView.reloadData()
    }
    @objc func turnDownLike() {
        personalPosts[index].likes -= 1
    }
    @objc func likedNotification() {
        personalPosts[index].likes += 1
    }
    
    func liked(description: String) {
        let coreDataCoordinator = CoreDataCoordinator()
        let index: Int? = {
            for (index, post) in  personalPosts.enumerated()  {
                if post.description == description {
                    return index
                }
            }
            return nil
        }()
        guard let index = index else {
            return
        }

        let indexFavoritPost = coreDataCoordinator.findPost(description: description)
        if let indexFavoritPost = indexFavoritPost {
            NotificationCenter.default.post(name: NSNotification.Name.turnDownLike, object: nil)
            coreDataCoordinator.deletePosts(index: indexFavoritPost)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name.likedNotification, object: nil)
            coreDataCoordinator.sevePost(post: personalPosts[index])
        }
        NotificationCenter.default.post(name: NSNotification.Name.reloadPosts, object: nil)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.tableView.reloadData()
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





    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.navigationController?.navigationBar.isHidden = true
//
//        // подписаться на уведомления
//        let nc = NotificationCenter.default
//        nc.addObserver(self, selector: #selector(kbdShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        nc.addObserver(self, selector: #selector(kbdHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        // отписаться от уведомлений
//        let nc = NotificationCenter.default
//        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    //     Изменение отступов при появлении клавиатуры
//    @objc private func kbdShow(notification: NSNotification) {
//        if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            feedScrollView.contentInset.bottom = kbdSize.height
//            feedScrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbdSize.height, right: 0) }
//    }
//
//    @objc private func kbdHide(notification: NSNotification) {
//        feedScrollView.contentInset.bottom = .zero
//        feedScrollView.verticalScrollIndicatorInsets = .zero
//    }
}

extension FeedViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var autiHeight:CGFloat {
            UITableView.automaticDimension
        }
        return autiHeight
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            navigationController?.pushViewController(PostViewController(), animated: true)
//        if indexPath.section == 0{
////            coordinator?.photoVC()
//        } else {
//            print("\(indexPath)")
            index = indexPath.row
//        }
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
        personalPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PostTableViewCell
        cell = (tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier , for: indexPath) as! PostTableViewCell)
//        cell.delegate = self
        cell.delegate = self
        cell.setupCell(model: self.personalPosts[indexPath.row], set: indexPath.row)
        cell.index = indexPath.row
        cell.updateImageViewConstraint(view.bounds.size)
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tap)
        return cell
    }
    @objc private func doubleTapped() {

        let coreDataCoordinator = CoreDataCoordinator()
        let indexFavoritPost = coreDataCoordinator.findPost(description: personalPosts[index].description)
        if let indexFavoritPost = indexFavoritPost {
            NotificationCenter.default.post(name: NSNotification.Name.turnDownLike, object: nil)
            coreDataCoordinator.deletePosts(index: indexFavoritPost)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name.likedNotification, object: nil)
            coreDataCoordinator.sevePost(post: personalPosts[index])
        }
        NotificationCenter.default.post(name: NSNotification.Name.reloadPosts, object: nil)
    }


}

//
//extension FeedViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        view.endEditing(true)
//        feedModel.chenge(.tapButton(checkModel: checkModel, textField: word))
//        return true
//    }


//}
//
//public extension NSNotification.Name {
//    static let redLable = NSNotification.Name("redLable")
//    static let greenLable = NSNotification.Name("greenLable")
//}
//
//
