//
//  CocktailDetailsCell.swift
//  LetsMixIt
//
//  Created by Evgeni Novik on 22.04.2024.
//

import UIKit

final class CocktailDetailsCell: UICollectionViewCell {
    
    static let reuseID = "CocktailDetailsCell"
    let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Описание"
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor.black
        textLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(message: String) {
        textLabel.text = message
    }

    
    private func configure() {
        addSubview(textLabel)
        layer.cornerRadius = 10
        backgroundColor = UIColor(hex: "#f3f3f7")
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
