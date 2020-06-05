//
//  HistoryOrdersViewController.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-05-31.
//  Copyright © 2020 Rupika. All rights reserved.
//

import UIKit
import CoreData

class HistoryOrdersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:Outlets
    
    @IBOutlet weak var tableViewData: UITableView!
    
    var historyDataOrder : [Receipt] = [Receipt]()
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        
        //get data from core data
        fetchDataFromDataSource()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //MARK:Table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyDataOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryElementTableViewCell
        cell!.historyMeal?.text = historyDataOrder[indexPath.row].reciptMeal?.mealName
        cell!.historyOrderId?.text = String(historyDataOrder[indexPath.row].orderid)
        cell!.historyTotal?.text = String(historyDataOrder[indexPath.row].total)
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    //MARK: fetch data from data source
    func fetchDataFromDataSource(){
        //fecthing data from database
        
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //pulling data from database
        
        let request : NSFetchRequest<Receipt> = Receipt.fetchRequest()
        let predicte = NSPredicate(format: "userDetails.userEmail == %@",DataManager.shared.getUserLogged?.userEmail ?? "")
        request.predicate = predicte
        
        do{
            let results = try? db.fetch(request)
            if let resultsValue = results{
                
                if resultsValue.count == 0{
                    
                    print("Sorry there are no  user details in the database")
                    
                }
                else{
                    historyDataOrder = resultsValue
                    tableViewData.reloadData()
                    for i in resultsValue{
                        print(i.orderid)
                        print(i.reciptMeal?.mealName! as Any)
                    }
                }
            }
            
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
