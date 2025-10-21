//
//  AppConfiguration.swift
//  Denkmalliste
//
//  Created during refactoring
//

import Foundation

/// Central configuration for the Denkmalliste app
struct AppConfiguration {

    // MARK: - Data Files

    /// CSV file containing monument metadata
    static let csvFileName = "denkmalliste_berlin"
    static let csvFileExtension = "csv"

    /// KML files containing monument coordinates
    enum KMLFile: String, CaseIterable {
        case building = "baudenkmal"
        case garden = "gartendenkmal"
        case ensemble = "ensembleteil"
        case ground = "bodendenkmal"
        case area = "denkmalbereich"

        var fileName: String {
            return self.rawValue
        }

        var fileExtension: String {
            return "kml"
        }
    }

    /// All KML file names to be parsed
    static var allKMLFileNames: [String] {
        return KMLFile.allCases.map { $0.fileName }
    }

    // MARK: - Map Configuration

    /// Default map region center (Berlin)
    struct MapDefaults {
        static let latitude: Double = 52.520008
        static let longitude: Double = 13.404954
        static let latitudeDelta: Double = 0.1
        static let longitudeDelta: Double = 0.1
    }

    // MARK: - Parser Configuration

    /// Default line separator for CSV parsing
    static let defaultLineSeperator = ControlCharacter.lineFeed
}
