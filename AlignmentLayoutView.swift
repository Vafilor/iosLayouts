import Foundation
import UIKit

class AlignmentLayoutView: LayoutView {
    
    var childView : UIView? = nil;
    
    override func addSubview(view: UIView, gravity : Int) {
        //TODO error on adding more than one view
        self.childView = view
        super.addSubview(view, gravity: gravity)
    }
    
    override func performLayout() {
        //TODO error if no child
        let effectiveHeightSizing = self.getEffectiveHeightSizing()
        let effectiveWidthSizing = self.getEffectiveWidthSizing()
        
        var newHeight = self.frame.height
        var newWidth = self.frame.width
        
        var sizeChild = false
        
        let dimensions = self.getMaxWidthHeightForMatchParent(self)

        if effectiveWidthSizing == Sizing.MatchParent {
            sizeChild = true
            
            if self.widthAvailable > 0 {
                newWidth = self.widthAvailable
            } else {
                newWidth = dimensions[0]
            }
        }
        
        if effectiveHeightSizing == Sizing.MatchParent {
            sizeChild = true
            
            if self.heightAvailable > 0 {
                newHeight = self.heightAvailable
            } else {
                newHeight = dimensions[1]
            }
        }
        
        if sizeChild {
            if let childLayout = self.childView as? LayoutView {
                childLayout.heightAvailable = newHeight - self.padding.getVerticalPadding()
                childLayout.widthAvailable = newWidth - self.padding.getHorizontalPadding()
            }
        }
        
        if let layoutView = self.childView as? LayoutView {
            layoutView.performLayout()
        }
        
        if effectiveWidthSizing == Sizing.WrapContent {
            newWidth = childView!.frame.width + self.padding.getHorizontalPadding()
        }
        
        if effectiveHeightSizing == Sizing.WrapContent {
            newHeight = childView!.frame.height + self.padding.getVerticalPadding()
        }
        
        self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: newWidth, height: newHeight)
        
        if let childView = self.childView {
            //Position Child
            self.positionChildView(childView, gravity: self.viewGravities[childView.hashValue]!)
        }
        
    }
    
    func positionChildView(view : UIView, gravity : Int) {
        
        var newFrame = view.frame
        
        if gravity & Gravity.Left.rawValue > 0 {
            newFrame = AlignmentLayoutView.leftAlign(self.frame, child: newFrame)
            newFrame.offsetInPlace(dx: self.padding.Left, dy: 0.0)
        }
        
        if gravity & Gravity.Right.rawValue > 0 {
            newFrame = AlignmentLayoutView.rightAlign(self.frame, child: newFrame)
            newFrame.offsetInPlace(dx: -self.padding.Right, dy: 0.0)
        }
        
        if gravity & Gravity.CenterHorizontal.rawValue > 0 {
            newFrame = AlignmentLayoutView.centerHorizontalAlign(self.frame, child: newFrame)
        }
        
        if gravity & Gravity.Bottom.rawValue > 0 {
            newFrame = AlignmentLayoutView.bottomAlign(self.frame, child: newFrame)
            newFrame.offsetInPlace(dx: 0.0, dy: -self.padding.Bottom)
        }
        
        if gravity & Gravity.Top.rawValue > 0 {
            newFrame = AlignmentLayoutView.topAlign(self.frame, child: newFrame)
            newFrame.offsetInPlace(dx: 0.0, dy: self.padding.Top)
        }
        
        if gravity & Gravity.CenterVertical.rawValue > 0 {
            newFrame = AlignmentLayoutView.centerVerticalAlign(self.frame, child: newFrame)
        }
        
        //No need to do Center - as CenterVertical and CenterHorizontal above take care of it
        
        if gravity & Gravity.FillHorizontal.rawValue > 0 {
            newFrame = AlignmentLayoutView.horizontalFillAlign(self.frame, child: newFrame)
            newFrame.insetInPlace(dx: self.padding.getHorizontalPadding() / 2.0, dy: 0.0)
            newFrame = AlignmentLayoutView.leftAlign(self.frame, child: newFrame)
            newFrame.offsetInPlace(dx: self.padding.Left, dy: 0.0)
        }
        
        if gravity & Gravity.FillVertical.rawValue > 0 {
            newFrame = AlignmentLayoutView.verticalFillAlign(self.frame, child: newFrame)
            newFrame.insetInPlace(dx: 0.0, dy: self.padding.getVerticalPadding() / 2.0)
            newFrame = AlignmentLayoutView.topAlign(self.frame, child: newFrame)
            newFrame.offsetInPlace(dx: 0.0, dy: self.padding.Top)
        }
        
        view.frame = newFrame
    }
    
    static func leftAlign(parent : CGRect, child : CGRect) -> CGRect {
        return CGRect(x: 0, y: child.minY, width: child.width, height: child.height)
    }
    
    static func rightAlign(parent : CGRect, child : CGRect) -> CGRect {
        return CGRect(x: parent.width - child.width, y: child.minY, width: child.width, height: child.height)
    }
    
    static func topAlign(parent : CGRect, child : CGRect) -> CGRect {
        return CGRect(x: child.minX, y: 0, width: child.width, height: child.height)
    }
    
    static func bottomAlign(parent : CGRect, child : CGRect) -> CGRect {
        return CGRect(x: child.minX, y: parent.height - child.height, width: child.width, height: child.height)
    }
    
    static func centerHorizontalAlign(parent : CGRect, child : CGRect) -> CGRect {
        return CGRect(x: (parent.width - child.width) / 2.0, y: child.minY, width: child.width, height: child.height)
    }
    
    static func centerVerticalAlign(parent : CGRect, child : CGRect) -> CGRect {
        return CGRect(x: child.minX, y: (parent.height - child.height) / 2.0, width: child.width, height: child.height)
    }
    
    static func horizontalFillAlign(parent : CGRect, child : CGRect) -> CGRect {
        return CGRect(x: 0, y: child.minY, width: parent.width, height: child.height)
    }
    
    static func verticalFillAlign(parent : CGRect, child : CGRect) -> CGRect {
        return CGRect(x: child.minX, y: child.minY, width: child.width, height: parent.height)
    }
}