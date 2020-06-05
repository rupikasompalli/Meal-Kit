//
//  OrderPageViewController.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-05-29.
//  Copyright © 2020 Rupika. All rights reserved.
//

import UIKit
import CoreData

class OrderPageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: Outlets

    @IBOutlet weak var tableViewData: UITableView!

    @IBOutlet weak var suTotalLabel: UILabel!

    var checkedMealKit : [AddCart] = [AddCart]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       fetchDataFromDataSource()
       print(checkedMealKit)
        for value in checkedMealKit {
            
            let total = Double(self.suTotalLabel.text ?? "") ?? 0
            self.suTotalLabel.text =  String(total + value.cartMeal!.mealPrice)
        }
        

    }
    //MARK:Action
    
    @IBAction func checkOutClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "goToRecepit", sender: checkedMealKit)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RecipetViewController {
            
            let vc = segue.destination as? RecipetViewController
            
            vc?.recepitKit = sender as? [AddCart]
            
            print("Data sent SUcessfully to Recipt Page")
        }
    }
    
    //fetch data from data source
    func fetchDataFromDataSource(){
        //fecthing data from database

        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        //pulling data from database

        let request : NSFetchRequest<AddCart> = AddCart.fetchRequest()
        let predicte = NSPredicate(format: "cartUser.userEmail == %@", DataManager.shared.getUserLogged?.userEmail ?? "")
        
        request.predicate = predicte
    
        do{
            let results = try? db.fetch(request)
            if let resultsValue = results{

                if resultsValue.count == 0{

                    print("Sorry there are no  user details in the database")

                }
                else{
                    checkedMealKit  = resultsValue
                    tableViewData.reloadData()
                    for i in resultsValue{
                        print(i.cartUser!)
                        print(i.cartMeal!)
                    }
                }
            }

        }
    }
   

    //MARK:TableFunctions

    func numberOfSections(in tableView: UITableView) -> Int {
        return checkedMealKit.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as? OrderElemtsTableViewCell
        if let priceValue = checkedMealKit[indexPath.section].cartMeal{
            
                cell!.priceLabel?.text = String(priceValue.mealPrice)
            
            }

        return cell!
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UITextView(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        if let cartMealKit = checkedMealKit[section].cartMeal {
            
                let headerName = "Name of Meal:\(cartMealKit.mealName ?? " ")"
                label.text = headerName
                label.isEditable = false
                label.textColor = .white
                label.backgroundColor = UIColor(red: 10/256, green: 20/256, blue: 30/256, alpha: 1.0)
                label.font = UIFont(name: "chalkboard SE", size: CGFloat(20))
                return label
     }
       
        return label
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
