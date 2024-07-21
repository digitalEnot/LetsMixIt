//
//  FavoritesCocktailsVC.swift
//  LetsMixIt
//
//  Created by Evgeni Novik on 19.04.2024.
//

import UIKit

final class FavoritesCocktailsVC: UIViewController {
    var favorites: [Cocktail] = []
    var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getFavorites()
        configureCollectionView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if favorites.isEmpty {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "star")
            config.text = "Нет любимых коктейлей"
            config.secondaryText = ""
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoSquareColumnLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FavoriteCocktailCell.self, forCellWithReuseIdentifier: FavoriteCocktailCell.reuseID)
    }
    
    
    func updateUI(with favorites: [Cocktail]) {
        self.favorites = favorites
        setNeedsUpdateContentUnavailableConfiguration()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.view.bringSubviewToFront(self.collectionView)
        }
    }

    private func getFavorites() {
        do {
            let favoriteCoctails = try PersistanceManager.retrieveFavorites()
            updateUI(with: favoriteCoctails)
        }
        catch {
            // TODO: Вместо вывода ошибки сделать уведомляющее окно
            print(error)
        }
    }
}


extension FavoritesCocktailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favorites.count
    }
    
         
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCocktailCell.reuseID, for: indexPath) as! FavoriteCocktailCell
        let reversedArray = Array(favorites.reversed())
        cell.set(cocktatil: reversedArray[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reversedArray = Array(favorites.reversed())
        let cocktail = reversedArray[indexPath.item]
        let destVC = CocktailInfoVC(cocktail: cocktail)
        destVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destVC, animated: true)
    }
}
