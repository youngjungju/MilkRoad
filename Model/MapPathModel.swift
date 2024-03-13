import SwiftUI

struct SunGraph: Shape {
    func path(in rect: CGRect) -> Path {
        let width: CGFloat = rect.size.width
        let height: CGFloat = rect.size.height

        let startPoint = CGPoint(x: 0, y: height)
        let controlPoint1 = CGPoint(x: width / 4, y: -height / 4)
        let endPoint1 = CGPoint(x: width / 2, y: height / 2)

        let startPoint2 = endPoint1
        let controlPoint2 = CGPoint(x: (3 * width) / 4, y: height + (height / 4))
        let endPoint2 = CGPoint(x: width, y: 0)

        var path = Path()
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint1, control: controlPoint1)

        path.move(to: startPoint2)
        path.addQuadCurve(to: endPoint2, control: controlPoint2)

        return path
    }
}
