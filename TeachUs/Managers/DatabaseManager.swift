//
//  DatabaseManager.swift
//  TeachUs
//
//  Created by ios on 11/30/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class DatabaseManager {
    
    class var managedContext:NSManagedObjectContext {
        let appDelegate:AppDelegate =  (UIApplication.shared.delegate as? AppDelegate)!
        return appDelegate.persistentContainer.viewContext
    }
    
    class func getEntitesForEntityName(_ entityName: String, sortindId sortingKey: String) -> Array<Any> {
        var object: [Any] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        let sortDescriptior:NSSortDescriptor = NSSortDescriptor(key: sortingKey, ascending: true)
        fetchRequest.sortDescriptors?.append(sortDescriptior)
        
        do {
            object = try managedContext.fetch(fetchRequest)
        } catch let error as NSError  {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return object
    }
    
    
    class func getEntitesForEntityName(_ entityName: String, sortindId sortingKey: String,ascending:Bool) -> Array<Any> {
        var object: [Any] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        let sortDescriptior:NSSortDescriptor = NSSortDescriptor(key: sortingKey, ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescriptior]
        
        do {
            object = try managedContext.fetch(fetchRequest)
        } catch let error as NSError  {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return object
    }
    
    
    class func deleteAllEntitiesForEntityName(name:String){
        let fetechRequest = NSFetchRequest<NSManagedObject>(entityName:name)
        do{
            let requestObject = try  managedContext.fetch(fetechRequest)
            
            for object:NSManagedObject in requestObject{
                managedContext.delete(object)
            }
        }catch let error as NSError{
            print("Could not delete. \(error), \(error.userInfo)")
            
        }
    }
    
    class func deleteEntitieForEntity(name:String,field_name:String,field_id:Int){
        let fetechRequest = NSFetchRequest<NSManagedObject>(entityName:name)
        fetechRequest.predicate = NSPredicate(format: "\(field_name) = %@", "\(field_id)")
        do{
            let requestObject = try  managedContext.fetch(fetechRequest)
            
            for object:NSManagedObject in requestObject{
                managedContext.delete(object)
            }
        }catch let error as NSError{
            print("Could not delete. \(error), \(error.userInfo)")
            
        }
    }
    
    class func updateEntitieForEntity(updateObject:NSManagedObject,name:String,field_name:String,field_id:Int){
        let fetechRequest = NSFetchRequest<NSManagedObject>(entityName:name)
        fetechRequest.predicate = NSPredicate(format: "\(field_name) == %d", field_id)
        do{
            let requestObject = try  managedContext.fetch(fetechRequest)
            
            if requestObject.count == 1
            {
                var object = updateObject
                do{
                    try managedContext.save()
                }
                catch
                {
                    print("Could not update. \(error), \(error.localizedDescription)")
                }
            }
        }catch let error as NSError{
            print("Could not update . \(error), \(error.userInfo)")
            
        }
    }
    
    class func getEntitesForEntityName(name:String, withPredicate:NSPredicate) -> [Any]{
        var object: [Any] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = withPredicate
        
        do{
            object = try managedContext.fetch(fetchRequest)
        }catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return object
    }
    
    class func getEntitesForEntityName(fetchRequest:NSFetchRequest<NSManagedObject>) -> [Any]{
        var object: [Any] = []
        
        do{
            object = try managedContext.fetch(fetchRequest)
        }catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return object
    }
    
    class func getEntitesForEntityName(name:String) -> [Any] {
        var object: [Any] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            object = try managedContext.fetch(fetchRequest)
        }catch let error as NSError{
            print("Could not modify. \(error), \(error.userInfo)")
        }
        return object
    }
    
    class func getEntitesForEntityName(name:String,filter:Any) -> [Any]{
        var object: [Any] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            object = try managedContext.fetch(fetchRequest)
        }catch let error as NSError{
            print("Could not modify. \(error), \(error.userInfo)")
        }
        return object
    }
    
    class func saveDbContext(){
        let managedContext = DatabaseManager.managedContext
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
}
