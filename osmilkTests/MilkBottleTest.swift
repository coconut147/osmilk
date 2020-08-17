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
            "Käse": MilkBottle(identifier: "1234", coordinate: MaplyCoordinate(x: 0, y: 0), name: "Käse", description: "", owner: "", vending: "", website: "", imageURL: "", openingHours: ""),
            "Granaten GmbH": MilkBottle(identifier: "3123", coordinate: MaplyCoordinate(x: 0, y: 0), name: "", description: "Käsehobel automat", owner: "Granaten GmbH", vending: "", website: "", imageURL: "", openingHours: ""),
            "Milchautomat mit Fleisch": MilkBottle(identifier: "345", coordinate: MaplyCoordinate(x: 0, y: 0), name: "", description: "Milchautomat mit Fleisch", owner: "", vending: "", website: "", imageURL: "", openingHours: ""),
            "Milchhof Albert": MilkBottle(identifier: "5555", coordinate: MaplyCoordinate(x: 0, y: 0), name: "", description: "Helmut", owner: "Milchhof Albert", vending: "", website: "", imageURL: "", openingHours: ""),
            "5225": MilkBottle(identifier: "5225", coordinate: MaplyCoordinate(x: 0, y: 0), name: "", description: "", owner: "", vending: "käse", website: "", imageURL: "", openingHours: "")
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
        let milkBottle = MilkBottle(identifier: "5225", coordinate: MaplyCoordinate(x: 0, y: 0), name: "", description: "", owner: "", vending: vending, website: "", imageURL: "", openingHours: "")
        let emojitized = milkBottle.getEmojitizedVending()
        XCTAssertTrue(emojitized.contains("🥛"))
        
    }
    
}

class MilkBottleTagHandlingTest: XCTestCase {

    func testAddName() throws {
        let key = String("name")
        let value = String("Milchautomat Freudenhof")
        var testCandidate = MilkBottle()
        testCandidate.addTag(key: key, value: value)
        XCTAssertEqual(testCandidate.name,value)
    }
    func testAddDescription() throws {
        let key = String("description")
        let value = String("Description")
        var testCandidate = MilkBottle()
        testCandidate.addTag(key: key, value: value)
        XCTAssertEqual(testCandidate.description,value)
    }
    func testAddVending() throws {
        let key = String("vending")
        let value = String("milk,cheese,food,sausage,eggs")
        var testCandidate = MilkBottle()
        testCandidate.addTag(key: key, value: value)
        XCTAssertEqual(testCandidate.getEmojitizedVending(),MilkBottle.emojitizeVending(vending: value))
    }
    func testRetrieveTags() throws {
        var testCandidate = MilkBottle()
        
        let dictionary = [
            "name":"Milchof Albert",
            "vending":"Food,cheese,milk",
            "website":"www.freddy.beer",
            "description":"Just some info"
        ]
        
        for (key, value) in dictionary {
            testCandidate.addTag(key: key, value: value)
        }
            
        XCTAssertEqual(dictionary.count, testCandidate.rawTags.count)
        for (key, _) in testCandidate.rawTags {
            XCTAssertEqual(dictionary[key], testCandidate.rawTags[key])
        }


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
    func testEmojitizeSausage() throws {
        let vending = String("Sausage")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🥓"))
    }
    func testEmojitizeSausageNotContained() throws {
           let vending = String("milk;food;potatoes")
           let emojitized = MilkBottle.emojitizeVending(vending: vending)
           XCTAssertFalse(emojitized.contains("🥓"))
       }
       
    func testEmojitizeCheese() throws {
        let vending = String("cHeese")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🧀"))
    }
    func testEmojitizeCheeseNotContained() throws {
        let vending = String("milk;sausage;meat")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertFalse(emojitized.contains("🧀"))
    }
    func testEmojitizeMeat() throws {
        let vending = String("Meat")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🥩"))
    }
    func testEmojitizeMeatNotContained() throws {
        let vending = String("milk;sausage;food")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertFalse(emojitized.contains("🥩"))
    }
    func testEmojitizeEgg() throws {
        let vending = String("EGG")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🥚"))
    }
    func testEmojitizeEggNotContained() throws {
        let vending = String("milk;sausage;food")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertFalse(emojitized.contains("🥚"))
    }
    func testEmojitizeHoney() throws {
        let vending = String("hOney")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🍯"))
    }
    func testEmojitizeHoneyNotContained() throws {
        let vending = String("milk;sausage;food")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertFalse(emojitized.contains("🍯"))
    }
    func testEmojitizeApple() throws {
        let vending = String("Apple")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🍎"))
    }
    func testEmojitizeAppleNotContained() throws {
        let vending = String("milk;sausage;food")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertFalse(emojitized.contains("🍎"))
    }
    func testEmojitizeButter() throws {
        let vending = String("Butter")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🧈"))
    }
    func testEmojitizeButterNotContained() throws {
        let vending = String("milk;sausage;food")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertFalse(emojitized.contains("🧈"))
    }
    func testEmojitizeFood() throws {
        let vending = String("milk;food")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🍽"))
    }
    func testEmojitizeFoodNotContained() throws {
        let vending = String("butter;milk;sausage")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertFalse(emojitized.contains("🍽"))
    }
    func testEmojitizeJam() throws {
        let vending = String("milk;food,jam")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertTrue(emojitized.contains("🍓"))
    }
    func testEmojitizeJamNotContained() throws {
        let vending = String("butter;milk;sausage;food")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertFalse(emojitized.contains("🍓"))
    }
    func testEmojitizeCount() throws {
        let vending = String("butter;milk;apple;food,honey,sausage")
        let emojitized = MilkBottle.emojitizeVending(vending: vending)
        XCTAssertEqual(6,emojitized.count)
    }
}
