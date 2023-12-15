//
//  Persistence.swift
//  psy_i_rasy
//
//  Created by apple on 27/05/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        //-------------------------------------------------------------------
        //dane w podglądzie
        let breedNames:[String] = ["Owczarek", "Labrador", "Golden Retriever", "Buldog"]
        
        let dogNames = ["Reksio","Ares","Danusia","Felicjan"]
        let dogAges:[Int16] = [2035,2893,2090,3728]
        
        for a in 0..<4{//trzeba tworzyć dla obu encji, żeby podgląd działał
            let newBreed = Breed(context: viewContext)
            newBreed.name = breedNames[a]
            
            let newDog = Dog(context: viewContext)
            newDog.name = dogNames[a]
            newDog.yearBirth = dogAges[a]
        }
        //-------------------------------------------------------------------
        
         
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "psy_i_rasy")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
