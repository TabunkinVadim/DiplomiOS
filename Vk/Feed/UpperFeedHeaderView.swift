//
//  FeedHeaderView.swift
//  Vk
//
//  Created by Табункин Вадим on 13.11.2022.
//

import UIKit

class UpperFeedHeaderView:UITableViewHeaderFooterView  {

    private let date = "21 июня"

    private var array: [Int] {
        var array = [Int]()
        for element in 1...10 {
            array.append(element)
        }
        return array
    }

    private let newsButtom = UIElementFactory().addTextButtom(lable: "newsButtomFeed".localized, titleColor: .textColor, contentHorizontalAlignment: .center) {
        print("newsButtom")
    }
    private let forYouButtom = UIElementFactory().addTextButtom(lable: "forYouButtom".localized, titleColor: .textColor, contentHorizontalAlignment: .center) {
        print("forYouButtom")
    }

    private lazy var storiesCollection = UIElementFactory().addStoriesCollectionView(dataSource: self,
                                                                              delegate: self)
    private lazy var dateLable = UIElementFactory().addRegularTextLable(lable: date ,
                                                              textColor: UIColor(red: 0.495, green: 0.507, blue: 0.512, alpha: 1),
                                                              textSize: 14,
                                                              lineHeightMultiple: 1.18,
                                                                        textAlignment: .center)

    override func layoutSubviews() {
        super .layoutSubviews()

        contentView.addSubviews(newsButtom, forYouButtom, storiesCollection, dateLable)

        NSLayoutConstraint.activate([
            newsButtom.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            newsButtom.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            newsButtom.widthAnchor.constraint(equalToConstant: 344),
//            newsButtom.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            forYouButtom.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            forYouButtom.leadingAnchor.constraint(equalTo: newsButtom.trailingAnchor, constant: 38),
//            newsButtom.widthAnchor.constraint(equalToConstant: 344),
//            forYouButtom.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            storiesCollection.topAnchor.constraint(equalTo: newsButtom.bottomAnchor, constant: 27),
            storiesCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            storiesCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            storiesCollection.heightAnchor.constraint(equalToConstant: 60)
        ])

        NSLayoutConstraint.activate([
            dateLable.topAnchor.constraint(equalTo: storiesCollection.bottomAnchor, constant: 22),
            dateLable.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            date.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dateLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

    }
}

extension UpperFeedHeaderView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        array.count

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCollectionCell.identifier, for: indexPath) as! HistoryCollectionCell
//        cell.imageView.image = incominginImages[indexPath.item]
        return cell
    }
}

extension UpperFeedHeaderView: UICollectionViewDelegateFlowLayout {

    private var sideInset: CGFloat {return 12}

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 60//(collectionView.bounds.width - sideInset * 6 / 5)
        return CGSize(width: width, height: width)
    }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            CGFloat(sideInset)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
}
