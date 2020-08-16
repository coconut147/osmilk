//
//  MilkBottle.swift
//  osmilk
//
//  Created by Frederik Heuser on 16.08.20.
//  Copyright © 2020 Frederik Heuser. All rights reserved.
//

import Foundation


struct MilkBottle {
    var identifier = String();
    var coordinate = MaplyCoordinate()
    var name = String()
    var description = String()
    var owner = String() // "Tag: Operator"
    var vending = String()
    var website = String()
    var imageURL = String()
    var opening_hours = String()
    
    func getTitle() -> String {
        if name != "" {
            return name
        }
        else if owner != "" {
            return owner
        }
        else if description != "" {
            return description
        }
        else {
            return identifier
        }
    }
    func getEmojitizedVending() -> String {
        return MilkBottle.emojitizeVending(vending: vending)
    }
    
    static func emojitizeVending(vending: String) -> String {
        var emojitizedString = String("");
        
        if vending.contains("milk") {
            emojitizedString += "🥛"
        }
        if vending.contains("Milk") {
            emojitizedString += "🥛"
        }
        if vending.contains("potato") {
            emojitizedString += "🥔"
        }
        if vending.contains("Potato") {
            emojitizedString += "🥔"
        }
        return emojitizedString
    }
    
}
