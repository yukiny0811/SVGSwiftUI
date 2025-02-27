//
//  File.swift
//  SVG2SwiftUI
//
//  Created by Yuki Kuwashima on 2025/02/27.
//

import SwiftUI

public struct SVGView: View {
    let drawables: [SVGDrawable]
    let viewBox: CGRect?

    let elementTransform: ((_ index: Int, _ path: StrokeShapeView<Path, Color, _ShapeView<Path, Color>>) -> any View)?

    public init(
        svgData: Data,
        _ elementTransform: ((_ index: Int, _ path: StrokeShapeView<Path, Color, _ShapeView<Path, Color>>) -> any View)? = nil
    ) {
        let parser = XMLParser(data: svgData)
        let svgParser = SVGXMLParser()
        parser.delegate = svgParser
        parser.parse()
        self.drawables = svgParser.drawables
        self.viewBox = svgParser.viewBox

        self.elementTransform = elementTransform
    }

    public init?(
        url: URL,
        _ elementTransform: ((_ index: Int, _ path: StrokeShapeView<Path, Color, _ShapeView<Path, Color>>) -> any View)? = nil
    ) {
        guard let svgData = try? Data(contentsOf: url) else {
            return nil
        }
        let parser = XMLParser(data: svgData)
        let svgParser = SVGXMLParser()
        parser.delegate = svgParser
        parser.parse()
        self.drawables = svgParser.drawables
        self.viewBox = svgParser.viewBox

        self.elementTransform = elementTransform
    }

    public var body: some View {
        GeometryReader { geometry in
            let offset: CGSize = {
                if let vb = viewBox {
                    let svgCenter = CGPoint(x: vb.midX, y: vb.midY)
                    let viewCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    return CGSize(width: viewCenter.x - svgCenter.x, height: viewCenter.y - svgCenter.y)
                } else {
                    return .zero
                }
            }()

            ZStack {
                ForEach(0..<drawables.count, id: \.self) { idx in
                    if let elementTransform {
                        AnyView(elementTransform(idx, drawables[idx].draw()))
                    } else {
                        drawables[idx].draw()
                    }
                }
            }
            .offset(offset)
        }
    }
}
