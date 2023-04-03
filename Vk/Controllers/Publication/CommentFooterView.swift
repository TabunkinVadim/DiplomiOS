//
//  CommentFooterView.swift
//  Vk
//
//  Created by Табункин Вадим on 24.03.2023.
//

import UIKit


class CommentFooterView: UITableViewHeaderFooterView  {
    private let delegate: UITextFieldDelegate?

    private lazy var commentTextField = UIElementFactory().addTextField(placeholdertext: "newComment".localized, textAlignment: .left, delegate: delegate)

    init (reuseIdentifier: String?, delegate: UITextFieldDelegate?) {
        self.delegate = delegate
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()

        contentView.addSubviews(commentTextField)

        NSLayoutConstraint.activate([
            commentTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            commentTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            commentTextField.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            commentTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

