//
//  CocktailPhotoCell.swift
//  LetsMixIt
//
//  Created by Evgeni Novik on 25.04.2024.
//

import UIKit

final class CocktailPhotoAndProofCell: UICollectionViewCell {
    
    static let reuseID = "CocktailPhotoAndProofCell"
    let cocktailPhoto = UIImageView()
    let proofView = LMIProofView()
    let tasteLabel = UILabel()
    let cellStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(photo: UIImage, proof: Int, taste: String) {
        cocktailPhoto.image = photo
        proofView.textLabel.text = "\(String(proof: proof)) \(proof)%"
        self.tasteLabel.text = taste
    }
    
    private func configure() {
        addSubview(cellStack)
        clipsToBounds = true
        cellStack.addArrangedSubview(cocktailPhoto)
        cellStack.addArrangedSubview(proofView)
        cellStack.addArrangedSubview(tasteLabel)

        cellStack.alignment = .center
        cellStack.axis = .vertical
        cellStack.spacing = 40
        cellStack.setCustomSpacing(10, after: proofView)
        cellStack.translatesAutoresizingMaskIntoConstraints = false
        
        tasteLabel.text = "Горький"
        tasteLabel.textAlignment = .center
        tasteLabel.translatesAutoresizingMaskIntoConstraints = false
        tasteLabel.font = UIFont.systemFont(ofSize: 16)
        tasteLabel.textColor = .secondaryLabel
    
        proofView.translatesAutoresizingMaskIntoConstraints = false
        proofView.textLabel.text = "Крепкий 30%"
        proofView.textLabel.numberOfLines = .max
        
        cocktailPhoto.translatesAutoresizingMaskIntoConstraints = false
        cocktailPhoto.clipsToBounds = true
        cocktailPhoto.contentMode = .scaleAspectFit
        cocktailPhoto.image = UIImage(named: "default cocktail")
        
        NSLayoutConstraint.activate([
            cellStack.topAnchor.constraint(equalTo: topAnchor),
            cellStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            cocktailPhoto.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            cocktailPhoto.heightAnchor.constraint(equalToConstant: 170),
        ])
    }
}
