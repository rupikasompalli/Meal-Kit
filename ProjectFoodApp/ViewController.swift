//
//  ViewController.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-05-25.
//  Copyright © 2020 Rupika. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profilePhotoImageView : UIImageView!
    @IBOutlet weak var phoneNoTextField: UITextField!
    
    //step 2 create a image picker varaible
    
    var imagePicked : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //to show border to image
        addBorderToImage()
    
    }
    
    
    //MARK : ACtions
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        performEmptyValidation { (error, alertTitle) in
            if error {
                showalert(title: "MissingInfo", msg: alertTitle)
            }else{
                saveUserDetailsToDataBase()
                performSegue(withIdentifier: "GoToLogin", sender: self)
            }
        }
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "signUpPage")
        self.present(vc!, animated: true, completion: nil)
        
        
    }
    
    @IBAction func takePhotoPressed(_ sender: Any) {
        
        //step 3 intialise the imagepickercontroller
        
        self.imagePicked = UIImagePickerController()
        
        //step 4: step up the picker to get images from camera or gallery
        
        //check phone has gallery
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false{
             showalertFoCameraa(title: "You don't Have Camera", msg: "Checking wether phone contains gallery or not")
           
            
        }else{
            
            self.imagePicked.sourceType = .camera
            
            //set the delegate
            self.imagePicked.delegate = self
            self.present(self.imagePicked, animated: true)
        }
        
    }
    
    
    @IBAction func chooseFromGalleryPressed(_ sender: Any) {
        //crate an instance of the image pciker
        
        self.imagePicked = UIImagePickerController()
        
        //check phone has gallery
        
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false) {
            
            showalert(title: "You don't Have gallery", msg: "Check wether your phone contains gallery or not")
            // swap them to using phto from gallery
            return
        }else{
            self.imagePicked.sourceType = .photoLibrary
            //set the delegate
            self.imagePicked.delegate = self
            self.present(self.imagePicked, animated:true)
        }
        
    }
    //MARK : Delegate function
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // MARK: Handle images
        print("Calling the picker view function")
        
        // what do you want to do after the person presses "Use Photo?"
        // - do you want to save the photo? display the photo? discard it?
        // - do something else?
        // In example below, we are closing the picker
        
        
        
        self.imagePicked.dismiss(animated: true, completion: nil)
        
        // the camera image is stored in function info parameter
        let photoTakenFromCamera = info[.originalImage] as? UIImage
        
        self.profilePhotoImageView.image = photoTakenFromCamera
    }
    
    //MARK: Default functions
    
    //MARK: Core data saving
    
    //save details to database
    func saveUserDetailsToDataBase(){
        
        let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let userDetails = User(context: myContext)
        
        userDetails.userEmail = emailTextField.text
        userDetails.userPassword = passwordTextField.text
        // to save image instance method png data has to use on image
        // A data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
        if self.profilePhotoImageView.image?.pngData != nil {
            
            userDetails.photo = self.profilePhotoImageView.image?.pngData() as NSData?
        }
        userDetails.userPhoneNo = phoneNoTextField.text
        
        do{
            //to save data into database
            try myContext.save()
            print("Details Saved")
            //showalert(title: "Details Saved",msg: "Details Sucessfulyy saved into DataBase")
            
        }
        catch{
            print("Cannot save Details")
        }
        clearTextFields()
    }
    
    //to clear text field
    func clearTextFields(){
        emailTextField.text = ""
        passwordTextField.text = ""
        phoneNoTextField.text = ""
        profilePhotoImageView.image = nil
    }
    
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
        if profilePhotoImageView.image == nil {
            getTitleArray.append("Photo Field is missing")
        }
        if phoneNoTextField.text!.isEmpty {
            getTitleArray.append("Phone number is missing")
        }
        if phoneNoTextField.text!.count > 10{
            getTitleArray.append("Phone number can only accept 10 digits")
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
    
    //to make image round
    func addBorderToImage(){
        profilePhotoImageView.layer.borderWidth = 1.5
        profilePhotoImageView.layer.borderColor = UIColor.purple.cgColor
        profilePhotoImageView.clipsToBounds = true
        profilePhotoImageView.layer.cornerRadius = 20
        
    }
    
    //show alert
    
    func showalert(title : String,msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showalertFoCameraa(title : String,msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertAction.Style.default, handler:{ action in
            self.imagePicked.sourceType = .photoLibrary
            //set the delegate
            self.imagePicked.delegate = self
            self.present(self.imagePicked, animated:true)
            
        }))
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
    
   
    
}


