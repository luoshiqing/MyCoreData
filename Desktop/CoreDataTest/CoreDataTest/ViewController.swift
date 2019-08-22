//
//  ViewController.swift
//  CoreDataTest
//
//  Created by 罗石清 on 2019/8/22.
//  Copyright © 2019 HunanChangxingTrafficWisdom. All rights reserved.
//

import UIKit

struct MyStudent {
    var name: String?
    var id: String?
    var age: Int32?
}

class ViewController: UIViewController {

    
    
    lazy var mySts: [MyStudent] = {
        return self.getDs()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func add(_ sender: Any) {
        let s = self.mySts
//        StudentCoreData.shared.saveLineCollect(students: s)
        StudentCoreData.shared.save(students: s)
    }
    @IBAction func chaxun(_ sender: Any) {
//        let st = StudentCoreData.shared.getLineCollect()
        StudentCoreData.shared.getAsyc { (st) in
            print(st.count)
        }
        
    }
    @IBAction func tiaocx(_ sender: Any) {
        let st = StudentCoreData.shared.getLineCollect(age: 16, name: "", id: "")
        print(st.count)
    }
    @IBAction func delete1(_ sender: Any) {
        let ok = StudentCoreData.shared.delete(age: nil, name: nil, id: nil)
        print(ok)
        
    }
    
    @IBAction func tianjianDelete(_ sender: Any) {
//        let ok = StudentCoreData.shared.delete(age: nil, name: "", id: "")
//        print(ok)
        StudentCoreData.shared.deleteAsyc { (isok) in
            print(isok)
        }
    }
    
    
    
    func getDs()->[MyStudent]{
        var sts = [MyStudent]()
        for i in 0..<300000{
            let name = "学生\(i)"
            let age = arc4random_uniform(10) + 10
            var student = MyStudent()
            student.name = name
            student.id = "\(i)"
            student.age = Int32(age)
            sts.append(student)
        }
        return sts
    }
    
}

