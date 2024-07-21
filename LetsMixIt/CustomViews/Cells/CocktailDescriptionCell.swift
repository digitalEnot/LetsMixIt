//
//  CocktailDescriptionCell.swift
//  LetsMixIt
//
//  Created by Evgeni Novik on 25.04.2024.
//

import UIKit

final class CocktailDescriptionCell: UICollectionViewCell {
    
    static let reuseID = "CocktailDescriptionCell"
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .max
        label.textColor = .secondaryLabel
        label.text = "Some description"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(message: String) {
        label.text = message
    }
    
    
    private func configure() {
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
}
