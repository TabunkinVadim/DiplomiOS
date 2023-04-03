//
//  NewPostViewController.swift
//  Vk
//
//  Created by Табункин Вадим on 16.02.2023.
//

import UIKit
import FirebaseAuth
import Firebase

class NewPostViewController: UIViewController, UIGestureRecognizerDelegate  {

    weak var coordinator: ProfileCoordinator?
    private var post: Post
    private var user: User

    private lazy var imageWidthConstraint = postButtom.widthAnchor.constraint(equalToConstant: 0)
    private lazy var imageHeightConstraint = postButtom.heightAnchor.constraint(equalToConstant: 0)

    private let scrollView: UIScrollView = {
        $0.toAutoLayout()
        return $0
    }(UIScrollView())

    private lazy var exitButtom = UIElementFactory().addImageButton(image: UIImage(named: "exitButtom") ,
                                                                    cornerRadius: 0,
                                                                    borderWidth: 0,
                                                                    borderColor: nil) {
        self.coordinator?.navigationController.popViewController(animated: true)
    }

    private let newPostLable = UIElementFactory().addMediumTextLable(lable: "newPost".localized,
                                                                     textColor: .textColor,
                                                                     textSize: 16,
                                                                     lineHeightMultiple: 1.24,
                                                                     textAlignment: .center)

    private lazy var okButtom = UIElementFactory().addImageButton(image: UIImage(named: "okButtom"),
                                                                  cornerRadius: 0,
                                                                  borderWidth: 0,
                                                                  borderColor: nil) {

        self.post.description = self.descriptionPostTextView.text!
        self.user.userPosts.append(self.post)
        for index in 0 ... self.user.userPosts.count - 1 {
            self.user.userPosts[index].postIndex = index
        }
        self.user.numberOfPublications += 1
        guard let userAuth = Auth.auth().currentUser else  { return }
        let firestoreCoordinator = FirestoreCoordinator()
        firestoreCoordinator.writeUser(userID: self.user.userID, user: self.user)
        firestoreCoordinator.getUser(userID: self.user.userID) { user, error in
            self.coordinator?.navigationController.popViewController(animated: true)
        }
    }

    private lazy var postButtom = UIElementFactory().addIconButtom(icon: UIImage(systemName: "plus.circle.fill")!,
                                                                   color: .appOrange,
                                                                   cornerRadius: 10,
                                                                   action: {
        let photoPicer: UIImagePickerController = {
            $0.delegate = self
            return $0
        }(UIImagePickerController())
        self.present(photoPicer, animated: true, completion: nil)
    })

    private let descriptionLable = UIElementFactory().addMediumTextLable(lable: "description".localized,
                                                                         textColor: .textColor,
                                                                         textSize: 16,
                                                                         lineHeightMultiple: 1.03,
                                                                         textAlignment: .left)

    private lazy var descriptionPostTextView = UIElementFactory().addTextView(textAlignment: .left,
                                                                              delegate: nil)

    init(user: User) {
        self.user = user
        self.post = Post(userID: user.userID, postIndex: 0, avatar: user.avatar, author: user.fullName, image: UIImage(systemName: "pencil.and.ellipsis.rectangle")!, description: "", likes: 0, views: 0)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        self.scrollView.addGestureRecognizer(tap)
        updateImageViewConstraint()
        layout()
    }

    private func layout() {
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        scrollView.addSubviews(exitButtom, newPostLable, okButtom, postButtom,descriptionLable, descriptionPostTextView)

        NSLayoutConstraint.activate([
            exitButtom.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            exitButtom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            exitButtom.widthAnchor.constraint(equalToConstant: 24),
            exitButtom.heightAnchor.constraint(equalToConstant: 24)
        ])

        NSLayoutConstraint.activate([
            newPostLable.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            newPostLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newPostLable.widthAnchor.constraint(equalToConstant: 185),
            newPostLable.heightAnchor.constraint(equalToConstant: 24)
        ])

        NSLayoutConstraint.activate([
            okButtom.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            okButtom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            okButtom.widthAnchor.constraint(equalToConstant: 24),
            okButtom.heightAnchor.constraint(equalToConstant: 24)
        ])

        NSLayoutConstraint.activate([
            postButtom.topAnchor.constraint(equalTo: newPostLable.bottomAnchor, constant: 10),
            postButtom.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageWidthConstraint,
            imageHeightConstraint
        ])

        NSLayoutConstraint.activate([
            descriptionLable.topAnchor.constraint(equalTo: postButtom.bottomAnchor, constant: 10),
            descriptionLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLable.widthAnchor.constraint(equalToConstant: 200),
            descriptionLable.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            descriptionPostTextView.topAnchor.constraint(equalTo: descriptionLable.bottomAnchor, constant: 29),
            descriptionPostTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionPostTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionPostTextView.heightAnchor.constraint(equalToConstant: 150),
            descriptionPostTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20)
        ])
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc func hideKeyboardOnSwipeDown() {
        post.description = descriptionPostTextView.text!
        view.endEditing(true)
    }

    func updateImageViewConstraint(_ size: CGSize? = nil) {
        guard let image = postButtom.image(for: .normal) else {
            imageHeightConstraint.constant = 0
            imageWidthConstraint.constant = 0
            return
        }
        let size = size ?? view.bounds.size
        let maxSize = CGSize(width: size.width - 30, height: size.height)
        let imageSize = findBestImageSize(img: image, maxSize: maxSize)
        imageHeightConstraint.constant = imageSize.height
        imageWidthConstraint.constant = imageSize.width
    }

    private func findBestImageSize(img: UIImage, maxSize: CGSize) -> CGSize {
        let isLanscape = UIDevice.current.orientation.isLandscape
        if isLanscape {
            let width = img.width(height: maxSize.height)
            let checkedWidth = min(width, maxSize.width)
            let height = img.height(width: checkedWidth)
            return CGSize(width: checkedWidth, height: height)
        } else {
            let height = img.height(width: maxSize.width)
            let checkedHeight = min(height, maxSize.height)
            let width = img.width(height: checkedHeight)
            return CGSize(width: width, height: checkedHeight)
        }
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

    // Изменение отступов при появлении клавиатуры
    @objc private func kbdShow(notification: NSNotification) {
        let screenHeit = UIScreen.main.bounds.height
        let descriptionHeit = self.descriptionPostTextView.frame.maxY
        if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let offset = (screenHeit - kbdSize.height) - descriptionHeit
            if descriptionPostTextView.isFirstResponder, offset < 0 {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: -offset + 100), animated: true)
            }
            scrollView.contentInset.bottom = kbdSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbdSize.height, right: 0)
        }
    }

    @objc private func kbdHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}

extension NewPostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            postButtom.setImage(image, for: .normal)
            post.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

