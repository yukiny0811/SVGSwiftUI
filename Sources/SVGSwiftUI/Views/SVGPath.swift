//
//  File.swift
//  SVG2SwiftUI
//
//  Created by Yuki Kuwashima on 2025/02/27.
//

import SwiftUI


public struct SVGPath: Shape {
    public let svgPathData: String

    public init(_ d: String) {
        self.svgPathData = d
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let commands = SVGPathParser(pathData: svgPathData).parse()
        var currentPoint = CGPoint.zero
        var lastCubicControl: CGPoint? = nil
        var lastQuadraticControl: CGPoint? = nil

        for command in commands {
            switch command {
            case .moveTo(let point, let relative):
                let newPoint = relative ? currentPoint + point : point
                path.move(to: newPoint)
                currentPoint = newPoint
                lastCubicControl = nil
                lastQuadraticControl = nil
            case .lineTo(let point, let relative):
                let newPoint = relative ? currentPoint + point : point
                path.addLine(to: newPoint)
                currentPoint = newPoint
                lastCubicControl = nil
                lastQuadraticControl = nil
            case .horizontalLineTo(let x, let relative):
                let newX = relative ? currentPoint.x + x : x
                let newPoint = CGPoint(x: newX, y: currentPoint.y)
                path.addLine(to: newPoint)
                currentPoint = newPoint
                lastCubicControl = nil
                lastQuadraticControl = nil
            case .verticalLineTo(let y, let relative):
                let newY = relative ? currentPoint.y + y : y
                let newPoint = CGPoint(x: currentPoint.x, y: newY)
                path.addLine(to: newPoint)
                currentPoint = newPoint
                lastCubicControl = nil
                lastQuadraticControl = nil
            case .cubicCurveTo(let control1, let control2, let end, let relative):
                let c1 = relative ? currentPoint + control1 : control1
                let c2 = relative ? currentPoint + control2 : control2
                let newPoint = relative ? currentPoint + end : end
                path.addCurve(to: newPoint, control1: c1, control2: c2)
                lastCubicControl = c2
                currentPoint = newPoint
                lastQuadraticControl = nil
            case .smoothCubicCurveTo(let control2, let end, let relative):
                let c1: CGPoint = lastCubicControl != nil
                    ? CGPoint(x: 2 * currentPoint.x - lastCubicControl!.x,
                              y: 2 * currentPoint.y - lastCubicControl!.y)
                    : currentPoint
                let c2 = relative ? currentPoint + control2 : control2
                let newPoint = relative ? currentPoint + end : end
                path.addCurve(to: newPoint, control1: c1, control2: c2)
                lastCubicControl = c2
                currentPoint = newPoint
                lastQuadraticControl = nil
            case .quadraticCurveTo(let control, let end, let relative):
                let c = relative ? currentPoint + control : control
                let newPoint = relative ? currentPoint + end : end
                path.addQuadCurve(to: newPoint, control: c)
                lastQuadraticControl = c
                currentPoint = newPoint
                lastCubicControl = nil
            case .smoothQuadraticCurveTo(let end, let relative):
                let c: CGPoint = lastQuadraticControl != nil
                    ? CGPoint(x: 2 * currentPoint.x - lastQuadraticControl!.x,
                              y: 2 * currentPoint.y - lastQuadraticControl!.y)
                    : currentPoint
                let newPoint = relative ? currentPoint + end : end
                path.addQuadCurve(to: newPoint, control: c)
                lastQuadraticControl = c
                currentPoint = newPoint
                lastCubicControl = nil
            case .ellipticalArcTo(let rx, let ry, let xAxisRotation, let largeArc, let sweep, let end, let relative):
                let newEnd = relative ? currentPoint + end : end
                path.addEllipticalArc(
                    from: currentPoint,
                    rx: rx,
                    ry: ry,
                    xAxisRotation: xAxisRotation,
                    largeArc: largeArc,
                    sweep: sweep,
                    endPoint: newEnd
                )
                currentPoint = newEnd
                lastCubicControl = nil
                lastQuadraticControl = nil
            case .closePath:
                path.closeSubpath()
            }
        }
        return path
    }
}
