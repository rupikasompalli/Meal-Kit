//
//  MealKit+CoreDataProperties.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-05-31.
//  Copyright © 2020 Rupika. All rights reserved.
//
//

import Foundation
import CoreData


extension MealKit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealKit> {
        return NSFetchRequest<MealKit>(entityName: "MealKit")
    }

    @NSManaged public var mealCalorie: String?
    @NSManaged public var mealDesc: String?
    @NSManaged public var mealName: String?
    @NSManaged public var mealPhoto: String?
    @NSManaged public var mealPrice: Double
    @NSManaged public var mealSku: String?

}
