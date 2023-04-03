//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Табункин Вадим on 23.03.2022.
//

import UIKit


class PostTableViewCell: UITableViewCell {

    weak var delegate: PostProtocol?
    private var userID: String = ""
    private var postIndex: Int = 0
    private lazy var imageWidthConstraint = postImage.widthAnchor.constraint(equalToConstant: 0)
    private lazy var imageHeightConstraint = postImage.heightAnchor.constraint(equalToConstant: 0)

    private let postAutorAvatar = UIElementFactory().addImage(imageNamed: "",
                                                              cornerRadius: 30,
                                                              borderWidth: 0,
                                                              borderColor: nil,
                                                              clipsToBounds: true,
                                                              contentMode: .scaleToFill,
                                                              tintColor: .none,
                                                              backgroundColor: nil)

    private lazy var postAutor = UIElementFactory().addTextButtom(lable: "", size: 14,
                                                                  titleColor: .textColor,
                                                                  contentHorizontalAlignment: .left) {
        self.delegate?.openProfile(userID: self.userID)
    }

    private let postProfession = UIElementFactory().addRegularTextLable(lable: "Дизайнер",
                                                                        textColor: UIColor(red: 0.495, green: 0.507, blue: 0.512, alpha: 1),
                                                                        textSize: 14,
                                                                        lineHeightMultiple: 1.18,
                                                                        textAlignment: .left)

    private lazy var postImage = UIElementFactory().addImage(imageNamed: "",
                                                             cornerRadius: 10,
                                                             borderWidth: 0,
                                                             borderColor: nil,
                                                             clipsToBounds: true,
                                                             contentMode: .scaleAspectFit,
                                                             tintColor: .none,
                                                             backgroundColor: UIColor(red: 0.962, green: 0.951, blue: 0.934, alpha: 1))

    private let postDescription = UIElementFactory().addRegularTextLable(lable: "",
                                                                         textColor: UIColor.textColor,
                                                                         textSize: 14,
                                                                         lineHeightMultiple: 1.18,
                                                                         textAlignment: .left)


    private lazy var logoLike = UIElementFactory().addIconButtom(icon: UIImage(systemName: "heart")!, color: .mutedTextColor, cornerRadius: 0) {
        self.delegate?.liked(userID: self.userID, postIndex: self.postIndex)
    }

    private let postLike = UIElementFactory().addRegularTextLable(lable: "",
                                                                  textColor: .mutedTextColor,
                                                                  textSize: 14,
                                                                  lineHeightMultiple: 1.18,
                                                                  textAlignment: .center)

    private let logoComments = UIElementFactory().addImage(imageNamed: "message",
                                                           cornerRadius: 0,
                                                           borderWidth: 0,
                                                           borderColor: nil,
                                                           clipsToBounds: false,
                                                           contentMode: .scaleToFill,
                                                           tintColor: UIColor.mutedTextColor,
                                                           backgroundColor: .none)

    private let postComments = UIElementFactory().addRegularTextLable(lable: "",
                                                                      textColor: UIColor.mutedTextColor,
                                                                      textSize: 14,
                                                                      lineHeightMultiple: 1.18,
                                                                      textAlignment: .right)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell (model:Post, autor: String, avatar: UIImage) {
        userID = model.userID
        postIndex = model.postIndex
        postAutor.setTitle(autor, for: .normal)
        postAutorAvatar.image = avatar
        postImage.image = model.image
        postDescription.text = model.description
        postLike.text = "\(model.likes)"
        postComments.text = "\(model.comments)"
        contentView.backgroundColor = .backgroundCellColor
        let coreDataCoordinator = CoreDataCoordinator()
        let indexFavoritePost = coreDataCoordinator.findPost(userID: model.userID, postIndex: model.postIndex)
        if indexFavoritePost != nil{
            logoLike.tintColor = .red
        } else {
            logoLike.tintColor = .mutedTextColor
        }
    }

    func updateImageViewConstraint(_ size: CGSize? = nil) {
        guard let image = postImage.image else {
            imageHeightConstraint.constant = 0
            imageWidthConstraint.constant = 0
            return
        }
        let size = size ?? contentView.bounds.size
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

    private func layout() {

        contentView.addSubviews(postAutorAvatar, postAutor, postProfession, postImage, postDescription, logoLike, postLike, logoComments, postComments)//, favoriteMark)
        
        NSLayoutConstraint.activate([
            postAutorAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            postAutorAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postAutorAvatar.widthAnchor.constraint(equalToConstant: 60),
            postAutorAvatar.heightAnchor.constraint(equalToConstant: 60)
        ])

        NSLayoutConstraint.activate([
            postAutor.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            postAutor.leadingAnchor.constraint(equalTo: postAutorAvatar.trailingAnchor, constant: 25),
            postAutor.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])

        NSLayoutConstraint.activate([
            postProfession.topAnchor.constraint(equalTo: postAutor.bottomAnchor, constant: 3),
            postProfession.leadingAnchor.constraint(equalTo: postAutorAvatar.trailingAnchor, constant: 25),
            postProfession.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])

        NSLayoutConstraint.activate([
            postDescription.topAnchor.constraint(equalTo: postAutorAvatar.bottomAnchor, constant: 22),
            postDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            postDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])

        NSLayoutConstraint.activate([
            postImage.topAnchor.constraint(equalTo: postDescription.bottomAnchor, constant: 15),
            postImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageWidthConstraint,
            imageHeightConstraint
        ])

        NSLayoutConstraint.activate([
            logoLike.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 15),
            logoLike.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            logoLike.widthAnchor.constraint(equalToConstant: 24),
            logoLike.heightAnchor.constraint(equalToConstant: 24)
        ])

        NSLayoutConstraint.activate([
            postLike.centerYAnchor.constraint(equalTo: logoLike.centerYAnchor),
            postLike.leadingAnchor.constraint(equalTo: logoLike.trailingAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
            logoComments.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 15),
            logoComments.leadingAnchor.constraint(equalTo: postLike.trailingAnchor, constant: 24),
            logoComments.widthAnchor.constraint(equalToConstant: 24),
            logoComments.heightAnchor.constraint(equalToConstant: 24)
        ])

        NSLayoutConstraint.activate([
            postComments.centerYAnchor.constraint(equalTo: logoComments.centerYAnchor),
            postComments.leadingAnchor.constraint(equalTo: logoComments.trailingAnchor, constant: 10),
            postComments.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
}

