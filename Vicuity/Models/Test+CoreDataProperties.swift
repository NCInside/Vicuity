//
//  Test+CoreDataProperties.swift
//  Vicuity
//
//  Created by Nicholas Christian Irawan on 02/05/24.
//
//

import Foundation
import CoreData


extension Test {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Test> {
        return NSFetchRequest<Test>(entityName: "Test")
    }

    @NSManaged public var date: Date?
    @NSManaged public var score: Int16

}

extension Test : Identifiable {

}
