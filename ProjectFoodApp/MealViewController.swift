//
//  MealViewController.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-05-27.
//  Copyright © 2020 Rupika. All rights reserved.
//

import UIKit
import CoreData

class MealViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    //MARK: Outlets
    
    @IBOutlet weak var collectionViewData: UICollectionView!
   
    var mealkitData:[MealKit] = [MealKit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //navigation bar title
        self.navigationItem.title = "Food Menu"
      
        //get data from data source
        getDataFromDataSource()
    }
    
    //MARK: Action
    
    
    
    //MARK : Default Functions for collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return mealkitData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mealCell", for: indexPath) as? MealElemtsCollectionViewCell
        cell!.nameMealLabel?.text = mealkitData[indexPath.item].mealName
        cell!.priceForMealLabel?.text = String(mealkitData[indexPath.item].mealPrice)
        if let getImageValue = mealkitData[indexPath.item].mealPhoto{
            cell!.imageMeal?.image = UIImage(named: getImageValue)
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToDetail" , sender: mealkitData[indexPath.item])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DetailViewController {
            
            let vc = segue.destination as? DetailViewController
            
            vc?.selectMealKit = sender as? MealKit
            
            print("Data sent SUcessfully")
        }
    }
    
    //MARK: functions
    func getDataFromDataSource(){
        //fecthing data from database
        
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //pulling data from database
        //sorting pokemon from database acording to name alphateic A to Z.
        
        
        let request : NSFetchRequest<MealKit> = MealKit.fetchRequest()
        
        do{
            let results = try? db.fetch(request)
            if let resultsValue = results{
                
                if resultsValue.count == 0{
                    
                    print("Sorry there are no  pokemon in the database")
                    
                }
                else{
                    mealkitData = resultsValue
                    
                    for i in resultsValue{
                        print(i.mealName!)
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

extension MealViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 40)/2, height: 300)
    }
}
