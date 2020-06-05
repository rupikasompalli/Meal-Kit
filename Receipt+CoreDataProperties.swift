//
//  Receipt+CoreDataProperties.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-06-01.
//  Copyright © 2020 Rupika. All rights reserved.
//
//

import Foundation
import CoreData


extension Receipt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receipt> {
        return NSFetchRequest<Receipt>(entityName: "Receipt")
    }

    @NSManaged public var orderid: Int32
    @NSManaged public var subTotal: Double
    @NSManaged public var tax: Double
    @NSManaged public var tip: Double
    @NSManaged public var total: Double
    @NSManaged public var reciptMeal: MealKit?
    @NSManaged public var userDetails: User?

}
