//
//  UIElementFactory.swift
//  Vk
//
//  Created by Табункин Вадим on 12.11.2022.
//

import UIKit
import SwiftUI

class UIElementFactory {

    func addImage(imageNamed: String,cornerRadius: CGFloat, clipsToBounds: Bool, contentMode: UIView.ContentMode,tintColor: UIColor?, backgroundColor: UIColor? ) -> UIImageView {
        return {
            $0.toAutoLayout()
            $0.layer.cornerRadius = cornerRadius
            $0.clipsToBounds = clipsToBounds
            $0.contentMode = contentMode
            $0.tintColor = tintColor
            $0.backgroundColor = backgroundColor
            $0.image = UIImage(named: imageNamed)
            if $0.image == nil{
                $0.image = UIImage(systemName: imageNamed)
            }
            return $0
        }(UIImageView())
    }

    func addBigButtom(lable: String?, backgroundColor: UIColor, action: @escaping () -> Void) -> UIButton {
        return {
            $0.toAutoLayout()
            $0.setAttributedTitle(NSMutableAttributedString(string: lable!, attributes: [NSAttributedString.Key.kern: 0.16]), for: .normal)
            $0.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
            $0.backgroundColor = backgroundColor
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.layer.borderColor =  UIColor.lightGray.cgColor
            $0.layer.masksToBounds = true
            $0.addAction(UIAction(handler: { _ in
                action()
            }) , for: .touchUpInside)
            return $0
        }(UIButton())
    }

    func addIconButtom(icon: UIImage, color: UIColor, action: @escaping () -> Void) -> UIButton {
        return {
            $0.toAutoLayout()
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
            $0.tintColor = color
            $0.setImage(icon, for: .normal)
//            $0.setTitleColor(color, for: .normal)
            $0.addAction(UIAction(handler: { _ in
                action()
            }) , for: .touchUpInside)
            return $0
        }(UIButton())
    }

    func addTextButtom(lable: String?,titleColor: UIColor, contentHorizontalAlignment: UIControl.ContentHorizontalAlignment, action: @escaping () -> Void) -> UIButton {
        return {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.18
            $0.toAutoLayout()
            $0.setAttributedTitle(NSMutableAttributedString(string: lable!, attributes: [NSAttributedString.Key.kern: -0.17, NSAttributedString.Key.paragraphStyle: paragraphStyle]), for: .normal)
            $0.titleLabel?.font = UIFont(name: "Inter-Regular", size: 14)
            $0.backgroundColor = nil
            $0.setTitleColor(titleColor, for: .normal)
            $0.contentHorizontalAlignment = contentHorizontalAlignment
            $0.addAction(UIAction(handler: { _ in
                action()
            }) , for: .touchUpInside)
            return $0
        }(UIButton())
    }

    func addBoldTextLable(lable: String?, textColor: UIColor, textSize: CGFloat, textAlignment: NSTextAlignment) -> UILabel {
        return {
            $0.toAutoLayout()
            $0.numberOfLines = 0
            $0.attributedText = NSMutableAttributedString(string: lable!, attributes: [NSAttributedString.Key.kern: 0.18])
            $0.font = UIFont(name: "Inter-SemiBold", size: textSize)
            $0.textColor = textColor
            $0.textAlignment = textAlignment
            return $0
        }(UILabel())
    }

    func addMediumTextLable(lable: String?, textColor: UIColor, textSize: CGFloat, lineHeightMultiple: CGFloat, textAlignment: NSTextAlignment ) -> UILabel {
        return {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = lineHeightMultiple
            $0.toAutoLayout()
            $0.numberOfLines = 0
            $0.attributedText = NSMutableAttributedString(string: lable!, attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            $0.font = UIFont(name: "Inter-Medium", size: textSize)
            $0.textColor = textColor
            $0.textAlignment = textAlignment
            return $0
        }(UILabel())
    }

    func addRegularTextLable(lable: String?, textColor: UIColor, textSize: CGFloat, lineHeightMultiple: CGFloat, textAlignment: NSTextAlignment) -> UILabel {
        return {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = lineHeightMultiple// 1.18
            $0.toAutoLayout()
            $0.numberOfLines = 0
            $0.attributedText = NSMutableAttributedString(string: lable!,  attributes: [NSAttributedString.Key.kern: 0.12, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            $0.font = UIFont(name: "Inter-Regular", size: textSize)
            $0.textColor = textColor
            $0.textAlignment = textAlignment
            return $0
        }(UILabel())
    }

    func addTextField(placeholdertext: String?) -> UITextField {
        return {
            $0.toAutoLayout()
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: $0.frame.height))
            $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: $0.frame.height))
            $0.leftViewMode = .always
            $0.rightViewMode = .always
            $0.placeholder = placeholdertext
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(red: 0.149, green: 0.196, blue: 0.22, alpha: 1).cgColor
            $0.font = UIFont(name: "Inter-Medium", size: 16)
            $0.textAlignment = .center
            return $0
        }(UITextField())
    }

    func addFeedTable(dataSource: UITableViewDataSource?, delegate: UITableViewDelegate?) -> UITableView {
        return {
            $0.toAutoLayout()
            $0.dataSource = dataSource
            $0.delegate = delegate
            $0.backgroundColor = .backgroundColor
            $0.register(UpperFeedHeaderView.self, forHeaderFooterViewReuseIdentifier: UpperFeedHeaderView.identifier)
            $0.register(FeedHeaderView.self, forHeaderFooterViewReuseIdentifier: FeedHeaderView.identifier)
//                   $0.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.identifier)
            $0.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
            
            return $0
        }(UITableView(frame: .zero, style: .grouped))
    }

    func addStoriesCollectionView(dataSource: UICollectionViewDataSource?, delegate: UICollectionViewDelegate?) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return {
            $0.toAutoLayout()
            $0.dataSource = dataSource
            $0.delegate = delegate
            $0.backgroundColor = .none
            $0.showsHorizontalScrollIndicator = false
            $0.register(HistoryCollectionCell.self, forCellWithReuseIdentifier: HistoryCollectionCell.identifier)
            return $0
        }(UICollectionView(frame: .zero, collectionViewLayout: layout))
    }

}

