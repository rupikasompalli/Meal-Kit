//
//  TrackOrderViewController.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-06-01.
//  Copyright © 2020 Rupika. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class TrackOrderViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    //MARK: Outlet
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager : CLLocationManager?
    
    var userLocation: CLLocationCoordinate2D?
    
    var userPin: MKPointAnnotation?
    
     var timer :Timer?
    
    var checkAlert : Bool = false
    
     let intialLocation =  CLLocationCoordinate2D(latitude: 43.7306206, longitude: -79.7669499)
    
    @IBOutlet weak var Logout: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        
        
        //ask  users permission and also keep permision in plist
        
        self.locationManager?.requestWhenInUseAuthorization()
        
        //get user location
        
        self.locationManager?.startUpdatingLocation()
        
        showRestuarntLocation()
        
    }
    //MARK : Delegate method.
    
    //delegate method for CLLocation
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = manager.location!.coordinate
        
        
        //Have to 3km here. Calculations HOw?
        let span = MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
        let region = MKCoordinateRegion(center: userLocation!, span: span)
        if userPin == nil {
            userPin = MKPointAnnotation()
            userPin?.coordinate = userLocation!
             userPin?.title = "Your Location"
            if let getPinForUser = userPin{
                
                mapView.addAnnotation(getPinForUser)
            }
        }
    
        userPin?.coordinate = userLocation!
        
        mapView.setRegion(region, animated: true)
        //calling geoFencingLocation
        
        geoFencingAlert()
        
        print("current location updated")
    }
    
    func geoFencingAlert(){
        if let userLocation = userLocation{
            
            let loc1 = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let loc2 = CLLocation(latitude: intialLocation.latitude, longitude: intialLocation.longitude)
            let distance = loc1.distance(from: loc2)
            print(distance)
            if distance < 500 {
                
                if checkAlert == false {
                    
                    checkAlert = true
                    
                    showalert(title: "Your order is processing", msg: "Your order will be ready in 15 mintues", okCliked: { action in
                        
                    })
                    
                    timer = Timer.scheduledTimer(withTimeInterval:  60, repeats: true) { (timer) in
                        
                        
                        self.showalert(title: "Your order is Ready To PickUP", msg: "Your order is Ready", okCliked: { action in
                            self.timer?.invalidate()
                            self.timer = nil
                        })
                        
                    }
                     RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
                }
            }
        }
    }
    //MARK: Restuarnt Location
    
    func showRestuarntLocation(){
        
       
        //2. what is the zoom level of the map ( MKmeans mapkit)
        
        //let zoomLevel = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        //3. Create region object
        
        let region = MKCoordinateRegion(center: intialLocation, latitudinalMeters: 300, longitudinalMeters: 300)
        
        //1.create a anotation object
        let montansPin = MKPointAnnotation()
        
        montansPin.coordinate = intialLocation
        
        montansPin.title = "Montanas Restuarnt"
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(montansPin)
    }
    
    
    func showalert(title : String,msg : String, okCliked:@escaping (UIAlertAction)->Void){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertAction.Style.default, handler: okCliked))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Actions
    
    @IBAction func zoomInClicked(_ sender: Any) {
        
        var region: MKCoordinateRegion = mapView.region
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
        mapView.setRegion(region, animated: true)
    }
    
    
    @IBAction func zoomOutClicked(_ sender: Any) {
    
        var region: MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
        mapView.setRegion(region, animated: true)
    
    }
    @IBAction func LogOutClicked(_ sender: Any) {
        
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
