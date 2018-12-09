import Foundation
import UIKit

open class dsHelper {
    open class func greenColor() -> UIColor {
        return UIColor(red: 0.0, green: 128/255, blue: 0.0, alpha: 1)
    }
    
    open class func yellowColor() -> UIColor {
        return UIColor(red: 232/255, green: 205/255, blue: 0.0, alpha: 1)
    }
    
    open class func redColor() -> UIColor {
        return UIColor(red: 195/255, green: 0.0, blue: 0.0, alpha: 1)
    }
    
    open class func purpleColor() -> UIColor {
        return UIColor(red: 141/255, green: 0.0, blue: 1.0, alpha: 1)
    }

    open class func getNavBarAttributes() -> NSDictionary
    {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.clear
        
        return NSDictionary(objects: [redColor(), shadow, UIFont(name: "Copperplate", size: 18.0)!], forKeys: [NSAttributedString.Key.foregroundColor  as NSCopying, NSAttributedString.Key.shadow as NSCopying, NSAttributedString.Key.font as NSCopying])
    }

}
