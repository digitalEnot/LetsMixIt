//
//  LMIDetailView.swift
//  LetsMixIt
//
//  Created by Evgeni Novik on 21.04.2024.
//

import UIKit

final class LMIProofView: UIView {
    
    let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(message: String) {
        super.init(frame: .zero)
        textLabel.text = message
        configure()
    }
    
    private func configure() {
        addSubview(textLabel)
        layer.cornerRadius = 10
        backgroundColor = UIColor(hex: "#d7e9ff")
        textLabel.text = "Слабоалк. 18%"
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor(hex: "#4797f9")
        textLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
