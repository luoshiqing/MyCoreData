//
//  LsqRouter.swift
//  MyRouter
//
//  Created by 罗石清 on 2021/4/8.
//

import UIKit

public typealias LsqRouterParam = Dictionary<String,Any>
public typealias LsqRouterHandler = ((LsqRouterParam?)->Void)?
public protocol LsqRoutable {
    
    
    static func initRouter(params: LsqRouterParam?, handler: LsqRouterHandler) -> UIViewController
    
}

struct LsqRouter {
    static func open(_ path: LsqRouterPath, handler: ((LsqRouterParam?)->Void)? = nil, animated: Bool = true) {
        guard let cls = path.routerPath.classType as? LsqRoutable.Type else {
            print("这个东西，他没有实现 LsqRoutable 协议")
            return
        }
        let vc = cls.initRouter(params: path.routerPath.params, handler: handler)
        vc.hidesBottomBarWhenPushed = true
        let topVC = self.getCurrentController()
        
        if let nav = topVC?.navigationController {
            nav.pushViewController(vc, animated: animated)
        } else {
            print("没找到导航栏啊")
        }
    }
    
    //TODO:获取当前控制器
    static private func getCurrentController() -> UIViewController? {
        
        guard let window = UIApplication.shared.windows.first else {
            return nil
        }
        var tmpView: UIView?
        
        for subview in window.subviews.reversed() {
            if subview.classForCoder.description() == "UILayoutContainerView" {
                tmpView = subview
                break
            }
        }
        if tmpView == nil {
            tmpView = window.subviews.last
        }
        var nextResponder = tmpView?.next
        
        var next: Bool {
            return !(nextResponder is UIViewController) || nextResponder is UINavigationController || nextResponder is UITabBarController
        }
        while next {
            tmpView = tmpView?.subviews.first
            if tmpView == nil {
                return nil
            }
            nextResponder = tmpView!.next
        }
        return nextResponder as? UIViewController
    }
}



