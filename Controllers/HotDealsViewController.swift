//
//  HotDealsViewController.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/27/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

class HotDealsViewController: UIViewController,UITableViewDelegate {
    var apartmentId: Int64?
    var dealsList: [Deals] = []
    var deal :Deals?
    var sv:UIView?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 340
        tableView.rowHeight = UITableViewAutomaticDimension
        sv = UIViewController.displaySpinner(onView: self.view)
        loadDeals()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func loadDeals(){
        let session = URLSession.shared
        let postEndpoint: String = "https://api.discountapi.com/v2/deals?api_key=GIlcXRrd"
        print(postEndpoint)
        let url = URL(string: postEndpoint)!
        var request = URLRequest(url: url as URL)
        
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            let responseString = String(data: data!, encoding: String.Encoding.utf8)
            print("responseString = \(responseString!)")
            do{
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let deals = json["deals"] as? [[String:Any]] {
                    print(deals.count)
                    var i=0
                    for deal1 in deals {
                        self.deal = Deals()
                        if(i==10){
                            break
                        }
                        i += 1
                        let deal2 = deal1["deal"] as? [String:Any]
                        self.deal?.title = deal2!["title"]! as? String
                        self.deal?.value = String(describing: deal2!["value"]! as! NSNumber)
                        self.deal?.price = String(describing: deal2!["price"]! as! NSNumber)
                        let url = URL(string: (deal2!["image_url"]! as? String)!)
                        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        self.self.deal?.image = UIImage(data: data!)
                        self.dealsList.append(self.deal!)
                        }
                    }
                UIViewController.removeSpinner(spinner: self.sv!)
                self.tableView.reloadData()
                }catch  {
                    print("error parsing response from GET on hot deals!!")
                    return
                }
            }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "hotdealsBackSegue" {
            let controller = segue.destination as! TenantHomeViewController
            controller.apartmentId = self.apartmentId!
        }
    }
}

extension HotDealsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dealsList.count)
        return dealsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell")! as! HotDealsTableViewCell
        print(indexPath.row)
        let deal = dealsList[indexPath.row]
        
        print(deal.title!)
        
        tableView.rowHeight = 340
        cell.bigView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        cell.bigView.layer.shadowColor = UIColor.black.cgColor
        cell.bigView.layer.shadowOpacity = 1
        cell.bigView.layer.shadowOffset = CGSize.zero
        cell.bigView.layer.shadowRadius = 5
        cell.bigView.layer.shadowPath = UIBezierPath(rect: cell.bigView.bounds).cgPath
        cell.bigView.layer.shouldRasterize = true
        //print(deal.image?.size)
        cell.imageView1.image = deal.image
        cell.priceLabel.text = "NOW $\(deal.price!)"
        print(deal.price as String!)
        cell.descriptionLabel.text = deal.title
        let attrString:NSAttributedString? = NSAttributedString(string: "$\(deal.value!)", attributes: [NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue])
        cell.valueLabel.attributedText =  (attrString as NSAttributedString!)
        return cell
    }
}
