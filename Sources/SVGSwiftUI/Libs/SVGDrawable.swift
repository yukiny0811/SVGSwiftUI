//
//  File.swift
//  SVG2SwiftUI
//
//  Created by Yuki Kuwashima on 2025/02/27.
//

import SwiftUI

struct SVGDrawable {
    let element: SVGElement
    let style: SVGStyle
}

extension SVGDrawable {
    func draw() -> StrokeShapeView<Path, Color, _ShapeView<Path, Color>> {
        let shape: Path = {
            switch element {
            case .path(let d):
                let svgPath = SVGPath(d)
                let p = svgPath.path(in: .zero)
                return Path { path in path.addPath(p) }
            case .circle(let cx, let cy, let r):
                return Path { path in
                    path.addEllipse(in: CGRect(x: cx - r, y: cy - r, width: 2 * r, height: 2 * r))
                }
            case .rect(let x, let y, let width, let height):
                return Path { path in
                    path.addRect(CGRect(x: x, y: y, width: width, height: height))
                }
            case .ellipse(let cx, let cy, let rx, let ry):
                return Path { path in
                    let rect = CGRect(x: cx - rx, y: cy - ry, width: 2 * rx, height: 2 * ry)
                    path.addEllipse(in: rect)
                }
            case .line(let x1, let y1, let x2, let y2):
                return Path { path in
                    path.move(to: CGPoint(x: x1, y: y1))
                    path.addLine(to: CGPoint(x: x2, y: y2))
                }
            case .polygon(let points):
                return Path { path in
                    guard let first = points.first else { return }
                    path.move(to: first)
                    for pt in points.dropFirst() { path.addLine(to: pt) }
                    path.closeSubpath()
                }
            case .polyline(let points):
                return Path { path in
                    guard let first = points.first else { return }
                    path.move(to: first)
                    for pt in points.dropFirst() { path.addLine(to: pt) }
                }
            }
        }()

        if let fill = style.fill, let stroke = style.stroke {
            return shape.fill(fill).stroke(
                stroke,
                style: StrokeStyle(
                    lineWidth: style.strokeWidth ?? 1.0,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
        } else if let fill = style.fill {
            return shape.fill(fill).stroke(Color.clear)
        } else if let stroke = style.stroke {
            return shape.fill(Color.clear).stroke(
                stroke,
                style: StrokeStyle(
                    lineWidth: style.strokeWidth ?? 1.0,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
        } else {
            return shape.fill(Color.black).stroke(
                Color.clear,
                style: StrokeStyle(
                    lineWidth: style.strokeWidth ?? 1.0,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
        }
    }
}
