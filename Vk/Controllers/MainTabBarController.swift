//
//  MainTabBarController.swift
//  Navigation
//
//  Created by Табункин Вадим on 27.02.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    weak var coordinator: MainCoordinator?
    var feedCoordinator: FeedCoordinator
    var profileCoordinator: ProfileCoordinator
    var favoritePostCoordinator: FavoritePostsCoordinator
    var mapCoordinator: MapCoordinator



    init (loginCheker: LoginInspector,checkModel: CheckModel){
        feedCoordinator = MainCoordinator.shared.feed(navigationController: UINavigationController(), checkModel: checkModel)
        profileCoordinator = MainCoordinator.shared.profile(navigationController: UINavigationController(), loginCheker: loginCheker)
        favoritePostCoordinator = MainCoordinator.shared.favorite(navigationController: UINavigationController())
        mapCoordinator = MainCoordinator.shared.map(navigationController: UINavigationController())
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [profileCoordinator.navigationController, feedCoordinator.navigationController, favoritePostCoordinator.navigationController,mapCoordinator.navigationController ]
    }
}

