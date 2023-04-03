//
//  CommentTableViewCell.swift
//  Vk
//
//  Created by Табункин Вадим on 24.03.2023.
//

import UIKit


class CommentTableViewCell: UITableViewCell  {
    private let postAutorAvatar = UIElementFactory().addImage(imageNamed: "logo",
                                                              cornerRadius: 8,
                                                              borderWidth: 0,
                                                              borderColor: nil,
                                                              clipsToBounds: true,
                                                              contentMode: .scaleToFill,
                                                              tintColor: .none,
                                                              backgroundColor: nil)

    private let postAutor = UIElementFactory().addTextButtom(lable: "", size: 12,
                                                             titleColor: .appOrange,
                                                             contentHorizontalAlignment: .left) {
        print("postAutor")
    }

    private let postLike = UIElementFactory().addIconButtom(icon: UIImage(systemName: "heart")!,
                                                            color: .mutedTextColor,
                                                            cornerRadius: 0) {
        print("Like comment")
    }

    private var postLikeCount = UIElementFactory().addRegularTextLable(lable: "0",
                                                                       textColor: .mutedTextColor,
                                                                       textSize: 12,
                                                                       lineHeightMultiple: 1.18,
                                                                       textAlignment: .left)

    private let postComment = UIElementFactory().addRegularTextLable(lable: "",
                                                                     textColor: .mutedTextColor,
                                                                     textSize: 12,
                                                                     lineHeightMultiple: 1.18,
                                                                     textAlignment: .left)

    private let postDate = UIElementFactory().addRegularTextLable(lable: "",
                                                                  textColor: UIColor(red: 0.767, green: 0.792, blue: 0.804, alpha: 1),
                                                                  textSize: 12,
                                                                  lineHeightMultiple: 1.18,
                                                                  textAlignment: .left)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setComment(postAutorAvatar: UIImage, postAutor: String, postLikeCount: Int, postComment: String, postDate: String ) {
        contentView.backgroundColor = .backgroundCellColor
        self.postAutorAvatar.image = postAutorAvatar
        self.postAutor.setTitle(postAutor, for: .normal)
        self.postLikeCount.text = String(postLikeCount)
        self.postComment.text = postComment
        self.postDate.text = postDate
    }

    private func layout() {

        contentView.addSubviews(postAutorAvatar, postAutor, postLike, postLikeCount, postComment,postDate)

        NSLayoutConstraint.activate([
            postAutorAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            postAutorAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postAutorAvatar.heightAnchor.constraint(equalToConstant: 16),
            postAutorAvatar.widthAnchor.constraint(equalToConstant: 16)
        ])

        NSLayoutConstraint.activate([
            postAutor.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            postAutor.leadingAnchor.constraint(equalTo: postAutorAvatar.trailingAnchor, constant: 7),
            postAutor.trailingAnchor.constraint(equalTo: postLike.leadingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            postLike.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            postLike.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -42),
            postLike.heightAnchor.constraint(equalToConstant: 16),
            postLike.widthAnchor.constraint(equalToConstant: 16)
        ])

        NSLayoutConstraint.activate([
            postLikeCount.centerYAnchor.constraint(equalTo: postLike.centerYAnchor),
            postLikeCount.leadingAnchor.constraint(equalTo: postLike.trailingAnchor, constant: 4),
        ])


        NSLayoutConstraint.activate([
            postComment.topAnchor.constraint(equalTo: postAutor.bottomAnchor, constant: 4),
            postComment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 38),
            postComment.trailingAnchor.constraint(equalTo: postLike.leadingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            postDate.topAnchor.constraint(equalTo: postComment.bottomAnchor, constant: 4),
            postDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 38),
            postDate.trailingAnchor.constraint(equalTo: postLike.leadingAnchor, constant: -10),
            postDate.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
}
