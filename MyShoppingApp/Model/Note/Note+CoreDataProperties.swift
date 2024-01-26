//
//  Note+CoreDataProperties.swift
//  MyShoppingApp
//
//  Created by Frane Sučić on 20.01.2024..
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var note: String?
    @NSManaged public var creationDateTime: Date?
    @NSManaged public var listOfLinkedItems: [Int32]

}

extension Note : Identifiable {

}
