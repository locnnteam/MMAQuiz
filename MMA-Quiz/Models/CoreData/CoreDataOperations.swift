import UIKit
import CoreData

class CoreDataOperations: NSObject {
    var objectDataSave: [LessonItem] = []
    
    class var shared: CoreDataOperations {
        struct Static {
            static let instance: CoreDataOperations = CoreDataOperations()
        }
        return Static.instance
    }
    
    // MARK: Save data
    public func saveData(lessonItem: LessonItem) -> Void {
        let managedObjectContext = getContext()
        let objectData = NSEntityDescription.insertNewObject(forEntityName: "Word", into: managedObjectContext) as! Word
        objectData.levelName = lessonItem.levelName
        objectData.name = lessonItem.name
        objectData.image = lessonItem.image
        objectData.nickname = lessonItem.nickname
        objectData.born = lessonItem.born
        objectData.birthday = lessonItem.birthday
        
        self.objectDataSave.append(lessonItem)
        
        do {
            try managedObjectContext.save()
            debugPrint("saved!")
        } catch let error as NSError  {
            debugPrint("Could not save \(error), \(error.userInfo)")
        } catch {

        }
    }
    
    // MARK: Fetching Data
    public func fetchData() -> [LessonItem] {
        var lessons: [LessonItem] = []
        let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        var id: Int = 0
        do {
            let fetchedObject = try moc.fetch(fetchRequest) as! [Word]
            debugPrint(fetchedObject.count)
            for object in fetchedObject {
                id = id + 1
                let levelName = object.levelName
                let name = object.name
                let nickname = object.nickname
                let image = object.image
                let birthday = object.birthday
                let born = object.born
                
                let lessonItem = LessonItem(levelName: levelName, id: "\(id)", name: name, nickname: nickname, birthday: birthday, born: born, image: image)
                lessons.append(lessonItem!)
            }
            
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
        if objectDataSave.isEmpty {
            self.objectDataSave = lessons
            return lessons
        } else {
            return objectDataSave
        }
    }
    
    public func iskExistObject(word: String) -> Bool {
        if self.objectDataSave.isEmpty {
            self.objectDataSave = self.fetchData()
        }
        
        for data in objectDataSave {
            if data.name == word {
                return true
            }
        }
        return false
    }
    
    // MARK: Delete Data Records
    
    public func deleteRecords(lessonItem: LessonItem) -> Void {
        self.objectDataSave.removeObject(obj: lessonItem.name)
        let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        
         let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [Word]
        
        for object in resultData {
            if object.name == lessonItem.name {
              moc.delete(object)
                break
            }
        }
        
        do {
            try moc.save()
            debugPrint("saved!")
        } catch let error as NSError  {
            debugPrint("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    // MARK: Update Data
    public func updateRecords(lessonItem: LessonItem) -> Void {
        let moc = getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        
        let result = try? moc.fetch(fetchRequest)
            
            let resultData = result as! [Word]
            for objectData in resultData {
                objectData.name = lessonItem.name
                objectData.image = lessonItem.image
                objectData.nickname = lessonItem.nickname
                objectData.born = lessonItem.born
                objectData.birthday = lessonItem.birthday
            }
        
            do{
                try moc.save()
                debugPrint("saved")
            }catch let error as NSError {
                debugPrint("Could not save \(error), \(error.userInfo)")
            }
    }
    
    // MARK: Get Context
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

}
