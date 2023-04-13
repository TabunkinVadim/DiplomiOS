//
//  LaunchScreenViewController.swift
//  Vk
//
//  Created by Табункин Вадим on 05.04.2023.
//

import UIKit


class LaunchScreenViewController: UIViewController {

    weak var coordinator: MainCoordinator?

    private let startAppImage = UIElementFactory().addImage(imageNamed: "appImage",
                                                            cornerRadius: 0,
                                                            borderWidth: 0,
                                                            borderColor: nil,
                                                            clipsToBounds: false,
                                                            contentMode: .scaleToFill,
                                                            tintColor: .none,
                                                            backgroundColor: .none)

    private var loadingLable = UIElementFactory().addMediumTextLable(lable: "Loading".localized, textColor: .textColor, textSize: 20, lineHeightMultiple: 1, textAlignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }

    private func layout() {

        view.addSubviews(startAppImage, loadingLable)

        NSLayoutConstraint.activate([
            startAppImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -110),
            startAppImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startAppImage.widthAnchor.constraint(equalToConstant: 344),
            startAppImage.heightAnchor.constraint(equalToConstant: 344)
        ])

        NSLayoutConstraint.activate([
            loadingLable.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 110),
            loadingLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loadingLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
}
