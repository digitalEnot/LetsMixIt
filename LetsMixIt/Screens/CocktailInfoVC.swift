//
//  CocktailInfoVC.swift
//  LetsMixIt
//
//  Created by Evgeni Novik on 25.04.2024.
//

import UIKit

// TODO: Сделать секции CollectionView через enum
// TODO: Переписать способ хранения userDefaults
final class CocktailInfoVC: UIViewController {
    
    let exceptions = ["Лайм", "Тростниковый сахар в куб", "Мята", "Яблоко"]

    var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var cocktail: Cocktail
    var listOfFavorites: [Cocktail] = []
    var isCocktailInFavorites = false
    var likeButton = UIImage()

    
    init(cocktail: Cocktail) {
        self.cocktail = cocktail
        super.init(nibName: nil, bundle: nil)
        title = cocktail.name
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = UIColor(hex: "#FF7F50")
        getFavorites()
        configureCollectionView()
        configureRightBarButton()
    }
    
    
    private func getFavorites() {
        do {
            self.listOfFavorites = try PersistanceManager.retrieveFavorites()
        } catch {
            // TODO: Вместо вывода ошибки сделать уведомляющее окно
            print(error)
        }
    }
    
    
    private func configureRightBarButton() {
        if listOfFavorites.contains(cocktail) {
            likeButton = UIImage(systemName: "heart.fill") ?? UIImage()
            isCocktailInFavorites = true
        } else {
            likeButton = UIImage(systemName: "heart") ?? UIImage()
            isCocktailInFavorites = false
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: likeButton, style: .done, target: self, action: #selector(likeButtonTapped))
    }
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.register(CocktailPhotoAndProofCell.self, forCellWithReuseIdentifier: CocktailPhotoAndProofCell.reuseID)
        collectionView.register(CocktailDetailsCell.self, forCellWithReuseIdentifier: CocktailDetailsCell.reuseID)
        collectionView.register(CocktailDescriptionCell.self, forCellWithReuseIdentifier: CocktailDescriptionCell.reuseID)
        collectionView.register(HeaderForCocktailsDeatails.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderForCocktailsDeatails.reuseID)
    }
    
    // TODO: Вместо вывода ошибки/успешности операции сделать уведомляющее окно
    @objc func likeButtonTapped() {
        if isCocktailInFavorites {
            do {
                try PersistanceManager.updateWith(favorite: cocktail, actionType: .remove)
                print("removed successfully")
                DispatchQueue.main.async {
                    self.isCocktailInFavorites = false
                    self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
                }
            } catch {
                print(error)
            }
        } else {
            do {
                try PersistanceManager.updateWith(favorite: cocktail, actionType: .add)
                print("added successfully")
                DispatchQueue.main.async {
                    self.isCocktailInFavorites = true
                    self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
                }
            } catch {
                print(error)
            }
        }
    }
}


extension CocktailInfoVC {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _  in
            guard let self = self else { return nil }
            switch sectionIndex {
            case 0:
                return self.createZeroLayout()
            case 1:
                return self.createFirstLayout()
            case 2:
                return self.createFirstLayout()
            case 3:
                return self.createSecondLayout()
            case 4:
                return self.createSecondLayout()
            default:
                return self.createFirstLayout()
            }
        }
    }
    
    
    private func supplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize:  .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    private func createZeroLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = []
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 40, trailing: 10)
        return section
    }
    
    
    private func createFirstLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(4), trailing: .fixed(6), bottom: .fixed(4))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [supplementaryItem()]
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 40, trailing: 0)
        return section
    }
    
    
    private func createSecondLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [supplementaryItem()]
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 40, trailing: 10)
        return section
    }
}


extension CocktailInfoVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            1
        case 1:
            cocktail.ingredients.count
        case 2:
            cocktail.equipments.count + 1
        case 3:
             1
        case 4:
             1
        default:
            0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailPhotoAndProofCell.reuseID, for: indexPath) as! CocktailPhotoAndProofCell
            cell.set(photo: UIImage(named: "\(cocktail.image)")!, proof: cocktail.proof, taste: cocktail.taste)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailDetailsCell.reuseID, for: indexPath) as! CocktailDetailsCell
            
            let ingredient = cocktail.ingredients[indexPath.row]
            let measurement = cocktail.ingredientsWithMeasurements[ingredient]!
            if let measurement = measurement {
                if exceptions.contains(ingredient) {
                    cell.set(message: "\(ingredient): \(measurement)г")
                } else {
                    cell.set(message: "\(ingredient): \(measurement)мл")
                }
            } else {
                cell.set(message: ingredient)
            }
            
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailDetailsCell.reuseID, for: indexPath) as! CocktailDetailsCell
            if indexPath.row != cocktail.equipments.count {
                cell.set(message: cocktail.equipments[indexPath.row])
            } else {
                cell.set(message: "Подача: \(cocktail.preferedGlass)")
            }
            return cell
        }
        
        if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailDescriptionCell.reuseID, for: indexPath) as! CocktailDescriptionCell
            cell.label.text = cocktail.recipe
            return cell
        }
        
        if indexPath.section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailDescriptionCell.reuseID, for: indexPath) as! CocktailDescriptionCell
            cell.label.text = cocktail.description
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailDetailsCell.reuseID, for: indexPath) as! CocktailDetailsCell
            cell.set(message: cocktail.ingredients[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        if indexPath.section == 1 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderForCocktailsDeatails.reuseID, for: indexPath) as! HeaderForCocktailsDeatails
            header.label.text = "Ингредиенты"
            return header
        }
        
        if indexPath.section == 2 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderForCocktailsDeatails.reuseID, for: indexPath) as! HeaderForCocktailsDeatails
            header.label.text = "Приборы"
            return header
        }
        
        if indexPath.section == 3 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderForCocktailsDeatails.reuseID, for: indexPath) as! HeaderForCocktailsDeatails
            header.label.text = "Рецепт"
            return header
        }
        
        if indexPath.section == 4 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderForCocktailsDeatails.reuseID, for: indexPath) as! HeaderForCocktailsDeatails
            header.label.text = "Описание"
            return header
        }
        
        return UICollectionReusableView()
    }
}
