//
//  ViewController.swift
//  MyRouter
//
//  Created by 罗石清 on 2021/4/7.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "首页"
        self.view.backgroundColor = UIColor.white
        
        let startY: CGFloat = 120
        let spY: CGFloat = 20
        let btnH: CGFloat = 44
        let ts = ["AAA","BBB","CCC"]
        for i in 0..<ts.count {
            let y = CGFloat(i) * (btnH + spY) + startY
            let btn = UIButton(frame: CGRect(x: 0, y: y, width: 200, height: btnH))
            btn.center.x = self.view.frame.width / 2
            btn.setTitle(ts[i], for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.titleLabel?.font = UIFont.auto(font: 20)
            btn.backgroundColor = UIColor.red
            btn.tag = i
            btn.addTarget(self, action: #selector(self.btnAct(_:)), for: .touchUpInside)
            self.view.addSubview(btn)
                        
        }
    }
    @objc private func btnAct(_ send: UIButton) {
        let tag = send.tag
        print(tag)
        switch tag {
        case 0:
            LsqRouter.open(.avc)
        case 1:
            LsqRouter.open(.bvc("萝卜"))
        case 2:
            let test = TestModel(name: "哈罗卡提", id: 190)
            LsqRouter.open(.cvc(test)) { [weak self] (parma) in
                print(parma)
            }
        default:
            break
        }
    }
}

struct TestModel {
    var name: String
    var id: Int
}

class AAViewController: UIViewController, LsqRoutable {
    
    static func initRouter(params: LsqRouterParam?, handler: ((LsqRouterParam?)->Void)?) -> UIViewController {
        return AAViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "AAAAA"
        self.view.backgroundColor = UIColor.white
        
        
    }
    
    
    
}
class BBViewController: UIViewController, LsqRoutable {
    var name: String?
    init(name: String?) {
        super.init(nibName: nil, bundle: nil)
        self.name = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func initRouter(params: LsqRouterParam?, handler: ((LsqRouterParam?)->Void)?) -> UIViewController {
        let name = params?["name"] as? String
        return BBViewController(name: name)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "BBBBB"
        self.view.backgroundColor = UIColor.white
        
        print("我的名字是:\(self.name ?? "???")")
        
    }
}
class CCViewController: UIViewController, LsqRoutable {
    private var demo: TestModel?
    private var handler: ((LsqRouterParam?)->Void)?
    init(demo: TestModel?, handler: LsqRouterHandler) {
        super.init(nibName: nil, bundle: nil)
        self.demo = demo
        self.handler = handler
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func initRouter(params: LsqRouterParam?, handler: LsqRouterHandler) -> UIViewController {
        let dm = params?["demo"] as? TestModel
        
        return CCViewController(demo: dm, handler: handler)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "CCCCC"
        self.view.backgroundColor = UIColor.white
        
        print("我的模型是:\(self.demo)")
        
        let btn = UIButton(frame: CGRect(x: 0, y: 200, width: 300, height: 44))
        btn.center.x = self.view.frame.width / 2
        btn.setTitle("我要返回和回调", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.auto(font: 20)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(self.btnAct(_:)), for: .touchUpInside)
        self.view.addSubview(btn)
        
        
    }
    
    @objc private func btnAct(_ send: UIButton) {
        self.handler?(["demo": self.demo!])
        self.navigationController?.popViewController(animated: true)
    }
    
}


class BaseRouterController: UIViewController {
    

   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        
    }
    
    
    
    
}
