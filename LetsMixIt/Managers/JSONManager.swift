//
//  JSONManager.swift
//  LetsMixIt
//
//  Created by Evgeni Novik on 03.06.2024.
//

import Foundation


final class JSONManager {
    static let shared = JSONManager()
    private let dataResource = "cocktailsData"
    private let decoder = JSONDecoder()
    
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    
    func parseJSON() async throws -> [Cocktail] {
        guard let path = Bundle.main.path(forResource: dataResource, ofType: "json") else {
            throw LMIError.somethingWentWrong
        }
        
        let url = URL(filePath: path)
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            return try decoder.decode([Cocktail].self, from: data)
        } catch {
            throw LMIError.invalidData
        }
    }
}
