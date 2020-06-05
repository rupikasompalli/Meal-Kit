//
//  CouponGeneration.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-06-01.
//  Copyright © 2020 Rupika. All rights reserved.
//

import Foundation

struct ScratchCoupon: Codable{
    
    let discount:String
    var cuponCode = UUID().uuidString
    
    
    
    init(discount:String) {
        self.discount = discount
    }
    
}
