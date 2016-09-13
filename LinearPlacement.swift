import Foundation
import UIKit

class LinearPlacement {
    private var startPadding : CGFloat = 0.0
    private var spacing : CGFloat = 0.0
    private var orientation : Orientation
    
    init(orientation : Orientation, startPadding : CGFloat, spacing : CGFloat) {
        self.spacing = spacing
        self.orientation = orientation
        self.startPadding = startPadding
    }
    
    func placeChildren(views : [UIView]) {
        
        if views.isEmpty {
            return
        }
        
        var currentOffset : CGFloat = startPadding
        
        var x : CGFloat = 0
        var y : CGFloat = 0
        
        for view in views {
            
            if self.orientation == Orientation.Horizontal {
                x = currentOffset
                y = view.frame.minY
            } else {
                x = view.frame.minX
                y = currentOffset
            }
            
            view.frame = CGRect(x: x, y: y, width: view.frame.width, height: view.frame.height)

            currentOffset += spacing + view.frame.height
        }
    }
    
    func getOrientation() -> Orientation {
        return self.orientation
    }
}