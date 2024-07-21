//
//  HeaderForCocktailsDeatails.swift
//  LetsMixIt
//
//  Created by Evgeni Novik on 25.04.2024.
//

import UIKit

final class HeaderForCocktailsDeatails: UICollectionReusableView {
    
    static let reuseID = "Header"
    let label: UILabel = {
        let label = UILabel()
        label.text = "Header"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.frame = bounds
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
