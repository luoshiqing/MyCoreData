//
//  CoreDataManager.swift
//  CoreDataTest
//
//  Created by 罗石清 on 2019/8/22.
//  Copyright © 2019 HunanChangxingTrafficWisdom. All rights reserved.
//

import UIKit
import CoreData

extension StudentCoreData{
    //异步操作
    func save(students: [MyStudent]) {
        
        self.backContext.perform {
            for st in students{
                let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: self.backContext) as? Student
                student?.studentAge = st.age ?? 0
                student?.studentName = st.name
                student?.studentId = st.id
            }
            do{
                try self.backContext.save()
            }catch{
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getAsyc(success: (([MyStudent])->Swift.Void)?) {
        
        self.backContext.perform {
            let fetchRequest: NSFetchRequest = Student.fetchRequest()
            do{
                let result = try self.backContext.fetch(fetchRequest)
                var myS = [MyStudent]()
                for st in result{
                    var ss = MyStudent()
                    ss.age = st.studentAge
                    ss.name = st.studentName
                    ss.id = st.studentId
                    myS.append(ss)
                }
                success?(myS)
            }catch{
                fatalError("读取数据库失败")
            }
        }
    }
    func deleteAsyc(age: Int32? = nil, name: String? = nil, id: String? = nil, success: ((Bool)->Swift.Void)?){
        self.deleteAsycHandler = success
        self.backContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
            
            if let pr = self.getPredicate(age: age, name: name, id: id){
                fetchRequest.predicate = NSPredicate(format: pr, "")
            }
            
            let async = NSAsynchronousFetchRequest(fetchRequest: fetchRequest, completionBlock: { (result) in
                let fetchObject = (result.finalResult as? [Student]) ?? []
                for s in fetchObject{
                    self.backContext.delete(s)
                }
                try? self.backContext.save()
            })
            do{
                try self.backContext.execute(async)
            }catch{
                print("删除失败")
            }
        }
        
    }
}


class StudentCoreData: NSObject {
    private static let manager = StudentCoreData()
    
    public class var shared: StudentCoreData{
        return manager
    }
    
    private var deleteAsycHandler: ((Bool)->Swift.Void)?
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveContextSave(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: self.backContext)
    }
    @objc private func receiveContextSave(_ send: Notification) {
        print("存完啦")
        
        let info = send.userInfo ?? [:]
        print(Array(info.keys))
        self.context.mergeChanges(fromContextDidSave: send)
    }
    
    //主线程操作
    private lazy var context: NSManagedObjectContext = {
        let context = (UIApplication.shared.delegate as! AppDelegate).context
        return context
    }()
    //后台操作
    private lazy var backContext: NSManagedObjectContext = {
        let context = (UIApplication.shared.delegate as! AppDelegate).backContext
        return context
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator
    }()
    
    private func saveContext(){
        do{
            try self.context.save()
        }catch{
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    //新增
    public func saveLineCollect(students: [MyStudent]){
        let t1 = Date().timeIntervalSince1970 * 1000
        print(t1)
        for st in students{
            let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: self.context) as? Student
            student?.studentAge = st.age ?? 0
            student?.studentName = st.name
            student?.studentId = st.id
        }
        self.saveContext()
        let t2 = Date().timeIntervalSince1970 * 1000
        print(t2)
        print("存储耗时:\(t2 - t1)毫秒")
    }
    //删
    public func delete(age: Int32?, name: String?, id: String?)->Bool{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        
        if let pr = self.getPredicate(age: age, name: name, id: id){
            fetchRequest.predicate = NSPredicate(format: pr, "")
        }
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
            try self.persistentStoreCoordinator.execute(deleteRequest, with: self.context)
            print("删除成功")
            return true
        }catch{
            print("删除失败")
            return false
        }
    }
    
    //查
    public func getLineCollect()->[MyStudent]{
        let fetchRequest: NSFetchRequest = Student.fetchRequest()
        do{
            let result = try self.context.fetch(fetchRequest)
            var myS = [MyStudent]()
            for st in result{
                var ss = MyStudent()
                ss.age = st.studentAge
                ss.name = st.studentName
                ss.id = st.studentId
                myS.append(ss)
            }
            return myS
        }catch{
            fatalError("读取数据库失败")
        }
    }
    public func getLineCollect(age: Int32?, name: String?, id: String?)->[MyStudent]{
        let fetchRequest: NSFetchRequest = Student.fetchRequest()
       
        if let pr = self.getPredicate(age: age, name: name, id: id){
            fetchRequest.predicate = NSPredicate(format: pr, "")
        }
        do{
            let result = try self.context.fetch(fetchRequest)
            var myS = [MyStudent]()
            for st in result{
                var ss = MyStudent()
                ss.age = st.studentAge
                ss.name = st.studentName
                ss.id = st.studentId
                myS.append(ss)
            }
            return myS
        }catch{
            fatalError("读取数据库失败")
        }
    }
    
    private func getPredicate(age: Int32?, name: String?, id: String?) -> String? {
        var preds = [String]()
        if let ag = age{
            let str = "studentAge == '\(ag)'"
            preds.append(str)
        }
        if let na = name, !na.isEmpty {
            let str = "studentName == '\(na)'"
            preds.append(str)
        }
        if let i = id, !i.isEmpty {
            let str = "studentId == '\(i)'"
            preds.append(str)
        }
        if !preds.isEmpty{
            var endP = ""
            for i in 0..<preds.count{
                let str = preds[i]
                if i == 0{
                    endP += str
                }else{
                    endP += " AND \(str)"
                }
            }
            return endP
        }else{
            return nil
        }
    }
}
