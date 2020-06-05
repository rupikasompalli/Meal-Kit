//
//  DetailViewController.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-05-29.
//  Copyright © 2020 Rupika. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    //MARK: Outlets
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var desTextView: UITextView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var selectMealKit : MealKit?
    
    var getLoginUser : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let getImage = selectMealKit?.mealPhoto{
             detailImageView.image = UIImage(named: getImage)
        }
       mealNameLabel.text = selectMealKit?.mealName
       calorieLabel.text = selectMealKit?.mealCalorie
        priceLabel.text = String(selectMealKit!.mealPrice)
       desTextView.text = selectMealKit?.mealDesc
        
        //getting user details
        getLoginUser = DataManager.shared.getUserLogged
        
    }
    //MARK: Actions
    
    @IBAction func addToCardPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "GoToUserOrder", sender: nil)
        //when user pressed addTocat saving details to database.
        saveUserDetailsToDataBase()
        
    }
    
    func saveUserDetailsToDataBase(){

        let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let addToCartValues = AddCart(context: myContext)

        addToCartValues.cartUser = getLoginUser
        addToCartValues.cartMeal = selectMealKit
        
        do{
            //to save data into database
            try myContext.save()
            print("Details Saved")

        }
        catch{
            print("Cannot save Details")
        }
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
