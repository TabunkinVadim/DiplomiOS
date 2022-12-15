//
//  ProfileHeaderActivityView.swift
//  Vk
//
//  Created by Табункин Вадим on 03.12.2022.
//

import UIKit

class ProfileHeaderActivityView: UIView {
    var numberOfPublications: Int
    var numberOfScribes: Int
    var numberOfSubscriptions: Int


    private let numberOfPublicationsLable = UIElementFactory().addRegularTextLable(lable: 1.localizedPostsCount, textColor: .textColor, textSize: 14, lineHeightMultiple: 1.18, textAlignment: .center)

    private let numberOfSubscriptionsLable = UIElementFactory().addRegularTextLable(lable: 2.localizedSubscriptionsCount, textColor: .textColor, textSize: 14, lineHeightMultiple: 1.18, textAlignment: .center)

    private let numberOfScribesLable = UIElementFactory().addRegularTextLable(lable: 3.localizedScribesCount, textColor: .textColor, textSize: 14, lineHeightMultiple: 1.18, textAlignment: .center)

    private lazy var newEntryButtom = UIElementFactory().addIconButtom(icon: UIImage(systemName: "square.and.pencil") ?? UIImage(), color: .textColor) {
        print("new Entry")
    }

    private let newEntryLable = UIElementFactory().addRegularTextLable(lable: "Empty".localized, textColor: .textColor, textSize: 14, lineHeightMultiple: 1.18, textAlignment: .center)

    private lazy var newHistoryButtom = UIElementFactory().addIconButtom(icon: UIImage(systemName: "camera") ?? UIImage(), color: .textColor) {
        print("new History")
    }

    private let newHistoryLable = UIElementFactory().addRegularTextLable(lable: "History".localized, textColor: .textColor, textSize: 14, lineHeightMultiple: 1.18, textAlignment: .center)

    private lazy var newPhotoButtom = UIElementFactory().addIconButtom(icon: UIImage(systemName: "photo") ?? UIImage(), color: .textColor) {
        print("new Photo")
    }

    private let newPhotoLable = UIElementFactory().addRegularTextLable(lable: "Photo".localized, textColor: .textColor, textSize: 14, lineHeightMultiple: 1.18, textAlignment: .center)

 init(numberOfPublications:Int, numberOfScribes: Int, numberOfSubscriptions: Int) {
     
        self.numberOfPublications = numberOfPublications
        self.numberOfScribes = numberOfScribes
        self.numberOfSubscriptions = numberOfSubscriptions
     super.init(frame: CGRect())
         self.toAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {

        self.addSubviews(numberOfPublicationsLable, numberOfSubscriptionsLable, numberOfScribesLable, newEntryButtom, newEntryLable, newHistoryButtom, newHistoryLable, newPhotoButtom, newPhotoLable)


        NSLayoutConstraint.activate([
            numberOfPublicationsLable.topAnchor.constraint(equalTo: self.topAnchor),
            numberOfPublicationsLable.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -(UIScreen.main.bounds.width)/3),
        ])

        NSLayoutConstraint.activate([
            numberOfSubscriptionsLable.topAnchor.constraint(equalTo: self.topAnchor),
            numberOfSubscriptionsLable.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            numberOfScribesLable.topAnchor.constraint(equalTo: self.topAnchor),
            numberOfScribesLable.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: (UIScreen.main.bounds.width)/3),
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
            newHistoryButtom.topAnchor.constraint(equalTo: numberOfScribesLable.bottomAnchor, constant: 30),
            newHistoryButtom.centerXAnchor.constraint(equalTo: numberOfScribesLable.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            newHistoryLable.topAnchor.constraint(equalTo: newHistoryButtom.bottomAnchor, constant: 12),
            newHistoryLable.centerXAnchor.constraint(equalTo: numberOfScribesLable.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            newPhotoButtom.topAnchor.constraint(equalTo: numberOfSubscriptionsLable.bottomAnchor, constant: 30),
            newPhotoButtom.centerXAnchor.constraint(equalTo: numberOfSubscriptionsLable.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            newPhotoLable.topAnchor.constraint(equalTo: newPhotoButtom.bottomAnchor, constant: 12),
            newPhotoLable.centerXAnchor.constraint(equalTo: numberOfSubscriptionsLable.centerXAnchor)
        ])



    }
    
    override func draw(_ rect: CGRect) {
        drawLine(in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
    }
    private func drawLine(in rect: CGRect) {

    }
}
