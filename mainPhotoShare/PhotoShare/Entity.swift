//
//  Entity.swift
//  
//
//  Created by 4423 on 2015/11/26.
//
//

import Foundation
import CoreData


class Entity: NSManagedObject {
    
    @NSManaged var filename: String?
    @NSManaged var addtime: NSDate?
    @NSManaged var flag: NSNumber?
}
