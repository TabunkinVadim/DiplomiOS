//
//  StartViewController.swift
//  Vk
//
//  Created by Табункин Вадим on 11.11.2022.
//

import UIKit


class StartViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    
    private let startAppImage = UIElementFactory().addImage(imageNamed: "appImage",
                                                            cornerRadius: 0,
                                                            borderWidth: 0,
                                                            borderColor: nil,
                                                            clipsToBounds: false,
                                                            contentMode: .scaleToFill,
                                                            tintColor: .none,
                                                            backgroundColor: .none)

    private lazy var startRegistrationButtom = UIElementFactory().addBigButtom(lable: "startRegistration".localized,
                                                                               backgroundColor: .buttomColor) {
        self.coordinator?.registerVC()
    }

    private lazy var startLoginButtom = UIElementFactory().addTextButtom(lable: "startLogin".localized, size: 14,
                                                                         titleColor: .textColor, contentHorizontalAlignment: .center) {
        self.coordinator?.inputVC()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }

    private func layout() {

        view.addSubviews(startAppImage, startRegistrationButtom, startLoginButtom)

        NSLayoutConstraint.activate([
            startAppImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -110),
            startAppImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startAppImage.widthAnchor.constraint(equalToConstant: 344),
            startAppImage.heightAnchor.constraint(equalToConstant: 344)
        ])

        NSLayoutConstraint.activate([
            startRegistrationButtom.topAnchor.constraint(equalTo: startAppImage.bottomAnchor, constant: 80),
            startRegistrationButtom.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startRegistrationButtom.widthAnchor.constraint(equalToConstant: 261),
            startRegistrationButtom.heightAnchor.constraint(equalToConstant: 47)
        ])

        NSLayoutConstraint.activate([
            startLoginButtom.topAnchor.constraint(equalTo: startRegistrationButtom.bottomAnchor, constant: 30),
            startLoginButtom.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startLoginButtom.widthAnchor.constraint(equalToConstant: 118),
            startLoginButtom.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
