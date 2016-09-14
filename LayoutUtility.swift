import UIKit

/**
 Helper methods to position and size UI elements.
*/
class LayoutUtility {
    
    
    static func lengthThatFits(containerLength : CGFloat, numberElements : Int, paddingBetweenElements : CGFloat, startPadding : CGFloat, endPadding : CGFloat) -> CGFloat
    {
        var totalPadding = startPadding + endPadding;
        totalPadding += paddingBetweenElements * CGFloat(numberElements - 1);
        
        return (containerLength - totalPadding) / CGFloat(numberElements);
    }
    
    static func positionForCenter(containerLength : CGFloat, width : CGFloat ) -> CGFloat {
        return CGFloat( (containerLength - width) / 2.0 );
    }
    
    static func alignFrame(orientation : Orientation, alignment : Gravity, frame : CGRect, containingFrame : CGRect, padding : Thickness) -> CGRect
    {
        
//        if orientation == Orientation.Horizontal {
//            if alignment == Alignment.Center {
//                return CGRect( x: (containingFrame.width - frame.width) / 2.0, y: frame.minY, width: frame.width, height: frame.height)
//            }
//            
//            if alignment == Alignment.Expand {
//                return CGRect(x: containingFrame.minX + padding.Left, y: frame.minY, width: containingFrame.width - padding.Left - padding.Right , height: containingFrame.height)
//            }
//        }
        //TODO other alignment's and orientations
        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }

}
