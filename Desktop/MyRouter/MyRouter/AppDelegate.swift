//
//  AppDelegate.swift
//  MyRouter
//
//  Created by 罗石清 on 2021/4/7.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        let vc1 = ViewController()
        let nav = UINavigationController(rootViewController: vc1)
        if #available(iOS 11.0, *) {
            nav.navigationBar.shadowImage = UIImage()
        }
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font:UIFont.boldAuto(font: 18),
            NSAttributedString.Key.foregroundColor:UIColor.hexColor(with: "#333333")!
        ]
        nav.navigationBar.backgroundColor = UIColor.white
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        return true
    }

  

}

extension UIFont {
    
    enum FontType: String {
        case thin       = "PingFangSC-Thin"
        case light      = "PingFangSC-Light"
        case regular    = "PingFangSC-Regular"
        case medium     = "PingFangSC-Medium"
        case bold       = "PingFangSC-Bold"
        case heavy      = "PingFangSC-Heavy"
        case black      = "PingFangSC-Black"
    }
    ///自适应字体
    class func auto(font: CGFloat, type: FontType) -> UIFont? {
        var fontSize: CGFloat = font
        fontSize *= S.scale375
        return UIFont(name: type.rawValue, size: fontSize)
    }
    ///自适应字体
    class func auto(font: CGFloat) -> UIFont {
        var fontSize: CGFloat = font
        fontSize *= S.scale375
        return UIFont.systemFont(ofSize: fontSize)
    }
    ///自适应粗体
    class func boldAuto(font: CGFloat) -> UIFont {
        var fontSize: CGFloat = font
        fontSize *= S.scale375
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
}

//MARK:UIColor扩展
extension UIColor {
    //16进制颜色
    public class func hexColor(with string:String, _ alpha: CGFloat = 1) -> UIColor? {
        var cString = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.count < 6 {
            return nil
        }
        if cString.hasPrefix("0X") {
            let index = cString.index(cString.startIndex, offsetBy: 2)
            cString = String(cString[index...])
        }
        if cString .hasPrefix("#") {
            let index = cString.index(cString.startIndex, offsetBy: 1)
            cString = String(cString[index...])
        }
        if cString.count != 6 {
            return nil
        }
        
        let rrange = cString.startIndex..<cString.index(cString.startIndex, offsetBy: 2)
        let rString = String(cString[rrange])
        let grange = cString.index(cString.startIndex, offsetBy: 2)..<cString.index(cString.startIndex, offsetBy: 4)
        let gString = String(cString[grange])
        let brange = cString.index(cString.startIndex, offsetBy: 4)..<cString.index(cString.startIndex, offsetBy: 6)
        let bString = String(cString[brange])
        var r:CUnsignedInt = 0 ,g:CUnsignedInt = 0 ,b:CUnsignedInt = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    //RGB颜色
    public class func rgbColor(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
  
    public class var randomColor: UIColor {
        let red = CGFloat(arc4random() % 256) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return color
    }
  
}


struct S {
    ///屏幕宽度
    static let width = UIScreen.main.bounds.width
    ///屏幕高度
    static let height = UIScreen.main.bounds.height
    ///宽度比例，按照375宽度
    static var scale375: CGFloat {
        return self.width / 375.0
    }
    ///状态栏高度
    static let statusHeigh = UIApplication.shared.statusBarFrame.height
}
