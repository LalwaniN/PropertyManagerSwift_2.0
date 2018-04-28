//
//  AboutUsViewController.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/23/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Card")! as! CardTableViewCell
        var member : Member = team![indexPath.row]
        //cell.aboutLabel.text = member.about!
       // cell.facebook = member.facebook!
        //cell.locationLabel.text = member.location!
        //cell.facebookImage.image = UIImage(named:member.imageName!)!
        tableView.estimatedRowHeight = 250
        cell.useMember(member:member)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 300.0
    }
    
    @IBOutlet weak var tableView: UITableView!
    var team : [Member]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        createTeamDetails()
        tableView.dataSource = self
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func createTeamDetails() {
        var neha = Member()
        neha.name = "Neha Lalwani"
        neha.facebook = "https://www.facebook.com/neha.lalwani.12"
        neha.web = "http://www.github.com/LalwaniN"
        neha.imageName = "neha"
        neha.about = ""
        neha.location = ""
        neha.title = "Full Stack Developer"
        
        var chintan = Member()
        chintan.name = "Chintan Koticha"
        chintan.facebook = "https://www.facebook.com/chintan.koticha"
        chintan.web = "http://www.github.com/chintankoticha"
        chintan.imageName = "chintan"
        chintan.about = ""
        chintan.location = ""
        chintan.title = "Full Stack Developer"
        
        
        team?.append(neha)
        team?.append(chintan)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
