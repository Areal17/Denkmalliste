//
//  CSVParser.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 18.12.21.
//  Refactored: Extracted Monument model to separate file
//

import Foundation

/// Parses CSV files containing monument data
class CSVParser {

    /// Parses a CSV file and returns a dictionary of monuments.
    /// - Parameters:
    ///   - fileURL: The URL of the CSV file to parse.
    ///   - lineSeperator: The character used to separate lines in the CSV file.
    /// - Returns: A dictionary of monuments, where the key is the object number and the value is the Monument object.
    /// - Throws: An error if there is an issue reading the CSV file or parsing its contents.
    func parseCSVFile(fileURL: URL, lineSeperator: ControlCharacter) async throws -> [Int: Monument] {
        var csvSubstringLines: [Substring]!
        do {
            let csvContent = try String(contentsOf: fileURL, encoding: .ascii)
            csvSubstringLines = csvContent.split(separator: lineSeperator.rawValue)
        } catch {
            print("ReadError: \(error)")
            throw error
        }
        var monuments = [Int: Monument]()
        let header = csvSubstringLines.removeFirst()
        let headerElements = header.split(separator: ";")
        for line in csvSubstringLines {
            let lineElements = line.split(separator: ";")
            var currentMonument = Monument()
            var objectNumber: Int?
            for (idx, headerElement) in headerElements.enumerated() {
                if lineElements.indices.contains(idx) {
                    switch String(headerElement) {
                        case "Zugehörigkeit":
                            currentMonument.belongsTo = String(lineElements[idx])
                        case "ObjDokNr":
                            objectNumber = Int(lineElements[idx])
                            currentMonument.objectDocNr = Int(lineElements[idx])
                        case "Datierung":
                            currentMonument.dating = String(lineElements[idx])
                        case "Denkmalart":
                            currentMonument.kindOfMonument = Monument.KindOfMonument(rawValue: String(lineElements[idx])) ?? .none
                        case "Bezirk":
                            currentMonument.borough = String(lineElements[idx])
                        case "EnsembleStatus":
                            currentMonument.ensembleState = Monument.EnsembleStatus(rawValue: String(lineElements[idx])) ?? .none
                        case "Ortsteil":
                            currentMonument.locality = String(lineElements[idx])
                        case "Beschreibung":
                            currentMonument.monumentDescription = String(lineElements[idx])
                        case "Architekt/Künstler":
                            currentMonument.architect = String(lineElements[idx])
                        case "Adresse":
                            currentMonument.address = String(lineElements[idx])
                        case "WeitereInformationen":
                            currentMonument.furtherInformation = String(lineElements[idx])
                        case "Eintragung":
                            currentMonument.entry = String(lineElements[idx])
                        default:
                            print("Kein Monumenten Eintrag")
                    }
            }
        }
        monuments[objectNumber!] = currentMonument
    }
    return monuments
    }
}


