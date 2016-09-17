import Foundation
import UIKit

class LinearLayoutView: LayoutView {
    var orientation : Orientation = Orientation.Vertical
    var spacing : CGFloat = 0.0
    
    init( startX : CGFloat, startY: CGFloat, padding : Thickness) {
        super.init(padding: padding, startX: startY, startY: startY)
    }
    
    override func performLayout() {
        super.layoutSubviews()
        
        //TODO handle case where multiple subviews are match_parent.
        
        if self.orientation == Orientation.Vertical {
            self.layoutSubviewsVertically()
        } else {
            self.layoutSubviewsHorizontally()
        }
    }
    
    private func layoutSubviewsVertically() {
        let x = self.padding.Left;
        var y = self.padding.Top;
        var maxWidth : CGFloat = 0.0
        
        var matchParentChildren : Int = 0
        var totalStaticHeight : CGFloat = 0.0
        var totalStaticWidth : CGFloat = 0.0
        
        for view in self.subviews {
            if let layoutView = view as? LinearLayoutView where layoutView.getEffectiveHeightSizing() == Sizing.MatchParent {
                matchParentChildren += 1
            }
        }
        
        if matchParentChildren > 0 {
            for view in self.subviews {
                if let layoutView = view as? LayoutView {
                    if layoutView.getEffectiveHeightSizing() != Sizing.MatchParent {
                        layoutView.layoutSubviews();
                        totalStaticHeight += layoutView.frame.height
                        totalStaticWidth += layoutView.frame.width
                    }
                } else {
                    totalStaticHeight += view.frame.height
                    totalStaticWidth += view.frame.width
                }
            }
        }
        
        let effectiveHeightSizing = self.getEffectiveHeightSizing()
        let effectiveWidthSizing = self.getEffectiveWidthSizing()
        
        let dimensions = self.getMaxWidthHeightForMatchParent(self)
        
        if effectiveWidthSizing == Sizing.MatchParent {
            maxWidth = dimensions[0]
        }
        
        for view in self.subviews {
            if let layoutView = view as? LayoutView {
                if  let linearLayoutView = view as? LinearLayoutView  {
                    if layoutView.getEffectiveHeightSizing() == Sizing.MatchParent {
                        linearLayoutView.heightAvailable = (dimensions[1] - totalStaticHeight) / CGFloat(matchParentChildren) - self.padding.Bottom - self.padding.Top
                    }
                    
                    if layoutView.getEffectiveWidthSizing() == Sizing.MatchParent {
                        linearLayoutView.widthAvailable = dimensions[0] - self.padding.Left - self.padding.Right
                    }
                }
                
                layoutView.performLayout()
            }
            
            if view.frame.width > maxWidth {
                maxWidth = view.frame.width
            }
            
            view.frame = CGRect(x: x, y: y, width: view.frame.width, height: view.frame.height)
            
            y += self.spacing + view.frame.height
        }
        
        var newWidth = self.frame.width
        var newHeight = self.frame.height
        
        if widthAvailable > 0 {
            newWidth = widthAvailable
        }
        else if effectiveWidthSizing == Sizing.WrapContent {
            newWidth = maxWidth + self.padding.Right + self.padding.Left
        } else if self.widthSizing == Sizing.MatchParent {
            newWidth = maxWidth
        }
        
        if heightAvailable > 0 {
            newHeight = heightAvailable
        }
        else if effectiveHeightSizing == Sizing.MatchParent {
            newHeight = dimensions[1]
        } else {
            newHeight = y + self.padding.Bottom
        }
        
        
        self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: newWidth, height: newHeight)
    }
    
    private func layoutSubviewsHorizontally() {
        var x = self.padding.Left;
        let y = self.padding.Top;
        var maxHeight : CGFloat = 0.0
        
        let effectiveHeightSizing = self.getEffectiveHeightSizing()
        let effectiveWidthSizing = self.getEffectiveWidthSizing()
        
        let dimensions = self.getMaxWidthHeightForMatchParent(self)
        
        if effectiveWidthSizing == Sizing.MatchParent {
            maxHeight = dimensions[1]
        }
        
        for view in self.subviews {
            if let layoutView = view as? LayoutView {
                layoutView.performLayout()
            }
            
            if view.frame.height > maxHeight {
                maxHeight = view.frame.height
            }
            
            view.frame = CGRect(x: x, y: y, width: view.frame.width, height: view.frame.height)
            
            x += self.spacing + view.frame.width
        }
        
        //TODO alignment next
        
        var newWidth = self.frame.width
        var newHeight = self.frame.height
        
        if self.heightSizing != Sizing.Static {
            newHeight = maxHeight + self.padding.Top + self.padding.Bottom
        }
        
        if self.widthSizing == Sizing.MatchParent {
            newWidth = dimensions[0]
        } else if self.widthSizing == Sizing.WrapContent {
            newWidth = x + self.padding.Right
        }
        
        self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: newWidth, height: newHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}