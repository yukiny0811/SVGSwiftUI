//
//  UtilFunctions.swift
//  SVG2SwiftUI
//
//  Created by Yuki Kuwashima on 2025/02/27.
//

import SwiftUI

func color(from string: String) -> Color? {
    let str = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    if str == "none" { return nil }
    if str.hasPrefix("#") {
        let hex = String(str.dropFirst())
        if hex.count == 6, let intVal = Int(hex, radix: 16) {
            let r = Double((intVal >> 16) & 0xff) / 255.0
            let g = Double((intVal >> 8) & 0xff) / 255.0
            let b = Double(intVal & 0xff) / 255.0
            return Color(red: r, green: g, blue: b)
        }
    }
    return nil
}

func parseCSS(_ css: String) -> [String: [String: String]] {
    let cleaned = css.replacingOccurrences(of: "\n", with: " ")
    var rules: [String: [String: String]] = [:]
    let parts = cleaned.components(separatedBy: "}")
    for part in parts {
        let trimmed = part.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { continue }
        let comps = trimmed.components(separatedBy: "{")
        if comps.count == 2 {
            let selector = comps[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let declarations = comps[1].trimmingCharacters(in: .whitespacesAndNewlines)
            if selector.hasPrefix(".") {
                let className = String(selector.dropFirst())
                var props: [String: String] = [:]
                let decls = declarations.split(separator: ";")
                for decl in decls {
                    let pair = decl.split(separator: ":")
                    if pair.count == 2 {
                        let key = pair[0].trimmingCharacters(in: .whitespacesAndNewlines)
                        let value = pair[1].trimmingCharacters(in: .whitespacesAndNewlines)
                        props[key] = value
                    }
                }
                rules[className] = props
            }
        }
    }
    return rules
}

func parseStyle(from attributeDict: [String: String], globalCSS: [String: [String: String]]?) -> SVGStyle {
    var styleDict: [String: String] = [:]
    if let classAttr = attributeDict["class"], let globalCSS = globalCSS {
        let classes = classAttr.split(separator: " ").map { String($0) }
        for cls in classes {
            if let rules = globalCSS[cls] {
                for (key, value) in rules {
                    styleDict[key] = value
                }
            }
        }
    }
    if let styleStr = attributeDict["style"] {
        let declarations = styleStr.split(separator: ";")
        for decl in declarations {
            let pair = decl.split(separator: ":")
            if pair.count == 2 {
                let key = pair[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let value = pair[1].trimmingCharacters(in: .whitespacesAndNewlines)
                styleDict[key] = value
            }
        }
    }
    if let fill = attributeDict["fill"] {
        styleDict["fill"] = fill
    }
    if let stroke = attributeDict["stroke"] {
        styleDict["stroke"] = stroke
    }
    if let strokeWidth = attributeDict["stroke-width"] {
        styleDict["stroke-width"] = strokeWidth
    }

    let fillColor = styleDict["fill"].flatMap { color(from: $0) }
    let strokeColor = styleDict["stroke"].flatMap { color(from: $0) }
    let strokeW: CGFloat? = {
        if let sw = styleDict["stroke-width"], let value = Double(sw) {
            return CGFloat(value)
        }
        return nil
    }()
    return SVGStyle(fill: fillColor, stroke: strokeColor, strokeWidth: strokeW)
}
