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


class CSVParser {
//    TODO: Ändern! Rückgabe soll Dict mit der ObjDocNr als Key und Momnument Struct als Value
    
    func parseCSVFile(fileURL: URL, lineSeperator: ControlCharacter) async throws -> [[String:String]] {
        var csvSubstringLines: [Substring]!
        do {
            let csvContent = try String(contentsOf: fileURL, encoding: .ascii)
            csvSubstringLines = csvContent.split(separator: lineSeperator.rawValue)
        } catch {
            print("ReadError: \(error)")
            throw error
        }
        var csvContentLine = [String: String]()
        var csvContentLines = [[String: String]]()
        let header = csvSubstringLines.removeFirst()
        let headerElements = header.split(separator: ";")
        for line in csvSubstringLines {
            let lineElements = line.split(separator: ";")
            for (idx, headerElement) in headerElements.enumerated() {
                if lineElements.indices.contains(idx) {
                    csvContentLine[String(headerElement)] = String(lineElements[idx])
                }
            }
            csvContentLines.append(csvContentLine)
        }
        return csvContentLines
    }
    
}
