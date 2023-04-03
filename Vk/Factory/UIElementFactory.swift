//
//  UIElementFactory.swift
//  Vk
//
//  Created by Табункин Вадим on 12.11.2022.
//

import UIKit
import FlagPhoneNumber


class UIElementFactory {

    func addImage(imageNamed: String,cornerRadius: CGFloat,borderWidth: CGFloat, borderColor: CGColor?, clipsToBounds: Bool, contentMode: UIView.ContentMode,tintColor: UIColor?, backgroundColor: UIColor? ) -> UIImageView {
        return {
            $0.toAutoLayout()
            $0.layer.cornerRadius = cornerRadius
            $0.layer.borderWidth = borderWidth
            $0.layer.borderColor =  borderColor
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

    func addImageButton(image: UIImage?, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor?, action: @escaping () ->Void) -> UIButton {
        return {
            $0.toAutoLayout()
            $0.setImage(image, for: .normal)
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
            $0.layer.cornerRadius = cornerRadius
            $0.layer.borderWidth = borderWidth
            $0.layer.borderColor =  borderColor
            $0.layer.masksToBounds = true
            $0.addAction(UIAction(handler: { _ in
                action()
            }) , for: .touchUpInside)
            return $0
        }(UIButton())
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

    func addIconButtom(icon: UIImage, color: UIColor, cornerRadius: CGFloat, action: @escaping () -> Void) -> UIButton {
        return {
            $0.toAutoLayout()
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
            $0.tintColor = color
            $0.setImage(icon, for: .normal)
            $0.layer.cornerRadius = cornerRadius
            $0.layer.masksToBounds = true
            $0.addAction(UIAction(handler: { _ in
                action()
            }) , for: .touchUpInside)
            return $0
        }(UIButton())
    }

    func addTextButtom(lable: String?,size: CGFloat, titleColor: UIColor, contentHorizontalAlignment: UIControl.ContentHorizontalAlignment, action: @escaping () -> Void) -> UIButton {
        return {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.18
            $0.toAutoLayout()
            $0.setAttributedTitle(NSMutableAttributedString(string: lable!, attributes: [NSAttributedString.Key.kern: -0.17, NSAttributedString.Key.paragraphStyle: paragraphStyle]), for: .normal)
            $0.titleLabel?.font = UIFont(name: "Inter-Regular", size: size)
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

    func addTextField(placeholdertext: String?, textAlignment: NSTextAlignment, delegate: UITextFieldDelegate?) -> UITextField {
        return {
            $0.toAutoLayout()
            $0.delegate = delegate
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: $0.frame.height))
            $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: $0.frame.height))
            $0.leftViewMode = .always
            $0.rightViewMode = .always
            $0.placeholder = placeholdertext
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(red: 0.149, green: 0.196, blue: 0.22, alpha: 1).cgColor
            $0.font = UIFont(name: "Inter-Medium", size: 16)
            $0.textAlignment = textAlignment
            return $0
        }(UITextField())
    }

    func addListController (countryRepository: FPNCountryRepository, title: String) -> FPNCountryListViewController {
        return {
            $0.setup(repository: countryRepository)
            $0.title = title
            $0.didSelect = { country in
            }
            return $0
        }(FPNCountryListViewController(style: .grouped))
    }

    func addNumberTextField( delegate: UITextFieldDelegate?) -> FPNTextField {
        return {
            $0.toAutoLayout()
            $0.delegate = delegate
            $0.displayMode = .list
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(red: 0.149, green: 0.196, blue: 0.22, alpha: 1).cgColor
            $0.font = UIFont(name: "Inter-Medium", size: 16)
            return $0
        }(FPNTextField())
    }

    func addTextView (textAlignment: NSTextAlignment, delegate: UITextViewDelegate?) -> UITextView {
        return {
            $0.toAutoLayout()
            $0.delegate = delegate
            $0.backgroundColor = UIColor(red: 0.961, green: 0.953, blue: 0.933, alpha: 1)
            $0.layer.cornerRadius = 10
            $0.font = UIFont(name: "Inter-Medium", size: 16)
            $0.textAlignment = textAlignment
            return $0
        }(UITextView())
    }

    func addFeedTable(dataSource: UITableViewDataSource?, delegate: UITableViewDelegate?) -> UITableView {
        return {
            $0.toAutoLayout()
            $0.dataSource = dataSource
            $0.delegate = delegate
            $0.backgroundColor = .backgroundColor
            $0.register(UpperFeedHeaderView.self, forHeaderFooterViewReuseIdentifier: UpperFeedHeaderView.identifier)
            $0.register(FeedHeaderView.self, forHeaderFooterViewReuseIdentifier: FeedHeaderView.identifier)
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

    func addChecker( isCheck: Bool, onColor: CGColor, offColor: CGColor, scaleImage: CGFloat, cornerRadius: CGFloat, onAction: @escaping () -> Void, offAction: @escaping () -> Void) -> RadioButton {
        return {
            return $0
        }(RadioButton( isCheck: isCheck, onColor: onColor, offColor: offColor, scaleImage: scaleImage, cornerRadius: cornerRadius, onAction: onAction, offAction: offAction))
    }
}
