//
//  InfoViewController.swift
//  Vk
//
//  Created by Табункин Вадим on 01.04.2023.
//

import UIKit


class InfoViewController: UIViewController {

    weak var coordinator: ProfileCoordinator?
    weak var feedCoordinator: FeedCoordinator?
    private let scrollView: UIScrollView = {
        $0.toAutoLayout()
        return $0
    }(UIScrollView())

    private let avatar = UIElementFactory().addImage(imageNamed: "" ,
                                                     cornerRadius: 50,
                                                     borderWidth: 1,
                                                     borderColor: UIColor.appOrange.cgColor,
                                                     clipsToBounds: true,
                                                     contentMode: .scaleToFill,
                                                     tintColor: .appOrange,
                                                     backgroundColor: .none)

    private let nickName = UIElementFactory().addMediumTextLable(lable: "", textColor
                                                                 : .textColor,
                                                                 textSize: 16,
                                                                 lineHeightMultiple: 1.03,
                                                                 textAlignment: .center)

    private let nameTitle = UIElementFactory().addMediumTextLable(lable: "editName".localized,
                                                                  textColor: .mutedTextColor,
                                                                  textSize: 12,
                                                                  lineHeightMultiple: 1.03,
                                                                  textAlignment: .center)

    private let name = UIElementFactory().addMediumTextLable(lable: "",
                                                             textColor: .textColor,
                                                             textSize: 16,
                                                             lineHeightMultiple: 1.03,
                                                             textAlignment: .center)

    private let professionTitle = UIElementFactory().addMediumTextLable(lable: "profession".localized,
                                                                  textColor: .mutedTextColor,
                                                                  textSize: 12,
                                                                  lineHeightMultiple: 1.03,
                                                                  textAlignment: .center)

    private let profession = UIElementFactory().addMediumTextLable(lable: "",
                                                             textColor: .textColor,
                                                             textSize: 16,
                                                             lineHeightMultiple: 1.03,
                                                             textAlignment: .center)

    private let genderTitle = UIElementFactory().addMediumTextLable(lable: "gender".localized,
                                                                    textColor: .mutedTextColor,
                                                                    textSize: 12,
                                                                    lineHeightMultiple: 1.03,
                                                                    textAlignment: .center)

    private let gender = UIElementFactory().addMediumTextLable(lable: "",
                                                               textColor: .textColor,
                                                               textSize: 16,
                                                               lineHeightMultiple: 1.03,
                                                               textAlignment: .center)


    private let dateOfBirthTitle = UIElementFactory().addMediumTextLable(lable: "dataOfBrith".localized,
                                                                         textColor: .mutedTextColor,
                                                                         textSize: 12,
                                                                         lineHeightMultiple: 1.03,
                                                                         textAlignment: .center)


    private let dateOfBirth = UIElementFactory().addMediumTextLable(lable: "",
                                                                    textColor: .textColor,
                                                                    textSize: 16,
                                                                    lineHeightMultiple: 1.03,
                                                                    textAlignment: .center)


    private let cityTitle = UIElementFactory().addMediumTextLable(lable: "city".localized,
                                                                  textColor: .mutedTextColor,
                                                                  textSize: 12,
                                                                  lineHeightMultiple: 1.03,
                                                                  textAlignment: .center)

    private let city = UIElementFactory().addMediumTextLable(lable: "",
                                                             textColor: .textColor,
                                                             textSize: 16,
                                                             lineHeightMultiple: 1.03,
                                                             textAlignment: .center)

    init(user: User) {
        self.avatar.image = user.avatar
        self.nickName.text = user.nickName
        self.name.text = user.fullName
        self.profession.text = user.profession
        self.gender.text = user.gender
        self.dateOfBirth.text = user.dateOfBirth
        self.city.text = user.city

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "basicInformation".localized
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIElementFactory().addIconButtom(icon: UIImage(systemName: "xmark") ?? UIImage(),
                                                                                                             color: .appOrange,
                                                                                                             cornerRadius: 0) {
            self.coordinator?.pop()
            self.feedCoordinator?.pop()
        })
        layout()
    }

    private func layout() {
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        scrollView.addSubviews(avatar, nickName, nameTitle, name, professionTitle, profession, genderTitle, gender, dateOfBirthTitle, dateOfBirth, cityTitle, city)

        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            avatar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 100),
            avatar.heightAnchor.constraint(equalToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            nickName.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 29),
            nickName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nickName.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            nameTitle.topAnchor.constraint(equalTo: nickName.bottomAnchor, constant: 14),
            nameTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTitle.heightAnchor.constraint(equalToConstant: 15)
        ])

        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: nameTitle.bottomAnchor, constant: 6),
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            name.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            professionTitle.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 14),
            professionTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            professionTitle.heightAnchor.constraint(equalToConstant: 15)
        ])

        NSLayoutConstraint.activate([
            profession.topAnchor.constraint(equalTo: professionTitle.bottomAnchor, constant: 6),
            profession.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profession.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            genderTitle.topAnchor.constraint(equalTo: profession.bottomAnchor, constant: 14),
            genderTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            genderTitle.heightAnchor.constraint(equalToConstant: 15 )
        ])

        NSLayoutConstraint.activate([
            gender.topAnchor.constraint(equalTo: genderTitle.bottomAnchor, constant: 6),
            gender.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gender.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            dateOfBirthTitle.topAnchor.constraint(equalTo: gender.bottomAnchor, constant: 34),
            dateOfBirthTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateOfBirthTitle.heightAnchor.constraint(equalToConstant: 15 )
        ])

        NSLayoutConstraint.activate([
            dateOfBirth.topAnchor.constraint(equalTo: dateOfBirthTitle.bottomAnchor, constant: 6),
            dateOfBirth.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateOfBirth.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            cityTitle.topAnchor.constraint(equalTo: dateOfBirth.bottomAnchor, constant: 15),
            cityTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityTitle.heightAnchor.constraint(equalToConstant: 15 )
        ])

        NSLayoutConstraint.activate([
            city.topAnchor.constraint(equalTo: cityTitle.bottomAnchor, constant: 6),
            city.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            city.heightAnchor.constraint(equalToConstant: 40),
            city.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor )
        ])
    }
}
