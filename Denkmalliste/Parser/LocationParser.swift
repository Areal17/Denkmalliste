//
//  LocationParser.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 02.12.21.
//

import UIKit
import SwiftUI
import CoreLocation


struct Placemark {
    var name: String
    var coordinates: [CLLocationCoordinate2D]
    
    init() {
        self.name = "k.A"
        self.coordinates = [CLLocationCoordinate2D]()
    }
}


class LocationParser: NSObject, XMLParserDelegate, ObservableObject  {
    @Published var parsedPlacemarks = [Placemark]()
    @Published var parsedPlacemarksDict = [Int: Placemark]()
    var kmlParser: XMLParser? //variable machen
    var placemark: Placemark?
    var placemarks = [Placemark]()
    var placemarksDict = [Int: Placemark]()
    var currentCoordinates: CLLocationCoordinate2D?
    var placemarkName: String?
//    var contentURLs: [URL]
//    private var urlCount: Int
    
    init?(contentsOf: [URL]) {
        super.init()
        for currentURL in contentsOf {
            kmlParser = XMLParser(contentsOf: currentURL)
            if kmlParser != nil {
                kmlParser!.delegate = self
                kmlParser!.shouldProcessNamespaces = false
                kmlParser!.parse()
            }
        }
    }
    
    func parseDocument(fileIndex: Int){
//        kmlParser = XMLParser(contentsOf: contentURLs[fileIndex])
        assert(kmlParser != nil, "Parser didn't initialized. Check the URL of the document to parse")
        kmlParser!.parse()
        #if targetEnvironment(simulator)
        print("parser is looking for placemarks")
        #endif
    }
    
    private func placemarkID(fromString name: String) -> String? {
        guard name != "Punkt" && name != "YADE 7.0" else { return nil }
        var name = name
        name = name.replacingOccurrences(of: "Punkt ", with: "")
        name.removeFirst()
        return name
    }
    
    private func locationCoordinates(fromString coordinateString: String) -> CLLocationCoordinate2D {
        let coordinateString = coordinateString.split(separator: ",")
        if let latitude = CLLocationDegrees(coordinateString[1]), let longitude = CLLocationDegrees(coordinateString.first!) {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return CLLocationCoordinate2D()
    }
    
    // pragma mark - XMLParserDelegte
    
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Parser did Start Document")
    }
    
    func parser(_ parser: XMLParser, foundElementDeclarationWithName elementName: String, model: String) {
        print(elementName)
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "Placemark" {
            placemark = Placemark()
        } else if elementName == "name"{
            placemarkName = String()
        } else if elementName == "coordinates" {
            currentCoordinates = CLLocationCoordinate2D()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Placemark" {
            placemarks.append(placemark!)
            if let placemarkKey = Int(placemark!.name) {
                placemarksDict[placemarkKey] = placemark!
            }
            placemark = nil
        } else if elementName == "name" {
            placemarkName = nil
        } else if elementName == "coordinates" {
            currentCoordinates = nil
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if placemarkName != nil {
            placemarkName = string
            if let validName = placemarkID(fromString: string) {
                placemark!.name = validName
            }
            
        } else if currentCoordinates != nil {
            currentCoordinates = locationCoordinates(fromString: string)
            placemark!.coordinates.append(currentCoordinates!)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("ParseError: \(parseError)")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parsedPlacemarks = placemarks
        print("Array: \(parsedPlacemarks.count)")
        parsedPlacemarksDict = placemarksDict
        print("Dict: \(parsedPlacemarksDict.keys.count)")
    }
    
}
