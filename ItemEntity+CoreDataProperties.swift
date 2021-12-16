//
//  ItemEntity+CoreDataProperties.swift
//  Bucket List CoreData
//
//  Created by admin on 16/12/2021.
//
//

import Foundation
import CoreData


extension ItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemEntity> {
        return NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
    }

    @NSManaged public var text: String?

}

extension ItemEntity : Identifiable {

}
