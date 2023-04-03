//
//  UIViewExtension.swift
//  Navigation
//
//  Created by Табункин Вадим on 26.03.2022.
//

import UIKit
import SwiftUI


extension UIView {
    static var identifier:String {String(describing: self)}

    func  toAutoLayout () {
        translatesAutoresizingMaskIntoConstraints = false
    }

    func addSubviews(_ subviews: UIView...) {
        subviews.forEach {addSubview($0)}
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

extension Int {
    var localizedCommentsCount: String {
        String (self) + " " + String.localizedStringWithFormat(NSLocalizedString("NumberOfComment", comment: ""), self )
    }

    var localizedLikesCount: String {
        String.localizedStringWithFormat(NSLocalizedString("NumberOfLike", comment: ""), self )
    }

    var localizedPostsCount: String {
        String (self) + "\n" + String.localizedStringWithFormat(NSLocalizedString("NumberOfPost", comment: ""), self )
    }

    var localizedSubscriptionsCount: String {
        String (self) + "\n" + String.localizedStringWithFormat(NSLocalizedString("NumberOfSubscription", comment: ""), self )
    }

    var localizedScribesCount: String {
        String (self) + "\n" + String.localizedStringWithFormat(NSLocalizedString("NumberOfScribe", comment: ""), self )
    }
}

extension UIColor {
    static var backgroundColor: UIColor {
        Self.makeColor(light: .systemGray6, dark: .darkGray)
    }

    static var backgroundCellColor: UIColor {
        Self.makeColor(light: .white, dark: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))
    }

    static var textColor: UIColor {
        Self.makeColor(light: .black, dark: .white)
    }

    static var mutedTextColor: UIColor {
        Self.makeColor(light: UIColor(red: 0.495, green: 0.507, blue: 0.512, alpha: 1), dark: UIColor(red: 0.495, green: 0.507, blue: 0.512, alpha: 1))
    }

    static var appOrange: UIColor {
        Self.makeColor(light: UIColor(red: 1, green: 0.62, blue: 0.271, alpha: 1), dark: UIColor(red: 1, green: 0.62, blue: 0.271, alpha: 1))
    }

    static var appGrey: UIColor {
        Self.makeColor(light: UIColor(red: 0.495, green: 0.507, blue: 0.512, alpha: 1), dark: .white)
    }

    static var delButtomColor: UIColor {
        Self.makeColor(light: #colorLiteral(red: 1, green: 0.4451128062, blue: 0.3478579359, alpha: 1), dark: #colorLiteral(red: 0.5605350417, green: 0.2495013254, blue: 0.1949865626, alpha: 1) )
    }

    static var statusTextColor: UIColor {
        Self.makeColor(light: .systemGray, dark: .secondaryLabel )
    }

    static var borderColor: UIColor {
        Self.makeColor(light: .black, dark: .white )
    }

    static var buttomColor: UIColor {
        Self.makeColor(light: UIColor(red: 0.17, green: 0.223, blue: 0.25, alpha: 1), dark: .systemGray4 )
    }

    private static func makeColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .light, .unspecified:
                    return light
                case .dark:
                    return dark
                @unknown default:
                    assertionFailure("Case is not supported")
                    return light
                }
            }
        } else {
            return light
        }
    }
}

extension UIImage {
    var cropRatio: CGFloat {
        return CGFloat(size.width / size.height)
    }

    func height(width: CGFloat) -> CGFloat {
        return width / self.cropRatio
    }

    func width(height: CGFloat) -> CGFloat {
        return height * self.cropRatio
    }
}

extension UIViewController {

    func createCustomButton(imageName: String, selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName)?.withRenderingMode(.automatic),for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: selector, for: .touchUpInside)
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }
}
