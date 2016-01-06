//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by 4423 on 2015/11/26.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Entity {

    @NSManaged var filename: String?
    @NSManaged var addtime: NSDate?
    @NSManaged var flag: NSNumber?

}
