//
//  AddCart+CoreDataProperties.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-05-30.
//  Copyright © 2020 Rupika. All rights reserved.
//
//

import Foundation
import CoreData


extension AddCart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddCart> {
        return NSFetchRequest<AddCart>(entityName: "AddCart")
    }

    @NSManaged public var cartUser: User?
    @NSManaged public var cartMeal: MealKit?

}
