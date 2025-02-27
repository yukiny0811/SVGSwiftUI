//
//  File.swift
//  SVG2SwiftUI
//
//  Created by Yuki Kuwashima on 2025/02/27.
//

import SwiftUI

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
