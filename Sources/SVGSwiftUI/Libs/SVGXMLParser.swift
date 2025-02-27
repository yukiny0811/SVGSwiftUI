//
//  File.swift
//  SVG2SwiftUI
//
//  Created by Yuki Kuwashima on 2025/02/27.
//

import SwiftUI

class SVGXMLParser: NSObject, XMLParserDelegate {
    var drawables: [SVGDrawable] = []
    var globalCSS: [String: [String: String]] = [:]
    var currentStyleContent: String = ""
    var viewBox: CGRect? = nil

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        if elementName == "svg" {
            if let viewBoxStr = attributeDict["viewBox"] {
                let comps = viewBoxStr.split(separator: " ").compactMap { Double($0) }
                if comps.count == 4 {
                    viewBox = CGRect(x: comps[0], y: comps[1], width: comps[2], height: comps[3])
                }
            }
        }

        if elementName == "style" {
            currentStyleContent = ""
        } else {
            let style = parseStyle(from: attributeDict, globalCSS: globalCSS)
            switch elementName {
            case "path":
                if let d = attributeDict["d"] {
                    drawables.append(SVGDrawable(element: .path(d), style: style))
                }
            case "circle":
                if let cx = attributeDict["cx"], let cy = attributeDict["cy"], let r = attributeDict["r"],
                   let cxVal = Double(cx), let cyVal = Double(cy), let rVal = Double(r) {
                    drawables.append(SVGDrawable(element: .circle(cx: CGFloat(cxVal), cy: CGFloat(cyVal), r: CGFloat(rVal)), style: style))
                }
            case "rect":
                if let x = attributeDict["x"], let y = attributeDict["y"],
                   let width = attributeDict["width"], let height = attributeDict["height"],
                   let xVal = Double(x), let yVal = Double(y), let wVal = Double(width), let hVal = Double(height) {
                    drawables.append(SVGDrawable(element: .rect(x: CGFloat(xVal), y: CGFloat(yVal), width: CGFloat(wVal), height: CGFloat(hVal)), style: style))
                }
            case "ellipse":
                if let cx = attributeDict["cx"], let cy = attributeDict["cy"],
                   let rx = attributeDict["rx"], let ry = attributeDict["ry"],
                   let cxVal = Double(cx), let cyVal = Double(cy), let rxVal = Double(rx), let ryVal = Double(ry) {
                    drawables.append(SVGDrawable(element: .ellipse(cx: CGFloat(cxVal), cy: CGFloat(cyVal), rx: CGFloat(rxVal), ry: CGFloat(ryVal)), style: style))
                }
            case "line":
                if let x1 = attributeDict["x1"], let y1 = attributeDict["y1"],
                   let x2 = attributeDict["x2"], let y2 = attributeDict["y2"],
                   let x1Val = Double(x1), let y1Val = Double(y1), let x2Val = Double(x2), let y2Val = Double(y2) {
                    drawables.append(SVGDrawable(element: .line(x1: CGFloat(x1Val), y1: CGFloat(y1Val), x2: CGFloat(x2Val), y2: CGFloat(y2Val)), style: style))
                }
            case "polygon":
                if let pointsStr = attributeDict["points"] {
                    let points = SVGXMLParser.parsePoints(from: pointsStr)
                    drawables.append(SVGDrawable(element: .polygon(points: points), style: style))
                }
            case "polyline":
                if let pointsStr = attributeDict["points"] {
                    let points = SVGXMLParser.parsePoints(from: pointsStr)
                    drawables.append(SVGDrawable(element: .polyline(points: points), style: style))
                }
            default:
                break
            }
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentStyleContent += string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "style" {
            globalCSS = parseCSS(currentStyleContent)
        }
    }

    static func parsePoints(from string: String) -> [CGPoint] {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let components = trimmed.components(separatedBy: CharacterSet.whitespaces)
        var points: [CGPoint] = []
        for comp in components {
            let pair = comp.split(separator: ",")
            if pair.count == 2, let x = Double(pair[0]), let y = Double(pair[1]) {
                points.append(CGPoint(x: CGFloat(x), y: CGFloat(y)))
            }
        }
        return points
    }
}
