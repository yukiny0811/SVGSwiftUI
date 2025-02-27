//
//  File.swift
//  SVG2SwiftUI
//
//  Created by Yuki Kuwashima on 2025/02/27.
//

import SwiftUI

extension Path {
    mutating func addEllipticalArc(from currentPoint: CGPoint, rx: CGFloat, ry: CGFloat, xAxisRotation: CGFloat, largeArc: Bool, sweep: Bool, endPoint: CGPoint) {
        let φ = xAxisRotation * .pi / 180

        let dx2 = (currentPoint.x - endPoint.x) / 2
        let dy2 = (currentPoint.y - endPoint.y) / 2
        let x1p = cos(φ)*dx2 + sin(φ)*dy2
        let y1p = -sin(φ)*dx2 + cos(φ)*dy2

        var rx = abs(rx)
        var ry = abs(ry)
        let rxSq = rx * rx
        let rySq = ry * ry
        let x1pSq = x1p * x1p
        let y1pSq = y1p * y1p
        let radiiCheck = x1pSq / rxSq + y1pSq / rySq
        if radiiCheck > 1 {
            let scale = sqrt(radiiCheck)
            rx *= scale
            ry *= scale
        }

        let sign: CGFloat = (largeArc == sweep) ? -1 : 1
        let numerator = rxSq * rySq - rxSq * y1pSq - rySq * x1pSq
        let denominator = rxSq * y1pSq + rySq * x1pSq
        let coef = sign * sqrt(max(0, numerator/denominator))
        let cxp = coef * (rx * y1p / ry)
        let cyp = coef * (-ry * x1p / rx)
        let cx = cos(φ)*cxp - sin(φ)*cyp + (currentPoint.x + endPoint.x)/2
        let cy = sin(φ)*cxp + cos(φ)*cyp + (currentPoint.y + endPoint.y)/2

        func angle(u: CGPoint, v: CGPoint) -> CGFloat {
            let dot = u.x*v.x + u.y*v.y
            let len = sqrt(u.x*u.x + u.y*u.y) * sqrt(v.x*v.x + v.y*v.y)
            var ang = acos(min(max(dot / len, -1), 1))
            if u.x*v.y - u.y*v.x < 0 { ang = -ang }
            return ang
        }

        let v1 = CGPoint(x: (x1p - cxp)/rx, y: (y1p - cyp)/ry)
        let v2 = CGPoint(x: (-x1p - cxp)/rx, y: (-y1p - cyp)/ry)
        let startAngle = angle(u: CGPoint(x: 1, y: 0), v: v1)
        var deltaAngle = angle(u: v1, v: v2)
        if !sweep && deltaAngle > 0 { deltaAngle -= 2 * .pi }
        else if sweep && deltaAngle < 0 { deltaAngle += 2 * .pi }

        let segments = Int(ceil(abs(deltaAngle) / (.pi/2)))
        let delta = deltaAngle / CGFloat(segments)
        var t = startAngle
        for _ in 0..<segments {
            let endAngle = t + delta
            let cp = cubicArc(from: t, to: endAngle, rx: rx, ry: ry, φ: φ, center: CGPoint(x: cx, y: cy))
            self.addCurve(to: cp.end, control1: cp.cp1, control2: cp.cp2)
            t = endAngle
        }
    }

    private func cubicArc(from startAngle: CGFloat, to endAngle: CGFloat, rx: CGFloat, ry: CGFloat, φ: CGFloat, center: CGPoint) -> (cp1: CGPoint, cp2: CGPoint, end: CGPoint) {
        let delta = endAngle - startAngle
        let t = tan(delta / 4)
        let alpha = sin(delta) * (sqrt(4 + 3 * t * t) - 1) / 3

        let start = CGPoint(x: rx * cos(startAngle), y: ry * sin(startAngle))
        let end = CGPoint(x: rx * cos(endAngle), y: ry * sin(endAngle))

        let cp1 = CGPoint(x: start.x - alpha * rx * sin(startAngle),
                          y: start.y + alpha * ry * cos(startAngle))
        let cp2 = CGPoint(x: end.x + alpha * rx * sin(endAngle),
                          y: end.y - alpha * ry * cos(endAngle))

        func transform(point: CGPoint) -> CGPoint {
            let x = point.x * cos(φ) - point.y * sin(φ) + center.x
            let y = point.x * sin(φ) + point.y * cos(φ) + center.y
            return CGPoint(x: x, y: y)
        }
        return (cp1: transform(point: cp1), cp2: transform(point: cp2), end: transform(point: end))
    }
}

