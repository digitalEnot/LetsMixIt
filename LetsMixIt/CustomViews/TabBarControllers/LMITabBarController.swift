//
//  LMITabBarController.swift
//  LetsMixIt
//
//  Created by Evgeni Novik on 19.04.2024.
//

import UIKit

final class LMITabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor(hex: "#FF7F50")
        UITabBar.appearance().backgroundColor = UIColor.systemGray6
        viewControllers = [createCocktailsListNC(), createFavoritesCocktailsNC()]
    }
    
    
    private func createCocktailsListNC() -> UINavigationController {
        let cocktailsListVC = CocktailsLIstVC()
        cocktailsListVC.title = "Коктейли"
        cocktailsListVC.tabBarItem = UITabBarItem(title: "Коктейли", image: UIImage(named: "cocktail"), tag: 0)
        return UINavigationController(rootViewController: cocktailsListVC)
    }
    
    
    private func createFavoritesCocktailsNC() -> UINavigationController {
        let favoritesCocktailsVC = FavoritesCocktailsVC()
        favoritesCocktailsVC.title = "Избранное"
        favoritesCocktailsVC.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(systemName: "heart.fill"), tag: 1)
        return UINavigationController(rootViewController: favoritesCocktailsVC)
    }
}
