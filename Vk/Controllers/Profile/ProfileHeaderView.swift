//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Табункин Вадим on 13.03.2022.
//

import UIKit


class ProfileHeaderView: UITableViewHeaderFooterView  {

    weak var delegateEditProfile:ProfileViewControllerProtocol?
    private var isFriend: Bool = false

    private var nickName = UIElementFactory().addMediumTextLable(lable: "",
                                                                 textColor: .textColor,
                                                                 textSize: 16,
                                                                 lineHeightMultiple: 1.24,
                                                                 textAlignment: .left)
    
    private var avatar = UIElementFactory().addImage(imageNamed: "Avatar",
                                                     cornerRadius: 30,
                                                     borderWidth: 0,
                                                     borderColor: nil,
                                                     clipsToBounds: true,
                                                     contentMode: .scaleToFill,
                                                     tintColor: .none,
                                                     backgroundColor: .none)

    private let name = UIElementFactory().addBoldTextLable(lable: "", textColor: .textColor,
                                                           textSize: 18,
                                                           textAlignment: .left)

    private var profession = UIElementFactory().addRegularTextLable(lable: "",
                                                                    textColor: .mutedTextColor,
                                                                    textSize: 12,
                                                                    lineHeightMultiple: 1.03,
                                                                    textAlignment: .left)

    private lazy var moreButtom = UIElementFactory().addIconButtom(icon: UIImage(systemName: "line.3.horizontal") ?? UIImage(),
                                                                   color: .appOrange, cornerRadius: 0) {
        print("More")
    }

    private let infoIcon = UIElementFactory().addImage(imageNamed: "exclamationmark.circle.fill",
                                                       cornerRadius: 10,
                                                       borderWidth: 0,
                                                       borderColor: nil,
                                                       clipsToBounds: true,
                                                       contentMode: .scaleToFill,
                                                       tintColor: .appOrange,
                                                       backgroundColor: .none)

    private lazy var infoButtom = UIElementFactory().addTextButtom(lable: "detailed".localized, size: 14,
                                                                   titleColor: .textColor,
                                                                   contentHorizontalAlignment: .left) {
        self.delegateEditProfile?.infoProfile()
    }

    private lazy var editButtom = UIElementFactory().addBigButtom(lable: "edit".localized,
                                                                  backgroundColor: .appOrange) {
        self.delegateEditProfile?.editProfile()
    }

    lazy var activityView = ProfileHeaderActivityView()

    func setProfileHeader(nickName: String?, name: String?, avatar: UIImage?, profession: String?, numberOfPublications: Int, numberOfScribes: Int, numberOfSubscriptions: Int, isFriend: Bool ) {
        guard let nickName = nickName else { return }
        self.nickName.text = nickName
        guard let name = name else { return }
        self.name.text = name
        guard let avatar = avatar else { return }
        self.avatar.image = avatar
        guard let profession = profession else { return }
        self.profession.text = profession
        self.isFriend = isFriend
        if isFriend {
            self.nickName.isHidden = true
            self.moreButtom.isHidden = true
            editButtom.backgroundColor = .buttomColor
            editButtom.setAttributedTitle(NSMutableAttributedString(string: "message".localized, attributes: [NSAttributedString.Key.kern: 0.16]), for: .normal)
        }
        self.activityView.setView(numberOfPublications: numberOfPublications, numberOfScribes: numberOfScribes, numberOfSubscriptions: numberOfSubscriptions, isFriend: isFriend)
        self.layoutSubviews()
    }

    override func layoutSubviews() {
        super .layoutSubviews()
        
        contentView.addSubviews(nickName, avatar, moreButtom, name, profession, infoIcon, infoButtom, editButtom, activityView)

        NSLayoutConstraint.activate([
            nickName.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            nickName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            nickName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40)
        ])

        if self.isFriend {
            NSLayoutConstraint.activate([
                avatar.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 14),
                avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
                avatar.heightAnchor.constraint(equalToConstant: 60),
                avatar.widthAnchor.constraint(equalToConstant: 60)
            ])
        } else {
            NSLayoutConstraint.activate([
                avatar.topAnchor.constraint(equalTo: nickName.bottomAnchor, constant: 14),
                avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
                avatar.heightAnchor.constraint(equalToConstant: 60),
                avatar.widthAnchor.constraint(equalToConstant: 60)
            ])
        }

        NSLayoutConstraint.activate([
            moreButtom.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            moreButtom.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            moreButtom.heightAnchor.constraint(equalToConstant: 13),
            moreButtom.widthAnchor.constraint(equalToConstant: 20)
        ])

        if self.isFriend {
            NSLayoutConstraint.activate([
                name.topAnchor.constraint(equalTo:  contentView.safeAreaLayoutGuide.topAnchor, constant: 22),
                name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),
                name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)
            ])
        } else {
            NSLayoutConstraint.activate([
                name.topAnchor.constraint(equalTo: nickName.bottomAnchor , constant: 22),
                name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),
                name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)
            ])
        }

        NSLayoutConstraint.activate([
            profession.topAnchor.constraint(equalTo: name.bottomAnchor , constant: 3),
            profession.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),
            profession.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)
        ])

        NSLayoutConstraint.activate([
            infoIcon.topAnchor.constraint(equalTo: profession.bottomAnchor , constant: 5),
            infoIcon.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),
            infoIcon.heightAnchor.constraint(equalToConstant: 20),
            infoIcon.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            infoButtom.centerYAnchor.constraint(equalTo: infoIcon.centerYAnchor),
            infoButtom.leadingAnchor.constraint(equalTo: infoIcon.trailingAnchor, constant: 8),
            infoButtom.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)
        ])

        NSLayoutConstraint.activate([
            editButtom.topAnchor.constraint(equalTo: infoIcon.bottomAnchor, constant: 25),
            editButtom.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            editButtom.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            editButtom.heightAnchor.constraint(equalToConstant: 47)
        ])

        NSLayoutConstraint.activate([
            activityView.topAnchor.constraint(equalTo: editButtom.bottomAnchor, constant: 25),
            activityView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            activityView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            activityView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension ProfileHeaderView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
