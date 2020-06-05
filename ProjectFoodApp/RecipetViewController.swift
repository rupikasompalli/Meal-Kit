//
//  RecipetViewController.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-05-30.
//  Copyright © 2020 Rupika. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class RecipetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
   
    //MARK:Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var couponDisplayView: UIView!
    @IBOutlet weak var showCouponLabel: UILabel!
    @IBOutlet weak var enterCouponTextField: UITextField!
    
    @IBOutlet weak var otherTipTextField: UITextField!
    
    @IBOutlet weak var tenButton: UIButton!
    
    @IBOutlet weak var fiftenButton: UIButton!
    
    @IBOutlet weak var tewntyButton: UIButton!
    
    @IBOutlet weak var cuponCodeValue: UILabel!
    
    
    @IBOutlet weak var cuponView: UIView!
    
    var recepitKit : [AddCart]?
    
    var orderId : String = ""
    
    var getSubTotal :Double = 0.0
    
    var tipValue : Double = 0.0
    
    var hst : Double = 0.0
    
    var finalTotal : Double = 0.0
    
    var couponCodeValue : Double = 0.0
    
    var randomValue : Int = 0
    
    var getLoginUser : User?
    
    //fore scrach code coupon
     let defualts = UserDefaults.standard
    
    var showCouponIfAvail : ScratchCoupon?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //for maps show resturant Location
        
        showRestuarntLocation()
        //to hide keyboard
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        for value in recepitKit! {
            
            let total = Double(self.subTotalLabel.text ?? "") ?? 0
            self.subTotalLabel.text =  String(total + value.cartMeal!.mealPrice)
            getSubTotal = total + value.cartMeal!.mealPrice
            
        }
        getLoginUser = DataManager.shared.getUserLogged
        
        //tax and total calclation
        generateRandomNo()
        taxCalculation()
        totalCalculation()
        
        //getting coupon value in  defaults
        
        if isCuponValid(){
            showCouponIfAvail = getCupon()
            if showCouponIfAvail != nil {
                couponDisplayView.isHidden = false
                showCouponLabel.isHidden = false
                showCouponLabel.text = showCouponIfAvail!.discount
                cuponCodeValue.text =  String(showCouponIfAvail!.cuponCode.prefix(8))
                
            }
        }else{
            if getCupon() != nil{
                //show alert
                showalert(title: "This cupon is not valid", msg: "Please try another cupon code.")
                removeUsedCupon()
            }
            showCouponLabel.isHidden = true
            couponDisplayView.isHidden = true
        }
    }
    
    //MARK: ViewDidLOad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    }
    
    
    //MARK: Actions
    
    @IBAction func tenPercentPressed(_ sender: Any) {
        tipValue = 0
        otherTipTextField.text = ""
        tipValue = getSubTotal * 10 / 100
        tenButton.backgroundColor = UIColor.blue
        fiftenButton.backgroundColor = UIColor.white
        tewntyButton.backgroundColor = UIColor.white
        taxCalculation()
        totalCalculation()
    }
    
    @IBAction func fifteenPercentPressed(_ sender: Any) {
        tipValue = 0
        otherTipTextField.text = ""
        tipValue = getSubTotal * 15 / 100
        fiftenButton.backgroundColor = UIColor.blue
        tenButton.backgroundColor = UIColor.white
        tewntyButton.backgroundColor = UIColor.white
        taxCalculation()
        totalCalculation()
        
    }
    
    @IBAction func tewntyPressed(_ sender: Any) {
        tipValue = 0
        otherTipTextField.text = ""
        tipValue = getSubTotal * 20 / 100
        tewntyButton.backgroundColor = UIColor.blue
        fiftenButton.backgroundColor = UIColor.white
        tenButton.backgroundColor = UIColor.white
        taxCalculation()
        totalCalculation()
    }
    
    //MARK: Pay Button
    @IBAction func payButtonmClicked(_ sender: Any) {
        defualts.set(false, forKey: getLoginUser!.userEmail! + "_scrachIsValid")
        saveReciptDetailsToDataBase()
        otherTipTextField.text = ""
        deleteDetailsInCart()
        self.navigationController?.popToRootViewController(animated: true)
        
       
    }
    
    //MARK: TAX Calculation and Total and Discount
    
    func taxCalculation(){
        
        hst = getSubTotal * 13 / 100
        taxLabel.text = String(hst)
    }
    
    func totalCalculation(){
        
        if tipValue == 0{
           finalTotal = getSubTotal + hst + couponCodeValue - discountCalculation()
            totalLabel.text = String(finalTotal)
        }
        else{
            finalTotal = getSubTotal + tipValue + hst + couponCodeValue - discountCalculation()
            totalLabel.text = String(finalTotal)
        }
    }
    
    func discountCalculation() -> Double{
        var discountValue = 0.0
        if showCouponIfAvail?.discount == "ZEROOFF"{
            discountValue = 0.0
            return discountValue
        }
        else if showCouponIfAvail?.discount == "TENOFF"{
            discountValue =  getSubTotal * 10 / 100
            return discountValue
        }
        else if showCouponIfAvail?.discount == "50OFF"{
            discountValue =  getSubTotal * 50 / 100
            return discountValue
        }
        return discountValue
    }
    //MARK: Table Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recepitKit!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReciptCell", for: indexPath) as? ReciptElememtTableViewCell
        cell?.mealNameValue.text = recepitKit![indexPath.row].cartMeal?.mealName
        cell?.skvValue.text = String((recepitKit![indexPath.row].cartMeal?.mealSku?.prefix(8))!)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
        
    }
    
    func generateRandomNo(){
        
        let lower : UInt32 = 100
        let upper : UInt32 = 1000000
        let randomNumber = arc4random_uniform(upper - lower) + lower
        
        print(randomNumber)
        
        randomValue = Int(randomNumber)
        
    }
    //MARK: Text Field Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        tewntyButton.backgroundColor = UIColor.white
        fiftenButton.backgroundColor = UIColor.white
        tenButton.backgroundColor = UIColor.white
        tipValue = 0
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        tipValue = Double(self.otherTipTextField.text ?? "") ?? 0
        taxCalculation()
        totalCalculation()
    }
    
    //when return pressed in keyboard to hide
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //to stop editing in textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: saving detailsto the database
    func saveReciptDetailsToDataBase(){
        
        let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let receiptVaues = Receipt(context: myContext)
        
        receiptVaues.orderid = Int32(randomValue)
        receiptVaues.total = finalTotal
        receiptVaues.subTotal = getSubTotal
        receiptVaues.tax = hst
        receiptVaues.tip = tipValue
        receiptVaues.userDetails = getLoginUser
        
        for value in recepitKit! {
            receiptVaues.reciptMeal = value.cartMeal
        }
        do{
            //to save data into database
            try myContext.save()
            print("Details Saved")
            
        }
        catch{
            print("Cannot save Details")
        }
       
    }
    //MARK: GETCOUPONCode
    func getCupon() -> ScratchCoupon? {
        if let savedCpon = defualts.object(forKey: getLoginUser!.userEmail! + "_scrach") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(ScratchCoupon.self, from: savedCpon) {
                return loadedPerson
            }
        }
        return .none
    }
    
    func isCuponValid() -> Bool{
        if getCupon() != nil {
            let valid = defualts.bool(forKey: getLoginUser!.userEmail! + "_scrachIsValid")
            return valid
        }
        return false
    }
    
    func removeUsedCupon(){
        defualts.removeObject(forKey: getLoginUser!.userEmail! + "_scrach")
    }
    
    //MARK:Maps location
    func showRestuarntLocation(){
        
        let intialLocation =  CLLocationCoordinate2D(latitude: 43.7254913, longitude: -79.764275)
        //2. what is the zoom level of the map ( MKmeans mapkit)
        
        //let zoomLevel = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        //3. Create region object
        
        let region = MKCoordinateRegion(center: intialLocation, latitudinalMeters: 100, longitudinalMeters: 100)
        
        //1.create a anotation object
        let montansPin = MKPointAnnotation()
        
        montansPin.coordinate = intialLocation
        
        montansPin.title = "Montanas Restuarnt"
        
        mapView.addAnnotation(montansPin)
    }
    
//    //MARK:delete details in check out when user clicked on pay

    func deleteDetailsInCart(){

        let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //delete data from core data
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AddCart")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try myContext.execute(deleteRequest)
            try myContext.save()
        } catch {
            print ("There was an error")
        }

    }
    
    func showalert(title : String,msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
extension RecipetViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RecipetViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
