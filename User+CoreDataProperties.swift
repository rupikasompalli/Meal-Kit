//
//  User+CoreDataProperties.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-05-26.
//  Copyright © 2020 Rupika. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userEmail: String?
    @NSManaged public var userPassword: String?
    @NSManaged public var photo: NSData?
    @NSManaged public var userPhoneNo: String?

}
