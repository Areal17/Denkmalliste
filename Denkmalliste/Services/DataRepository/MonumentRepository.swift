//
//  MonumentRepository.swift
//  Denkmalliste
//
//  Created during Phase 2 refactoring
//

import Foundation

/// Protocol defining the monument data repository interface
protocol MonumentRepositoryProtocol {
    /// Load monuments from CSV file
    func loadMonuments() async throws -> [Int: Monument]

    /// Load placemarks from KML files
    func loadPlacemarks(fileNames: [String]) -> [Int: Placemark]
}

/// Repository coordinating monument data from multiple sources
class MonumentRepository: MonumentRepositoryProtocol {

    private let csvParser: CSVParser
    private let locationParser: LocationParser?

    /// Initialize repository with parsers
    /// - Parameters:
    ///   - csvParser: Parser for CSV monument data
    ///   - locationParser: Parser for KML placemark data
    init(csvParser: CSVParser = CSVParser(), locationParser: LocationParser? = nil) {
        self.csvParser = csvParser
        self.locationParser = locationParser
    }

    /// Load monuments from the bundled CSV file
    /// - Returns: Dictionary of monuments keyed by object ID
    /// - Throws: Error if file not found or parsing fails
    func loadMonuments() async throws -> [Int: Monument] {
        guard let csvFileURL = Bundle.main.url(
            forResource: AppConfiguration.csvFileName,
            withExtension: AppConfiguration.csvFileExtension
        ) else {
            throw MonumentRepositoryError.fileNotFound(AppConfiguration.csvFileName)
        }

        return try await csvParser.parseCSVFile(
            fileURL: csvFileURL,
            lineSeperator: AppConfiguration.defaultLineSeperator
        )
    }

    /// Load placemarks from KML files
    /// - Parameter fileNames: Array of KML file names (without extension)
    /// - Returns: Dictionary of placemarks keyed by monument ID
    func loadPlacemarks(fileNames: [String]) -> [Int: Placemark] {
        guard let parser = LocationParser(contentsOf: fileNames) else {
            return [:]
        }
        return parser.parsedPlacemarksDict
    }
}

/// Errors that can occur in the monument repository
enum MonumentRepositoryError: LocalizedError {
    case fileNotFound(String)
    case parsingFailed(String)
    case invalidData

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let fileName):
            return "File not found: \(fileName)"
        case .parsingFailed(let reason):
            return "Parsing failed: \(reason)"
        case .invalidData:
            return "Invalid data format"
        }
    }
}
