//
//  DenkmallisteTests.swift
//  DenkmallisteTests
//
//  Created by Ingo Wiederoder on 29.11.21.
//

import XCTest
@testable import Denkmalliste

class DenkmallisteTests: XCTestCase {
    
    var parser: LocationParser!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if let documentURL = Bundle.main.url(forResource: "baudenkmal", withExtension: "kml") {
            parser = LocationParser(contentsOf: documentURL)
        }
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        parser.parseDocument()
    }
    
//    func testGettingPlacemarks() throws {
//        parser.parseDocument()
//        let expectation = XCTestExpectation(description: "Parse Placemarks from KML file")
//        let nc = NotificationCenter.default
//        nc.addObserver(forName: NSNotification.Name("placemarkNotification"), object: nil, queue: OperationQueue.current) { placemarkNotification in
//            XCTAssert(placemarkNotification.userInfo?.isEmpty == false, "Placemarks parsed")
//            expectation.fulfill()
//        }
//    }
//    
//    func testGettingAllPlacemarks() throws {
//        parser.parseDocument()
//        let expectation = XCTestExpectation(description: "Parse Placemarks from KML file")
//        let nc = NotificationCenter.default
//        nc.addObserver(forName: NSNotification.Name("placemarkNotification"), object: nil, queue: OperationQueue.current) { placemarkNotification in
//            let placemarks = placemarkNotification.userInfo?["pacemarks"] as? [Placemark]
//            for placemark in placemarks! {
//                XCTAssert(placemark.coordinates != nil, "Nil Placemark-coordinatesfounded")
//            }
//            expectation.fulfill()
//        }
//    }
    
    func testPerformanceExample() throws {
        self.measure {
            let nc = NotificationCenter.default
            nc.addObserver(forName: NSNotification.Name("placemarkNotification"), object: nil, queue: OperationQueue.current) { placemarkNotification in
                
            }
        }
    }

}
