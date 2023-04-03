//
//  ProfileHeaderActivityView.swift
//  Vk
//
//  Created by Табункин Вадим on 03.12.2022.
//

import UIKit


class ProfileHeaderActivityView: UIView {
    
    var screen: CGFloat = (UIScreen.main.bounds.width) / 6
    
    weak var delegateActivity:ProfileHeaderActivityProtocol?
    
    private lazy var numberOfPublicationsLable = UIElementFactory().addRegularTextLable(lable: 0.localizedPostsCount,
                                                                                        textColor: .textColor,
                                                                                        textSize: 14,
                                                                                        lineHeightMultiple: 1.18,
                                                                                        textAlignment: .center)
    
    private lazy var numberOfSubscriptionsLable = UIElementFactory().addRegularTextLable(lable: 0.localizedSubscriptionsCount,
                                                                                         textColor: .textColor,
                                                                                         textSize: 14,
                                                                                         lineHeightMultiple: 1.18,
                                                                                         textAlignment: .center)
    
    private lazy var numberOfScribesLable = UIElementFactory().addRegularTextLable(lable: 0.localizedScribesCount,
                                                                                   textColor: .textColor,
                                                                                   textSize: 14,
                                                                                   lineHeightMultiple: 1.18,
                                                                                   textAlignment: .center)
    
    private lazy var newEntryButtom = UIElementFactory().addIconButtom(icon: UIImage(systemName: "square.and.pencil") ?? UIImage(),
                                                                       color: .textColor,
                                                                       cornerRadius: 0) {
        self.delegateActivity?.newEntry()
    }
    
    private let newEntryLable = UIElementFactory().addRegularTextLable(lable: "Empty".localized,
                                                                       textColor: .textColor,
                                                                       textSize: 14,
                                                                       lineHeightMultiple: 1.18,
                                                                       textAlignment: .center)
    
    private lazy var newHistoryButtom = UIElementFactory().addIconButtom(icon: UIImage(systemName: "camera") ?? UIImage(),
                                                                         color: .textColor,
                                                                         cornerRadius: 0) {
        self.delegateActivity?.newHistory()
    }
    
    private let newHistoryLable = UIElementFactory().addRegularTextLable(lable: "History".localized,
                                                                         textColor: .textColor,
                                                                         textSize: 14,
                                                                         lineHeightMultiple: 1.18,
                                                                         textAlignment: .center)
    
    private lazy var newPhotoButtom = UIElementFactory().addIconButtom(icon: UIImage(systemName: "photo") ?? UIImage(),
                                                                       color: .textColor,
                                                                       cornerRadius: 0) {
        self.delegateActivity?.newPhoto()
    }
    
    private let newPhotoLable = UIElementFactory().addRegularTextLable(lable: "Photo".localized,
                                                                       textColor: .textColor,
                                                                       textSize: 14,
                                                                       lineHeightMultiple: 1.18,
                                                                       textAlignment: .center)
    
    init () {
        super.init(frame: CGRect())
        self.toAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setView(numberOfPublications:Int, numberOfScribes: Int, numberOfSubscriptions: Int, isFriend: Bool) {
        self.numberOfPublicationsLable.text = numberOfPublications.localizedPostsCount
        self.numberOfScribesLable.text = numberOfScribes.localizedScribesCount
        self.numberOfSubscriptionsLable.text = numberOfSubscriptions.localizedSubscriptionsCount
        if isFriend {
            self.newEntryButtom.isHidden = true
            self.newEntryLable.isHidden = true
            self.newPhotoButtom.isHidden = true
            self.newPhotoLable.isHidden = true
            self.newHistoryButtom.isHidden = true
            self.newHistoryLable.isHidden = true
        }
        self.layoutSubviews()
    }

    override func layoutSubviews() {
        self.addSubviews(numberOfPublicationsLable, numberOfSubscriptionsLable, numberOfScribesLable, newEntryButtom, newEntryLable, newHistoryButtom, newHistoryLable, newPhotoButtom, newPhotoLable)
        
        NSLayoutConstraint.activate([
            numberOfPublicationsLable.topAnchor.constraint(equalTo: numberOfSubscriptionsLable.topAnchor),
            numberOfPublicationsLable.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: screen)
        ])
        
        NSLayoutConstraint.activate([
            numberOfSubscriptionsLable.topAnchor.constraint(equalTo: self.topAnchor),
            numberOfSubscriptionsLable.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            numberOfScribesLable.topAnchor.constraint(equalTo: numberOfSubscriptionsLable.topAnchor),
            numberOfScribesLable.centerXAnchor.constraint(equalTo: self.trailingAnchor, constant:  -screen)
        ])

        NSLayoutConstraint.activate([
            newEntryButtom.topAnchor.constraint(equalTo: numberOfPublicationsLable.bottomAnchor, constant: 30),
            newEntryButtom.centerXAnchor.constraint(equalTo: numberOfPublicationsLable.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            newEntryLable.topAnchor.constraint(equalTo: newEntryButtom.bottomAnchor, constant: 12),
            newEntryLable.centerXAnchor.constraint(equalTo: numberOfPublicationsLable.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            newPhotoButtom.topAnchor.constraint(equalTo: numberOfSubscriptionsLable.bottomAnchor, constant: 30),
            newPhotoButtom.centerXAnchor.constraint(equalTo: numberOfSubscriptionsLable.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            newPhotoLable.topAnchor.constraint(equalTo: newPhotoButtom.bottomAnchor, constant: 12),
            newPhotoLable.centerXAnchor.constraint(equalTo: numberOfSubscriptionsLable.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            newHistoryButtom.topAnchor.constraint(equalTo: numberOfScribesLable.bottomAnchor, constant: 30),
            newHistoryButtom.centerXAnchor.constraint(equalTo: numberOfScribesLable.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            newHistoryLable.topAnchor.constraint(equalTo: newHistoryButtom.bottomAnchor, constant: 12),
            newHistoryLable.centerXAnchor.constraint(equalTo: numberOfScribesLable.centerXAnchor)
        ])
    }
}
