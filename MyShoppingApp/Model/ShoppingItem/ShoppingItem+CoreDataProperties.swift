//
//  ShoppingItem+CoreDataProperties.swift
//  MyShoppingApp
//
//  Created by Frane Sučić on 19.01.2024..
//
//

import Foundation
import CoreData


extension ShoppingItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingItem> {
        return NSFetchRequest<ShoppingItem>(entityName: "ShoppingItem")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var amount: Double
    @NSManaged public var creationDateTime: Date?

}

extension ShoppingItem : Identifiable {

}
