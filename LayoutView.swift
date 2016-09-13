import Foundation
import UIKit

class LayoutView : UIView {
    var padding : Thickness
    var viewGravities = [Int : Gravity]()
    var widthSizing : Sizing;
    var heightSizing : Sizing;
    
    init(padding : Thickness, startX : CGFloat, startY : CGFloat) {
        self.widthSizing = Sizing.Static
        self.heightSizing = Sizing.Static
        self.padding = padding
        
        super.init(frame: CGRect(x: startX, y: startY, width: 0.0, height: 0.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubview(view : UIView, gravity : Gravity) {
        self.viewGravities[view.hash] = gravity
        self.addSubview(view)
    }
    
    func performLayout() {
        
    }
    
    func getContentWidth() -> CGFloat {
        return self.frame.width - self.padding.Left - self.padding.Right;
    }
    
    func getContentHeight() -> CGFloat {
        return self.frame.height - self.padding.Top - self.padding.Bottom;
    }
    
    func getEffectiveHeightSizing() -> Sizing {
        for subview in self.subviews {
            if let sublayout = subview as? LayoutView {
                if sublayout.getEffectiveHeightSizing() == Sizing.MatchParent {
                    return Sizing.MatchParent
                }
            }
        }
        
        return self.heightSizing;
    }
    
    func getEffectiveWidthSizing() -> Sizing {
        for subview in self.subviews {
            if let sublayout = subview as? LayoutView {
                if sublayout.getEffectiveWidthSizing() == Sizing.MatchParent {
                    return Sizing.MatchParent
                }
            }
        }
        
        return self.widthSizing;
    }
}