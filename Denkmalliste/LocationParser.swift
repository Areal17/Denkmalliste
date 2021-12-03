//
//  LocationParser.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 02.12.21.
//

import UIKit
import CoreLocation


struct Placemark {
    var name: String
    var coordinates: CLLocationCoordinate2D?
    
    init() {
        self.name = "k.A"
    }
}



class LocationParser: NSObject, XMLParserDelegate {
    
    let kmlParser: XMLParser?
    var placemark: Placemark?
    var placemarks = [Placemark]()
    var currentCoordinates: CLLocationCoordinate2D?
    var placemarkName: String?
    
    init?(contentsOf: URL) {
        kmlParser = XMLParser(contentsOf: contentsOf)
        super.init()
        if kmlParser != nil {
            kmlParser!.delegate = self
            kmlParser!.shouldProcessNamespaces = false
            kmlParser!.parse()
        }
    }
    
    func parseDocument(){
        assert(kmlParser != nil, "Parser didn't initialized. Check the URL of the document to parse")
        kmlParser!.parse()
    }
    
    private func getPlaceMarkID(name: String) -> String {
        var name = name
        name = name.replacingOccurrences(of: "Punkt ", with: "")
        name.removeFirst()
        return name
    }
    
    private func getCurrentCoordinates(coordinateString: String) -> CLLocationCoordinate2D {
        let coordinateString = coordinateString.split(separator: ",")
        if let latitude = CLLocationDegrees(coordinateString.first!), let longitude = CLLocationDegrees(coordinateString[1]) {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return CLLocationCoordinate2D()
    }
    
    // pragma mark - XMLParserDelegte
    
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    
    func parser(_ parser: XMLParser, foundElementDeclarationWithName elementName: String, model: String) {
        print(elementName)
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "Placemark" {
            placemark = Placemark()
        } else if elementName == "name" {
            placemarkName = String()
        } else if elementName == "coordinates" {
            currentCoordinates = CLLocationCoordinate2D()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Placemark" {
            placemarks.append(placemark!)
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
            placemark?.name = getPlaceMarkID(name: placemarkName!)
        } else if currentCoordinates != nil {
            currentCoordinates = getCurrentCoordinates(coordinateString: string)
            placemark?.coordinates =  currentCoordinates
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Placemarks: \(placemarks)")
        let nc = NotificationCenter.default
        let placemarksToSend = ["pacemarks": placemarks]
        nc.post(name: NSNotification.Name("placemarkNotification"), object: nil, userInfo: placemarksToSend)
    }
    
}
