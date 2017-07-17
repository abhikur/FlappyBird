import Foundation
import CoreGraphics

public extension CGFloat {

    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min : CGFloat, max : CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}
