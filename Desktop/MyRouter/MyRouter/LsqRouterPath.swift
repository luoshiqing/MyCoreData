//
//  LsqRouterPath.swift
//  MyRouter
//
//  Created by 罗石清 on 2021/4/8.
//

import UIKit

public struct LsqRouterPathableModel {
    let classType: UIViewController.Type
    let params: LsqRouterParam?
}

public protocol LsqRouterPathable {
    var routerPath: LsqRouterPathableModel { get }
}

enum LsqRouterPath: LsqRouterPathable {
    
    case avc
    case bvc(String)
    case cvc(TestModel)
    
    public var routerPath: LsqRouterPathableModel {
        switch self {
        case .avc:
            return LsqRouterPathableModel(classType: AAViewController.self, params: nil)
        case .bvc(let name):
            return LsqRouterPathableModel(classType: BBViewController.self, params: ["name":name])
        case .cvc(let demo):
            return LsqRouterPathableModel(classType: CCViewController.self, params: ["demo":demo])
        }
    }
}
