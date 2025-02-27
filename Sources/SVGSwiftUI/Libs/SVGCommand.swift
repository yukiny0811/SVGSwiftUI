//
//  File.swift
//  SVG2SwiftUI
//
//  Created by Yuki Kuwashima on 2025/02/27.
//

import SwiftUI

enum SVGCommand {
    case moveTo(point: CGPoint, relative: Bool)
    case lineTo(point: CGPoint, relative: Bool)
    case horizontalLineTo(x: CGFloat, relative: Bool)
    case verticalLineTo(y: CGFloat, relative: Bool)
    case cubicCurveTo(control1: CGPoint, control2: CGPoint, end: CGPoint, relative: Bool)
    case smoothCubicCurveTo(control2: CGPoint, end: CGPoint, relative: Bool)
    case quadraticCurveTo(control: CGPoint, end: CGPoint, relative: Bool)
    case smoothQuadraticCurveTo(end: CGPoint, relative: Bool)
    case ellipticalArcTo(rx: CGFloat, ry: CGFloat, xAxisRotation: CGFloat, largeArc: Bool, sweep: Bool, end: CGPoint, relative: Bool)
    case closePath
}
