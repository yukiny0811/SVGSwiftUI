# SVGSwiftUI

[![Release](https://img.shields.io/github/v/release/yukiny0811/SVGSwiftUI)](https://github.com/yukiny0811/SVGSwiftUI/releases/latest)
[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2FSVGSwiftUI%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/yukiny0811/SVGSwiftUI)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2FSVGSwiftUI%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/yukiny0811/SVGSwiftUI)
[![License](https://img.shields.io/github/license/yukiny0811/SVGSwiftUI)](https://github.com/yukiny0811/SVGSwiftUI/blob/main/LICENSE)

__SVGView for SwiftUI.__   
Creates SwiftUI Path for any SVG file.

<img width="1234" alt="image" src="https://github.com/user-attachments/assets/068b48f5-0c87-48a4-8487-7dcbd3ae5744" />

### Basic Usage

```swift
struct Sample1: View {
    var body: some View {
        SVGView(url: Bundle.main.url(forResource: "sample", withExtension: "svg")!)
    }
}
```

### Per-Path Configuration

```swift
struct Sample4: View {
    var body: some View {
        SVGView(url: Bundle.main.url(forResource: "sample", withExtension: "svg")!) { index, path in
            if index == 0 {
                return path
            } else {
                return path.fill(Color.black)
            }
        }
    }
}
```

<img width="1232" alt="image" src="https://github.com/user-attachments/assets/7681b0e1-3566-4b05-8dd7-94e5f90969b3" />

### Per-Path Animation (or colorize)

```swift
struct Sample2: View {

    @State var offsets: [CGSize] = []

    var body: some View {
        SVGView(url: Bundle.main.url(forResource: "sample", withExtension: "svg")!) { index, path in
            if offsets.count > index {
                return path.offset(offsets[index])
            } else {
                return path
            }
        }
        .onTapGesture {
            for i in 0..<offsets.count {
                offsets[i] = CGSize(width: CGFloat.random(in: -20...20), height: CGFloat.random(in: -20...20))
            }
            withAnimation {
                for i in 0..<offsets.count {
                    offsets[i] = CGSize(width: 0, height: 0)
                }
            }
        }
        .onAppear {
            for _ in 0..<30 {
                offsets.append(CGSize(width: 0, height: 0))
            }
        }
    }
}
```

![画面収録 2025-02-27 19 39 19_1_1](https://github.com/user-attachments/assets/79416564-de94-4173-9643-fc73411dd838)

### Direct Path Rendering

```swift
struct Sample3: View {
    var body: some View {
        SVGPath("M25.08,6.93c-1.45-.92-4.62-2.31-8.84-2.31-7,0-9.63,4.29-9.63,7.92,0,4.95,3.04,7.46,9.77,10.29,8.12,3.43,12.28,7.59,12.28,14.78,0,7.99-5.81,14.12-16.63,14.12-4.55,0-9.5-1.39-12.01-3.17l1.52-4.55c2.71,1.78,6.73,3.1,10.82,3.1,6.73,0,10.69-3.63,10.69-9.04,0-4.95-2.71-7.99-9.24-10.62C6.2,24.62,1.06,20.19,1.06,13.26,1.06,5.61,7.26,0,16.43,0c4.75,0,8.38,1.19,10.29,2.38l-1.65,4.55Z")
            .stroke(
                Color.red,
                style: StrokeStyle(
                    lineWidth: 1.0,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .fill(Color.black)
            .offset(x: 100, y: 100)
    }
}
```

## Supported Platforms
- Swift5.9
- iOS 17.0
- macOS 14.0
- visionOS 1.0
