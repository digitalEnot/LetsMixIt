//
//  Cocktail.swift
//  LetsMixIt
//
//  Created by Evgeni Novik on 20.04.2024.
//

import Foundation


struct Cocktail: Codable, Hashable {
    var name: String
    var proof: Int
    var image: String
    var ingredients: [String]
    var ingredientsWithMeasurements: [String: String?]
    var equipments: [String]
    var description: String
    var recipe: String
    var preferedGlass: String
    var taste: String
    var backgroundColor: String
}
