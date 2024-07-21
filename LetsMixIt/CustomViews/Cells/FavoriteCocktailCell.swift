//
//  FavoriteCocktailCell.swift
//  LetsMixIt
//
//  Created by Evgeni Novik on 11.05.2024.
//

import UIKit

final class FavoriteCocktailCell: UICollectionViewCell {
    static let reuseID = "FavoriteCocktailCell"
    let cocktailTitle = UILabel()
    let cocktailPhoto = UIImageView()
    let photoView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(cocktatil: Cocktail) {
        photoView.backgroundColor = UIColor(hex: cocktatil.backgroundColor)
        cocktailTitle.text = cocktatil.name
        cocktailPhoto.image = UIImage(named: cocktatil.image)
    }
    
    
    private func configureUI() {
        addSubview(cocktailTitle)
        addSubview(photoView)
        photoView.addSubview(cocktailPhoto)
        
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.layer.cornerRadius = 25
        
        cocktailPhoto.image = UIImage(named: "default cocktail")
        cocktailPhoto.clipsToBounds = true
        cocktailPhoto.contentMode = .scaleAspectFit
        cocktailPhoto.translatesAutoresizingMaskIntoConstraints = false

        cocktailTitle.text = "Коктейль"
        cocktailTitle.translatesAutoresizingMaskIntoConstraints = false
        cocktailTitle.textAlignment = .center
        cocktailTitle.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        cocktailTitle.textColor = .label
        
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoView.topAnchor.constraint(equalTo: topAnchor),
            photoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoView.widthAnchor.constraint(equalTo: photoView.heightAnchor),

            cocktailPhoto.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
            cocktailPhoto.centerYAnchor.constraint(equalTo: photoView.centerYAnchor),
            cocktailPhoto.heightAnchor.constraint(equalToConstant: 120),
            cocktailPhoto.widthAnchor.constraint(equalTo: cocktailPhoto.heightAnchor),
            
            cocktailTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            cocktailTitle.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 5),
            cocktailTitle.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
