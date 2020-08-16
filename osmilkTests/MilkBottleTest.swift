//
//  MilkBottleTest.swift
//  osmilkTests
//
//  Created by Frederik Heuser on 16.08.20.
//  Copyright © 2020 Frederik Heuser. All rights reserved.
//

import XCTest

struct MaplyCoordinate
{
    var x = Float()
    var y = Float()
}



class MilkBottleTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTitle() throws {
        let milkBottles = [
            "Käse": MilkBottle(identifier: "1234", coordinate: MaplyCoordinate(x: 0, y: 0), name: "Käse", description: "", owner: "", vending: "", website: "", imageURL: "", opening_hours: ""),
            "Granaten GmbH": MilkBottle(identifier: "3123", coordinate: MaplyCoordinate(x: 0, y: 0), name: "", description: "Käsehobel automat", owner: "Granaten GmbH", vending: "", website: "", imageURL: "", opening_hours: ""),
            "Milchautomat mit Fleisch": MilkBottle(identifier: "345", coordinate: MaplyCoordinate(x: 0, y: 0), name: "", description: "Milchautomat mit Fleisch", owner: "", vending: "", website: "", imageURL: "", opening_hours: ""),
            "Milchhof Albert": MilkBottle(identifier: "5555", coordinate: MaplyCoordinate(x: 0, y: 0), name: "", description: "Helmut", owner: "Milchhof Albert", vending: "", website: "", imageURL: "", opening_hours: ""),
            "5225": MilkBottle(identifier: "5225", coordinate: MaplyCoordinate(x: 0, y: 0), name: "", description: "", owner: "", vending: "käse", website: "", imageURL: "", opening_hours: "")
        ]
       
        
        for (expectedTitle,milkBottle) in milkBottles {
            XCTAssertEqual(expectedTitle, milkBottle.getTitle())
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testVending()
    {
        let vending = String("milk")
        let milkBottle = MilkBottle(identifier: "5225", coordinate: MaplyCoordinate(x: 0, y: 0), name: "", description: "", owner: "", vending: vending, website: "", imageURL: "", opening_hours: "")
        let emojitized = milkBottle.getEmojitizedVending()
        XCTAssertTrue(emojitized.contains("🥛"))
        
    }
    
}

class MilkBottleEmotizeTest: XCTestCase {
    
    func testEmojitizeMilk() throws {
        let vending = String("milk")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🥛"))
    }
    func testEmojitizeMilkCapitalized() throws {
        let vending = String("Milk")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🥛"))
    }
    func testEmojitizeMilkWithSemicolon() throws {
        let vending = String("milk;")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🥛"))
    }
    func testEmojitizeMilkWithComma() throws {
        let vending = String("milk,")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🥛"))
    }
    func testEmojitizeMilkNotContained() throws {
        let vending = String("potatoe")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertFalse(emojitized.contains("🥛"))
    }
    
    func testEmojitizePotatoe() throws {
        let vending = String("potatoe")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🥔"))
    }
    func testEmojitizePotatoeCapitalized() throws {
        let vending = String("Potatoe")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🥔"))
    }
    func testEmojitizePotatoeWithSemicolon() throws {
        let vending = String("potatoe;")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🥔"))
    }
    func testEmojitizePotatoeWithComma() throws {
        let vending = String("potatoe,")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🥔"))
    }
    func testEmojitizePotato() throws {
        let vending = String("potato,")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🥔"))
    }
    func testEmojitizePotatoeNotContained() throws {
        let vending = String("hellbarde")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertFalse(emojitized.contains("🥔"))
    }

    
    

}
