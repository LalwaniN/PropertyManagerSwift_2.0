//
//  PropertyManagerViewController.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/12/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import Firebase

var strArray:[String] = ["1","2","3","4","5","6"]
class PropertyManagerViewController: UIViewController, UISearchBarDelegate  {
    //Outlets
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var propManagerUserName = ""
    var vacantApartments : [Apartment]? = []
    var filteredApartments : [Apartment]? = []
    var ref: DatabaseReference?
    var row: Int = 0
    var tenant: Tenant?
    var tenantList:[String] = []
    
    override func viewDidAppear(_ animated: Bool) {
        getAllApartments()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        tableView.dataSource = self
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchbar.showsScopeBar = true
        searchbar.scopeButtonTitles = ["Rented","Vacant"]
        searchbar.selectedScopeButtonIndex = 0
        searchbar.delegate = self

        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width:width, height:height))
        imageViewBackground.contentMode = .scaleAspectFit
        imageViewBackground.image = UIImage(named: "bcgd3")?.alpha(0.7)
        
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredApartments = vacantApartments
            self.tableView.reloadData()
        }else {
            filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    func filterTableView(ind:Int,text:String) {
        
        switch ind {
        case 0:
            //fix of not searching when backspacing
            filteredApartments = vacantApartments?.filter({ (mod) -> Bool in
                print(mod.isRented!)
                return ((mod.propertyAddress?.addressLine1?.lowercased().contains(text.lowercased()))! && mod.isRented! == true)
                
            })
            self.tableView.reloadData()
        case 1:
            //fix of not searching when backspacing
            filteredApartments = vacantApartments?.filter({ (mod) -> Bool in
                return ((mod.propertyAddress?.addressLine1?.lowercased().contains(text.lowercased()))! && mod.isRented! == false)
                
            })
            self.tableView.reloadData()
        default:
            print("no type")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "backToPropertyManagerHome" {
            let controller = segue.destination as! PropertyManagerHomeViewController
            controller.propManagerUserName = self.propManagerUserName
        }
    }
    
    func getAllApartments(){
        vacantApartments = []
        var apartment : Apartment?
        
        ref = Database.database().reference().child("apartments")
        ref?.queryOrdered(byChild: "propertyManagerUserName").queryEqual(toValue: self.propManagerUserName).observe(.childAdded, with: { (snapshot) in
            if(!snapshot.hasChildren()){
                print("No apartments available")
            }
            let values = snapshot.value as? NSDictionary
            print("--------------")
            print(values!)
            apartment = Apartment()
            apartment?.apartmentId = Int64(snapshot.key)
            apartment?.rent = values!["rent"] as? Double
            let isRentedStr = (values!["isRented"])! as? String
            if isRentedStr == "true"{
                 apartment?.isRented = true
            }else{
                 apartment?.isRented = false
            }
           
            print((values!["isRented"])!)
            apartment?.leaseSigned = values!["leaseSigned"] as? Bool
            apartment?.numberOfBeds = values!["numberOfBeds"] as? Double
            apartment?.numberOfBaths = values!["numberOfBaths"] as? Double
            apartment?.propertyType = values!["propertyType"] as? String
            apartment?.propertyManagerUserName = values!["propertyManagerUserName"] as? String
            if let address = (values!["address"])! as? NSDictionary{
                // print(address)
                //apartment!.propertyAddress = Address()
                apartment?.propertyAddress?.addressLine1 = address["addressLine1"] as? String
                print((apartment!.propertyAddress!.addressLine1)!)
                apartment?.propertyAddress?.addressLine2 = address["addressLine2"] as? String
                apartment?.propertyAddress?.city = address["city"] as? String
                apartment?.propertyAddress?.state = address["state"] as? String
                apartment?.propertyAddress?.country = address["country"] as? String
                apartment?.propertyAddress?.postalCode = address["postalcode"] as? Int
                apartment?.propertyAddress?.latitude = address["latitude"] as? Double
                apartment?.propertyAddress?.longitude = address["longitude"] as? Double
            }
            if let images = (values!["apartmentImages"])! as? [String]{
                for i in 0..<images.count{
                    print((images[i] as? String)!)
                    apartment?.apartmentImages?.append((images[i] as? String)!)
                }
            }
            self.vacantApartments?.append(apartment!)
            self.filteredApartments?.append(apartment!)
            self.tableView.reloadData()
        })
    }

}

extension PropertyManagerViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredApartments!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell")! as! PropertyManagerDataSourceCell
        let apartment = filteredApartments![indexPath.row]
        
        print(apartment.apartmentImages!)
        if let profileImageUrl = apartment.apartmentImages?[0]{
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
                                cell.imageView?.contentMode = .scaleAspectFill
                                cell.setupCell(image: image)
                                
                                //self.tableView.reloadData()
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
        cell.propertyLabel.text = apartment.propertyAddress?.addressLine1
        cell.rentLabel.text = String(describing: "$\(apartment.rent!)")
        cell.propertyLabel.layer.shadowColor = UIColor.black.cgColor
        cell.propertyLabel.layer.shadowOffset = CGSize(width:0, height:0)
        cell.propertyLabel.layer.shadowRadius = 6
        
        return cell
    }
}



class PropertyManagerDataSourceCell: UITableViewCell{
    
    @IBOutlet weak var rentLabel: UILabel!
    @IBOutlet weak var propertyImageView: UIImageView!
    @IBOutlet weak var propertyLabel: UILabel!
    func setupCell(image: UIImage?) {
        self.propertyImageView.image = image
    }
}
