//
//  CommentCountTableViewCell.swift
//  Vk
//
//  Created by Табункин Вадим on 22.03.2023.
//

import UIKit


class CommentCountTableViewCell: UITableViewCell  {
    private let publicationLable = UIElementFactory().addMediumTextLable(lable: 0.localizedCommentsCount,
                                                                         textColor: .mutedTextColor,
                                                                         textSize: 14,
                                                                         lineHeightMultiple: 1.18,
                                                                         textAlignment: .left)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCommentsCount(commentsCount: Int) {
        contentView.backgroundColor = .backgroundCellColor
        publicationLable.text = commentsCount.localizedCommentsCount
    }

    private func layout() {

        contentView.addSubviews(publicationLable)

        NSLayoutConstraint.activate([
            publicationLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            publicationLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
        ])
    }
}
