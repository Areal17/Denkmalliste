//
//  CSVParser.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 18.12.21.
//

import Foundation


enum ControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
    case nextLine = "\u{0085}"
    case lineSeparator = "\u{2028}"
    case formFeed = "\u{000B}"
    case windowsLineFeed = "\u{000D}\u{000A}"
}


struct Monument {
    
    enum KindOfMonument: String, Codable {
        case none = "NA"
        case ensemble = "Ensemble"
        case gesamtanlage = "Gesamtanlage"
        case monument = "Baudenkmal"
        case groundMonument = "Bodendenkmal"
        case gardenMonument = "Gartendenkmal"
    }

    // ensamble haben einen ensambleStatus, der eine enum sein soll mit folgenden Werten: none, haupt, weitererBestandteil

    enum EnsembleStatus: String, Codable {
        case none = "NA"
        case main = "Haupt"
        case additional = "Weiterer Bestandteil"
    }
   
    private enum CodingKeys: String, CodingKey {
        case objectDocNr = "ObjDokNr"
        case locality = "Ortsteil"
        case borough = "Bezirk"
        case kindOfMonument = "Denkmalart"
        case ensembleState = "EnsembleStatus"
        case address = "Adresse"
        case belongsTo  = "Zugehörigkeit"
        case architect = "Architekt/Künstler"
        case furtherInformation = "WeitereInformationen"
        case monumentDescription = "Beschreibung"
        case dating = "Datierung"
        case entry = "Eintragung"
    }
    
    var objectDocNr: Int?
    var locality: String = ""
    var borough: String = ""
    var kindOfMonument: KindOfMonument = .none
    var ensembleState: EnsembleStatus = .none
    var address: String = ""
    var belongsTo: String = ""
    var architect: String = ""
    var furtherInformation: String = ""
    var monumentDescription: String = ""
    var dating: String = ""
    var entry: String = ""
    var placemark: Placemark?
}


class CSVParser {
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


