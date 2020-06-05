//
//  DashBoardViewController.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-05-27.
//  Copyright © 2020 Rupika. All rights reserved.
//

import UIKit
import CoreData

class DashBoardViewController: UIViewController {

    var mealData:[Meal] = [Meal]()
    
    let defualts = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if defualts.bool(forKey: "firstLaunch") == false{
            // load the json file here
            guard let file = openFile() else {
                
                return
                
            }
            
            // load words from file into data source
            mealData = self.getData(from: file)!
            //saving details to core data
            saveDetailsToDataBase()
            
            //checking whether data is fecthed before or not
            
            defualts.setValue(true, forKey: "firstLaunch")
        }else{
            print("We already fecthed data from json")
        }
        
    }
    
    //to open json file
    func openDefaultFile() ->String?{
        if let file = Bundle.main.path(forResource: "Data", ofType: "json"){
            print("File Found:\(file.description)")
            return file
        }
        else{
            print("file cannot found")
        }
        return nil
    }

    func openFile() -> String?{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let finalPath = path[0]
        let filename = finalPath.appendingPathComponent("Data.json")
        
        //check if file exists
        let fileExists = FileManager().fileExists(atPath: filename.path)
        
        if fileExists == true{
            
            //load the employee from saved file
            return filename.path
        }
        else{
            //open file from defualt file
            return self.openDefaultFile()
        }
        return nil
    }
    
    //decoding the json data
    func getData(from file:String?) -> [Meal]? {
        
        if file == nil {
            print("File path is nil")
            return nil
        }
        do{
            //open the file
            let jsonData = try String(contentsOfFile: file!).data(using: .utf8)
            
            print(jsonData) //optional(749Bytes)
            
            //get content of file
            let decodedData = try JSONDecoder().decode([Meal].self, from: jsonData!)
            
            // DEBUG: print file contents to screen
            dump(decodedData)
            
            return decodedData
        }catch{
            print("Error while parsing file")
            print(error.localizedDescription)
        }
        return nil
    }
    
    //for core data saving details
    func saveDetailsToDataBase(){
       
        let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        for mealValue in mealData{
            
            let mealKitDetails = MealKit(context: myContext)
            
            mealKitDetails.mealName = mealValue.name
            mealKitDetails.mealDesc = mealValue.description
            mealKitDetails.mealPhoto = mealValue.photo
            mealKitDetails.mealPrice = mealValue.price
            mealKitDetails.mealCalorie = mealValue.calorie
            mealKitDetails.mealSku = UUID().uuidString
            
            do{
                //to save data into database
                try myContext.save()
                print("Details Saved")
            }
            catch{
                print("Cannot save Details")
            }
        }
    }
    
    
    func showalert(title : String,msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
