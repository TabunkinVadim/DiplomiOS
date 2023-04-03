//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Табункин Вадим on 03.04.2022.
//

import UIKit


class PhotosViewController: UIViewController {

    weak var coordinator: ProfileCoordinator?
    weak var feedCoordinator: FeedCoordinator?
    private var isFriend: Bool
    private var user: User
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame:.zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .none
        collection.register(ProfilePhotoCollectionViewCell.self, forCellWithReuseIdentifier: ProfilePhotoCollectionViewCell.identifier)
        collection.toAutoLayout()
        return collection
    }()

    private var userPhotos: [UIImage] = []

    init (user: User, isFriend: Bool) {
        self.user = user
        self.isFriend = isFriend
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Load content
    private func loadPhoto () {
        let firestoreCoordinator = FirestoreCoordinator()
        firestoreCoordinator.getImages(user: self.user) { images, error in
            self.userPhotos = images
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .backgroundColor
        title = "PhotoGallery".localized

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIElementFactory().addIconButtom(icon: UIImage(systemName: "plus") ?? UIImage(),
                                                                                                         color: .appOrange,
                                                                                                         cornerRadius: 0) {
            let photoPicer: UIImagePickerController = {
                $0.delegate = self
                return $0
            }(UIImagePickerController())
            self.present(photoPicer, animated: true, completion: nil)
            
        })
        if isFriend {
            navigationItem.rightBarButtonItem?.customView?.isHidden = true
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIElementFactory().addIconButtom(icon: UIImage(systemName: "arrow.left") ?? UIImage(),
                                                                                                             color: .appOrange,
                                                                                                             cornerRadius: 0) {
            self.coordinator?.pop()
            self.feedCoordinator?.pop()
        })
        super.viewDidLoad()
        loadPhoto()
        layout()
    }

    func layout() {
        view.addSubviews(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PhotosViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    static var indent:CGFloat  {
        8
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.userPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfilePhotoCollectionViewCell.identifier, for: indexPath) as! ProfilePhotoCollectionViewCell
        cell.imageView.image = userPhotos[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 4 * PhotosViewController.indent) / 3
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        PhotosViewController.indent
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: PhotosViewController.indent, left: PhotosViewController.indent, bottom: PhotosViewController.indent, right: PhotosViewController.indent)
    }
}

extension PhotosViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
