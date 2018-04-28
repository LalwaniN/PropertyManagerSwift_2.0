//
//  FirstViewController.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/23/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

var strArray1:[String] = ["1","2","3","4","5","6"]
enum selectedScope:Int {
    case rent = 0
    case zip = 1
    case bedrooms = 2
}
class FirstViewController: UIViewController, UISearchBarDelegate {

    
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var hamburgerViewBtn: UIBarButtonItem!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var searchBar: UISearchBar!
    var vacantApartments : [Apartment]? = []
    var filteredApartments : [Apartment]? = []
    var ref: DatabaseReference?
    var row: Int = 0
    
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        sideView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        sideView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        tableView.dataSource = self
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableViewAutomaticDimension
        
        blurView.layer.cornerRadius = 15
        sideView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOpacity = 0.7
        sideView.layer.shadowOffset = CGSize(width:5 ,height:0)
        
        viewConstraint.constant = -175
        self.view.sendSubview(toBack: tableView)
        self.view.sendSubview(toBack: searchBar)
        
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Rent","Street","Bedrooms"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
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
                if let rent:Double = Double(text){
                    return rent>=mod.rent!
                }else{
                   return false
                }
                
            })
            self.tableView.reloadData()
        case 1:
            //fix of not searching when backspacing
           filteredApartments = vacantApartments?.filter({ (mod) -> Bool in
            return (mod.propertyAddress?.addressLine1?.lowercased().contains(text.lowercased()))!

            })
            self.tableView.reloadData()
        case 2:
            //fix of not searching when backspacing
              filteredApartments = vacantApartments?.filter({ (mod) -> Bool in
                if let bedrooms = Double(text){
                return mod.numberOfBeds == bedrooms
                }
                return false
            })
            self.tableView.reloadData()
        default:
            print("no type")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllApartments()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func panPerformed(_ sender: UIPanGestureRecognizer) {
        if(sender.state == .began || sender.state == .changed){
            let translation = sender.translation(in: self.view).x
            
            if translation > 0 {    //swipe right action
                if viewConstraint.constant < 20 {
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.viewConstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }else{  // swipe left action
                if viewConstraint.constant > -175 {
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.viewConstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }else if sender.state == .ended {
            if viewConstraint.constant < -100 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewConstraint.constant = -175
                    self.view.layoutIfNeeded()
                })
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewConstraint.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @IBAction func hamburgerBtnAct(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            if(self.viewConstraint.constant >= 0){
                self.viewConstraint.constant = -175
                self.view.layoutIfNeeded()
            }else{
                self.viewConstraint.constant += 175
                self.view.layoutIfNeeded()
            }
        })
    }
    
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        
        let cell = sender.superview?.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let apartment =  filteredApartments?[(indexPath?.row)!]
        let address = apartment?.propertyAddress?.addressLine1
        let newString = address?.replacingOccurrences(of: " ", with: "+")
         print(newString!)
        let message = "Hey checkout this apartment!"
        let urlToShare = URL(string: "https://www.google.com/maps/place/\(newString!)")
        print(urlToShare!)
        let objectsToShare:NSArray = [message , urlToShare!]
        
        var activityController = UIActivityViewController(activityItems: objectsToShare as! [Any], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
        
    }
}



extension FirstViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print("count-----\(vacantApartments!.count)")
        return filteredApartments!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell")! as! firstPageViewCell
        //let apartment = vacantApartments![indexPath.row]
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
    
    func getAllApartments(){
        vacantApartments = []
        var apartment : Apartment?
        
        ref = Database.database().reference().child("apartments")
        ref?.queryOrdered(byChild: "isRented").queryEqual(toValue: "false").observe(.childAdded, with: { (snapshot) in
                if(!snapshot.hasChildren()){
                    print("No apartments available")
                }
                let values = snapshot.value as? NSDictionary
                  print("--------------")
                print(values!)
                apartment = Apartment()
                apartment?.apartmentId = Int64(snapshot.key)
                apartment?.rent = values!["rent"] as? Double
                apartment?.isRented = values!["isRented"] as? Bool
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

                    //}
                }
                self.vacantApartments?.append(apartment!)
                self.filteredApartments?.append(apartment!)
                self.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref?.removeAllObservers()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "propertySelectedIdentifier" {
            let controller = segue.destination as! PropertyDetailViewController
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                if (indexPath.section == 0) {
                    controller.apartment = filteredApartments?[indexPath.row]
                }
                
            }
        }
    }
}

class firstPageViewCell: UITableViewCell{
    
    @IBOutlet weak var propertyImageView: UIImageView!
    @IBOutlet weak var propertyLabel: UILabel!
    @IBOutlet weak var rentLabel: UILabel!
    func setupCell(image: UIImage?) {
        self.propertyImageView.image = image
    }
    
    
}

