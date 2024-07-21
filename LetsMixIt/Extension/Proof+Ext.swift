//
//  Proof+Ext.swift
//  LetsMixIt
//
//  Created by Evgeni Novik on 20.04.2024.
//

import UIKit

extension String {
    public init(proof: Int) {
        switch proof {
        case 0:
            self.init("Безалк.")
        case 1...15:
            self.init("Слабоалк.")
        case 16...22:
            self.init("Полукрепкий")
        case 23...99:
            self.init("Крепкий")
        default:
            self.init("Не известно")
        }
    }
}
