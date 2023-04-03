//
//  HistoryCollectionCell.swift
//  Vk
//
//  Created by Табункин Вадим on 13.11.2022.
//

import UIKit


class HistoryCollectionCell: UICollectionViewCell {
    var imageView: UIImageView =  {
        $0.toAutoLayout()
        $0.backgroundColor = .backgroundColor
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        contentView.backgroundColor = .systemGray
        contentView.layer.cornerRadius = 30
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0.965, green: 0.592, blue: 0.027, alpha: 1).cgColor
        contentView.clipsToBounds = true
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
