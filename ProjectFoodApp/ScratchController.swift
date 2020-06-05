//
//  ScratchController.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-05-31.
//  Copyright © 2020 Rupika. All rights reserved.
//

import UIKit

class ScratchController: UIViewController {
    
    @IBOutlet weak var scratchNumLabel: UILabel!
    @IBOutlet weak var scratchCheckLabel: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var couponLabel: UILabel!
    var shakeCount = 0
    
    var discounts = ["ZEROOFF", "TENOFF", "50OFF"]
    var couponCodes = [""]
    var getLoginUser : User?
    
    var checkUserShaked = false
    
    let defualts = UserDefaults.standard
    
    let date = Date()
    
    let calendar = Calendar.current

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scratchCheckLabel.isHidden = true
        couponLabel.isHidden = true
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            imgV.isHidden = false
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
       
            if motion == .motionShake {
                
                //check if date is saved
                if let savedDate = defualts.object(forKey: "shakedDate") as? Date {
                    if savedDate < Date(){
                        defualts.removeObject(forKey: "shakedDate")
                        shakeCount += 1
                        processShakes()
                    }else{
                        scratchCheckLabel.isHidden = false
                        scratchCheckLabel.text = "You are out of shakes. Comback tomorrow to play the shake and scratch."
                    }
                }else{
                    shakeCount += 1
                    processShakes()
                }
                
            }
       
    }
    
    func processShakes(){
       
        if shakeCount <= 3 {
             couponLabel.isHidden = false
            if shakeCount == 3{
                 imgV.isHidden = true
                let random = randomNumber(probabilities: [0.65,0.3,0.05])
                let scratchcode = discounts[random]
                //saving scract details in user defaults
                getLoginUser = DataManager.shared.getUserLogged
                 let getScrach = ScratchCoupon(discount: scratchcode)
                scratchNumLabel.text = getScrach.discount
                couponLabel.text = getScrach.cuponCode
                saveCupon(cupon: getScrach)
            }
           
        }else{
            scratchCheckLabel.isHidden = false
             couponLabel.isHidden = true
            scratchCheckLabel.text = "You are out of shakes. Comback tomorrow to play the shake and scratch."
            defualts.setValue(date, forKey: "shakedDate")
        }
    }
    
    func saveCupon(cupon:ScratchCoupon){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cupon) {
            defualts.setValue(encoded, forKey: getLoginUser!.userEmail! + "_scrach")
            defualts.setValue(true, forKey: getLoginUser!.userEmail! + "_scrachIsValid")
       }
    }
    
    
    
    
    
    func randomNumber(probabilities: [Double]) -> Int {
        
        // Sum of all probabilities (so that we don't have to require that the sum is 1.0):
        let sum = probabilities.reduce(0, +)
        // Random number in the range 0.0 <= rnd < sum :
        let rnd = Double.random(in: 0.0 ..< sum)
        // Find the first interval of accumulated probabilities into which `rnd` falls:
        var accum = 0.0
        for (i, p) in probabilities.enumerated() {
            accum += p
            if rnd < accum {
                return i
            }
        }
        // This point might be reached due to floating point inaccuracies:
        return (probabilities.count - 1)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
