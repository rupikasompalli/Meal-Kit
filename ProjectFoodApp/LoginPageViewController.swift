//
//  LoginPageViewController.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-05-25.
//  Copyright © 2020 Rupika. All rights reserved.
//

import UIKit
import CoreData

class LoginPageViewController: UIViewController,UITextFieldDelegate {
    //MARK : Outlets
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userData : [User] = [User]()
    
    var loginUser : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchDataFromDataSource()
        
        //to hide keyboard
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    //MARK:Actions
    
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        //checking user details
        
        performEmptyValidation { (error, alertTitle) in
            if error {
                showalert(title: "Fields are empty", msg: alertTitle)
            }else{
                 checkUserDetails()
            }
        }
        
       
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
       
        
    }
    //MARK : Default functions
    //checking user details
    
    func checkUserDetails(){
        
        for userValue in userData{
            if emailTextField.text == userValue.userEmail && passwordTextField.text == userValue.userPassword{
                loginUser = userValue
                print(loginUser)
                break
            }
        }
        
        print("Sucessuflly Login")
        if let user = loginUser {
            //sending value of user loged in using singleton
            DataManager.shared.getUserLogged = loginUser
            
            performSegue(withIdentifier: "GoToDashBoard", sender: nil)
            
            showalert(title: "Sucessfully logeed", msg: "Hurray you have suessfully logged")
        }else{
            showalert(title: "Incorrect Details", msg: "Enter correct Info")
        }
       
    }
    
    //fetch data from data source
    func fetchDataFromDataSource(){
        //fecthing data from database
        
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //pulling data from database
   
        let request : NSFetchRequest<User> = User.fetchRequest()
        
        do{
            let results = try? db.fetch(request)
            if let resultsValue = results{
                
                if resultsValue.count == 0{
                    
                    print("Sorry there are no  user details in the database")
                    
                }
                else{
                    userData = resultsValue
                    
                    for i in resultsValue{
                        print(i.userEmail!)
                        print(i.userPassword!)
                    }
                }
            }
            
        }
    }
    
    //perform emoty validation
    //for empty validation
    func performEmptyValidation(callback:(Bool,String)->Void){
        
        var getTitleArray = [String]()
        //validations
        if emailTextField.text!.isEmpty {
            getTitleArray.append("Email Field is missing")
        }
        if (emailTextField.text?.contains("@")) == false{
            
            getTitleArray.append("Enter your @ in email")
        }
        if passwordTextField.text!.isEmpty{
            getTitleArray.append("Password Field is missing")
        }
        if !getTitleArray.isEmpty {
            var titleValue : String = ""
            
            for (index,element) in getTitleArray.enumerated(){
                if index == getTitleArray.count - 1 {
                    titleValue += element + "."
                }else{
                    titleValue += element + " ," + "\n"
                }
            }
            callback(true,titleValue)
        }else{
            callback(false,"")
        }
        
    }
    
   
    //showing alert
    func showalert(title : String,msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //to stop editing in textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK:when keyboard appears move screen up
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
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
extension LoginPageViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RecipetViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
