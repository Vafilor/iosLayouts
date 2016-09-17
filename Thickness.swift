import Foundation
import UIKit

struct Thickness {
    var Top : CGFloat = 0.0
    var Right : CGFloat = 0.0
    var Bottom : CGFloat = 0.0
    var Left : CGFloat = 0.0
    
    func getVerticalPadding() -> CGFloat {
        return self.Top + self.Bottom
    }
    
    func getHorizontalPadding() -> CGFloat {
        return self.Left + self.Right
    }
}
