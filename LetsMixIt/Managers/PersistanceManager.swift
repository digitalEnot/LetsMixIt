//
//  PersistanceManager.swift
//  LetsMixIt
//
//  Created by Evgeni Novik on 25.03.2024.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

enum PersistanceManager {
    enum Keys {
        static let favorites = "favorites"
    }
    
    static private let defaults = UserDefaults.standard
    
    static func updateWith(favorite: Cocktail, actionType: PersistanceActionType) throws {
        do {
            var retrivedFavorites = try retrieveFavorites()
            
            switch actionType {
            case .add:
                guard !retrivedFavorites.contains(favorite) else {
                    throw LMIError.alreadyInFavorites
                }
                retrivedFavorites.append(favorite)
            case .remove:
                retrivedFavorites.removeAll { $0.name == favorite.name }
            }
            
            if let error = save(favorites: retrivedFavorites) {
                throw error
            }
        }
        catch {
            throw LMIError.somethingWentWrong
        }
    }
    
    
    static func retrieveFavorites() throws -> [Cocktail] {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Cocktail].self, from: favoritesData)
        } catch {
            throw LMIError.unableToFavorite
        }
    }
    
    
    static func save(favorites: [Cocktail]) -> LMIError? {
        do {
            let enconder = JSONEncoder()
            let encodedFavorites = try enconder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
