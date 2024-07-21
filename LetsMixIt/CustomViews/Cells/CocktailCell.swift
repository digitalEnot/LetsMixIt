//
//  CocktailCell.swift
//  LetsMixIt
//
//  Created by Evgeni Novik on 20.04.2024.
//

import UIKit

final class CocktailCell: UICollectionViewCell {
    static let reuseID = "CocktailCell"
    let cocktailTitle = UILabel()
    let cocktailProof = UILabel()
    let cocktailPhoto = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(cocktatil: Cocktail) {
        backgroundColor = UIColor(hex: cocktatil.backgroundColor)
        cocktailTitle.text = cocktatil.name
        cocktailPhoto.image = UIImage(named: cocktatil.image)
        cocktailProof.text = String(proof: cocktatil.proof)
    }
    
    private func configureUI() {
        addSubview(cocktailTitle)
        addSubview(cocktailPhoto)
        addSubview(cocktailProof)
        
        cocktailPhoto.image = UIImage(named: "default cocktail")
        cocktailPhoto.clipsToBounds = true
        cocktailPhoto.contentMode = .scaleAspectFit
        cocktailPhoto.translatesAutoresizingMaskIntoConstraints = false

        cocktailTitle.text = "Коктейль"
        cocktailTitle.translatesAutoresizingMaskIntoConstraints = false
        cocktailTitle.textAlignment = .center
        cocktailTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        cocktailTitle.textColor = .black
        
        cocktailProof.text = "Слабоалкогольный"
        cocktailProof.translatesAutoresizingMaskIntoConstraints = false
        cocktailProof.textAlignment = .center
        cocktailProof.font = UIFont.systemFont(ofSize: 14)
        cocktailProof.textColor = .secondaryLabel
        let cocktailProofColor = UIColor.black.withAlphaComponent(0.6)
        cocktailProof.textColor = cocktailProofColor
        
        NSLayoutConstraint.activate([
            cocktailPhoto.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            cocktailPhoto.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            cocktailPhoto.heightAnchor.constraint(equalToConstant: 100),
            cocktailPhoto.widthAnchor.constraint(equalTo: cocktailPhoto.heightAnchor),
            
            cocktailTitle.topAnchor.constraint(equalTo: cocktailPhoto.topAnchor, constant: 5),
            cocktailTitle.leadingAnchor.constraint(equalTo: cocktailPhoto.trailingAnchor),
            cocktailTitle.heightAnchor.constraint(equalToConstant: 18),
            
            cocktailProof.topAnchor.constraint(equalTo: cocktailTitle.bottomAnchor, constant: 10),
            cocktailProof.leadingAnchor.constraint(equalTo: cocktailPhoto.trailingAnchor),
            cocktailProof.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}
