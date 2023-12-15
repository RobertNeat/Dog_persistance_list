//
//  Dog+CoreDataProperties.swift
//  psy_i_rasy
//
//  Created by apple on 27/05/2023.
//
//

import Foundation
import CoreData


extension Dog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog> {
        return NSFetchRequest<Dog>(entityName: "Dog")
    }

    @NSManaged public var yearBirth: Int16
    @NSManaged public var name: String?
    @NSManaged public var toBreed: Breed?

}

extension Dog : Identifiable {

}
