//
//  Monument.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 18.12.21.
//  Refactored: Extracted from CSVParser.swift
//

import Foundation

/// Control characters used in CSV parsing
enum ControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
    case nextLine = "\u{0085}"
    case lineSeparator = "\u{2028}"
    case formFeed = "\u{000B}"
    case windowsLineFeed = "\u{000D}\u{000A}"
}

/// Represents a historical monument with its metadata
struct Monument {

    /// Types of monuments
    enum KindOfMonument: String, Codable {
        case none = "NA"
        case ensemble = "Ensemble"
        case complex = "Gesamtanlage"
        case monument = "Baudenkmal"
        case groundMonument = "Bodendenkmal"
        case gardenMonument = "Gartendenkmal"
    }

    /// Status of the monument within an ensemble
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
