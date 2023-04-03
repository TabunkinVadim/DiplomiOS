//
//  FeedHeaderView.swift
//  Vk
//
//  Created by Табункин Вадим on 14.11.2022.
//

import UIKit


class FeedHeaderView:UITableViewHeaderFooterView  {
    private let date = "22 июня"

    private lazy var dateLable = UIElementFactory().addRegularTextLable(lable: date,
                                                              textColor: UIColor(red: 0.495, green: 0.507, blue: 0.512, alpha: 1),
                                                              textSize: 14,
                                                              lineHeightMultiple: 1.18,
                                                                        textAlignment: .center)

    override func layoutSubviews() {
        super .layoutSubviews()

        contentView.addSubviews(dateLable)

        NSLayoutConstraint.activate([
            dateLable.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dateLable.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
