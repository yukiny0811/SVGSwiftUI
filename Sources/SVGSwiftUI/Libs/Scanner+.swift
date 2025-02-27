//
//  File.swift
//  SVG2SwiftUI
//
//  Created by Yuki Kuwashima on 2025/02/27.
//

import SwiftUI

extension Scanner {
    func scanCharacter() -> Character? {
        if let str = scanCharacters(from: CharacterSet.letters), let first = str.first {
            return first
        }
        return nil
    }
    func scanDouble() -> Double? {
        if let value = scanDouble(representation: .decimal) {
            return value
        }
        return nil
    }
}
