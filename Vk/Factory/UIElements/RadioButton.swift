//
//  RadioButton.swift
//  Vk
//
//  Created by Табункин Вадим on 07.02.2023.
//

import UIKit


class RadioButton: UIButton {
    var alternateButton:Array<RadioButton>?
    private var onColor: CGColor
    private var offColor: CGColor
    private var onAction: () -> Void
    private var offAction: () -> Void

    init (isCheck: Bool, onColor: CGColor, offColor: CGColor, scaleImage: CGFloat, cornerRadius: CGFloat, onAction: @escaping () -> Void, offAction: @escaping () -> Void) {

        self.onColor = onColor
        self.offColor = offColor
        self.onAction = onAction
        self.offAction = offAction
        super.init(frame: CGRect())
        self.isSelected = isCheck
        layer.borderWidth = 1
        self.contentVerticalAlignment = .center
        self.contentHorizontalAlignment = .center
        self.imageView?.layer.transform = CATransform3DMakeScale(scaleImage, scaleImage, scaleImage)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        toAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func unselectAlternateButtons() {
        if alternateButton != nil {
            self.isSelected = true
            for aButton:RadioButton in alternateButton! {
                aButton.isSelected = false
            }
        } else {
            toggleButton()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }

    func toggleButton() {
        self.isSelected = !isSelected
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                setImage(UIImage(systemName: "circle.fill"), for: .normal)
                imageView?.tintColor = UIColor(cgColor: onColor)
                self.layer.borderColor = onColor
                onAction()
            } else {
                setImage(nil, for: .normal)
                self.layer.borderColor = offColor
                offAction()
            }
        }
    }
}
