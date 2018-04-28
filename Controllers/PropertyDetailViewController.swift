//
//  PropertyDetailViewController.swift
//  propertyManagerFinalProject
//
//  Created by Neha Lalwani on 4/22/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class PropertyDetailViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource, CLLocationManagerDelegate,MKMapViewDelegate {
    var apartment : Apartment?
    var imageArray = [UIImage(named : "img1"), UIImage(named : "img2"),UIImage(named : "img3")]
    
    @IBOutlet weak var addressLine: UITextField!
    @IBOutlet weak var cityStatePostal: UITextField!
    @IBOutlet weak var propDescription: UITextView!
    @IBOutlet weak var bedBathSize: UITextField!
    var locationManager : CLLocationManager?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.hideKeyboardWhenTappedAround()
//
//        if let url = URL(string: "tel://\(8573209769)"), UIApplication.shared.canOpenURL(url) {
//            if #available(iOS 10, *) {
//                UIApplication.shared.open(url)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
//
        
        let propertyManager = getPropertyManager(userName:(apartment?.propertyManagerUserName)! )
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        locationManager = CLLocationManager()
        
        self.locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
       // let coordinate = CLLocationCoordinate2D(latitude:42.345828 , longitude:-71.085362)

        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookApartmentSegue" {
            let controller = segue.destination as! bookApartmentViewController
            controller.apartment = apartment
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (apartment?.apartmentImages?.count)!
       // return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
       
        if let profileImageUrl = self.apartment?.apartmentImages?[indexPath.row]{
          print("........................")
            print(profileImageUrl)
            let url = URL(string:profileImageUrl)
            let session = URLSession(configuration: .default)
            //creating a dataTask
            let getImageFromUrl = session.dataTask(with: url!) { (data, response, error) in
                
                //if there is any error
                if let e = error {
                    //displaying the message
                    print("Error Occurred: \(e)")
                    
                } else {
                    //in case of now error, checking wheather the response is nil or not
                    if (response as? HTTPURLResponse) != nil {
                        
                        //checking if the response contains an image
                        if let imageData = data {
                            
                            //getting the image
                            let image = UIImage(data: imageData)
                            
                            DispatchQueue.global().async {
                                cell.imgImage.image = image
                            }
                            
                        } else {
                            print("Image file is currupted")
                        }
                    } else {
                        print("No response from server")
                    }
                }
            }
            
            //starting the download task
            getImageFromUrl.resume()
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(apartment?.numberOfBeds)
        let locValue:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:(apartment?.propertyAddress!.latitude)!, longitude:(apartment?.propertyAddress!.longitude)!)
        
        mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = apartment?.propertyAddress!.addressLine1
        mapView.addAnnotation(annotation)
    }
    
    
    func getPropertyManager(userName : String) -> PropertyManager{
        print(userName)
        let ref: DatabaseReference =  Database.database().reference()
        let propManager = PropertyManager()
        ref.child("users").child(userName).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if(!snapshot.hasChildren()){
                print("Error getting property manager with user name : \(userName)")
                return
            }
            
            let phone = value?["phone"] as! Int64
            let managementName = value?["managementName"] as! String
            print(phone)
            print(managementName)
            propManager.name = managementName
            propManager.phone = phone
            
            print(propManager.phone!)
            let sentence1 = "\((self.apartment?.propertyAddress?.addressLine1)!) : Charming, naturally well-lit \(( self.apartment?.numberOfBeds)!) bedroom \(( self.apartment?.numberOfBaths)!) bathroom apartment ."
            let sentence2 = "Close to the red line, shops and nightlife on Well’s Street, and walking distance to the Whole Foods. "
            let sentence3  = "\((self.apartment?.rent!)!)/month, 1 month security deposit. Utilities not included. Call \(propManager.name!) at \((propManager.phone)!)."
            self.apartment?.amenites = sentence1 + sentence2 + sentence3
            self.addressLine.text = self.apartment?.propertyAddress?.addressLine1!
            self.cityStatePostal.text = "\((self.apartment?.propertyAddress?.city)!), \((self.apartment?.propertyAddress?.state)!) , \((self.apartment?.propertyAddress?.postalCode)!)"
            self.bedBathSize.text = "\((self.apartment?.numberOfBeds)!) beds . \((self.apartment?.numberOfBaths)!) baths. 1234 sqft"
            self.propDescription.text = self.apartment?.amenites!
            
            
        })
        
        return propManager
    }

}
