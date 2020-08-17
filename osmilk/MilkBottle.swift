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
    var openingHours = String()
    var rawTags = [String: String]() //key: value
    
    mutating func addTag(key: String,value: String){
        rawTags[key] = value

        switch key {
            case "name":
                name = value
            case "operator":
                owner = value
            case "vending":
                vending = MilkBottle.emojitizeVending(vending: value)
            case "website":
                website = value
            case "contact:website":
                if(website == "") {
                    website = value
                }
            case "description":
                description = value
            case "opening_hours":
                openingHours = value
            default:
                break
        }
        
    }
    
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
        let lowercased = vending.lowercased()
        if lowercased.contains("milk") {
            emojitizedString += "🥛"
        }
        if lowercased.contains("potato") {
            emojitizedString += "🥔"
        }
        if lowercased.contains("apple") {
            emojitizedString += "🍎"
        }
        if lowercased.contains("butter") {
            emojitizedString += "🧈"
        }
        if lowercased.contains("food") {
            emojitizedString += "🍽"
        }
        if lowercased.contains("jam") {
            emojitizedString += "🍓"
        }
        if lowercased.contains("honey") {
            emojitizedString += "🍯"
        }
        if lowercased.contains("meat") {
            emojitizedString += "🥩"
        }
        if lowercased.contains("egg") {
            emojitizedString += "🥚"
        }
        if lowercased.contains("cheese") {
            emojitizedString += "🧀"
        }
        if lowercased.contains("sausage") {
            emojitizedString += "🥓"
        }
        return emojitizedString
    }
    
}
