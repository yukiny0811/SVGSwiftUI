//
//  File.swift
//  SVG2SwiftUI
//
//  Created by Yuki Kuwashima on 2025/02/27.
//

import SwiftUI

struct SVGPathParser {
    let pathData: String

    func parse() -> [SVGCommand] {
        var commands = [SVGCommand]()
        let scanner = Scanner(string: pathData)
        scanner.charactersToBeSkipped = CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: ","))

        while !scanner.isAtEnd {
            guard let commandChar = scanner.scanCharacter() else { break }
            switch commandChar {
            case "M", "m":
                var first = true
                while let x = scanner.scanDouble(), let y = scanner.scanDouble() {
                    let relative = (commandChar == "m")
                    let point = CGPoint(x: x, y: y)
                    if first {
                        commands.append(.moveTo(point: point, relative: relative))
                        first = false
                    } else {
                        commands.append(.lineTo(point: point, relative: relative))
                    }
                }
            case "L", "l":
                while let x = scanner.scanDouble(), let y = scanner.scanDouble() {
                    let relative = (commandChar == "l")
                    commands.append(.lineTo(point: CGPoint(x: x, y: y), relative: relative))
                }
            case "H", "h":
                while let x = scanner.scanDouble() {
                    let relative = (commandChar == "h")
                    commands.append(.horizontalLineTo(x: CGFloat(x), relative: relative))
                }
            case "V", "v":
                while let y = scanner.scanDouble() {
                    let relative = (commandChar == "v")
                    commands.append(.verticalLineTo(y: CGFloat(y), relative: relative))
                }
            case "C", "c":
                while let x1 = scanner.scanDouble(), let y1 = scanner.scanDouble(),
                      let x2 = scanner.scanDouble(), let y2 = scanner.scanDouble(),
                      let x = scanner.scanDouble(), let y = scanner.scanDouble() {
                    let relative = (commandChar == "c")
                    commands.append(
                        .cubicCurveTo(
                            control1: CGPoint(x: x1, y: y1),
                            control2: CGPoint(x: x2, y: y2),
                            end: CGPoint(x: x, y: y),
                            relative: relative
                        )
                    )
                }
            case "S", "s":
                while let x2 = scanner.scanDouble(), let y2 = scanner.scanDouble(),
                      let x = scanner.scanDouble(), let y = scanner.scanDouble() {
                    let relative = (commandChar == "s")
                    commands.append(
                        .smoothCubicCurveTo(
                            control2: CGPoint(x: x2, y: y2),
                            end: CGPoint(x: x, y: y),
                            relative: relative
                        )
                    )
                }
            case "Q", "q":
                while let x1 = scanner.scanDouble(), let y1 = scanner.scanDouble(),
                      let x = scanner.scanDouble(), let y = scanner.scanDouble() {
                    let relative = (commandChar == "q")
                    commands.append(
                        .quadraticCurveTo(
                            control: CGPoint(x: x1, y: y1),
                            end: CGPoint(x: x, y: y),
                            relative: relative
                        )
                    )
                }
            case "T", "t":
                while let x = scanner.scanDouble(), let y = scanner.scanDouble() {
                    let relative = (commandChar == "t")
                    commands.append(
                        .smoothQuadraticCurveTo(
                            end: CGPoint(x: x, y: y),
                            relative: relative
                        )
                    )
                }
            case "A", "a":
                while let rx = scanner.scanDouble(), let ry = scanner.scanDouble(),
                      let rotation = scanner.scanDouble(),
                      let largeArcValue = scanner.scanDouble(), let sweepValue = scanner.scanDouble(),
                      let x = scanner.scanDouble(), let y = scanner.scanDouble() {
                    let relative = (commandChar == "a")
                    let largeArc = largeArcValue != 0
                    let sweep = sweepValue != 0
                    commands.append(
                        .ellipticalArcTo(
                            rx: CGFloat(rx),
                            ry: CGFloat(ry),
                            xAxisRotation: CGFloat(rotation),
                            largeArc: largeArc,
                            sweep: sweep,
                            end: CGPoint(x: x, y: y),
                            relative: relative
                        )
                    )
                }
            case "Z", "z":
                commands.append(.closePath)
            default:
                break
            }
        }
        return commands
    }
}
