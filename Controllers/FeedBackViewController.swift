//
//  FeedBackViewController.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/24/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit

enum Rating: Int {
    case OneStar = 0
    case TwoStars
    case ThreeStars
    case FourStars
    case FiveStars
}

class FeedBackViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var feedbacksTableView: UITableView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var feebackField: UITextField!
    
    @IBOutlet weak var oneStarBtn: UIButton!
    @IBOutlet weak var twoStarBtn: UIButton!
    @IBOutlet weak var threeStarBtn: UIButton!
    @IBOutlet weak var fourStarBtn: UIButton!
    @IBOutlet weak var fiveStarBtn: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var addBtnView: UIView!
    
    var feedbacks: [FeedBack] = []
    var newFeedback1 = FeedBack()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    var keyboardListener: KeyboardListener?
    var currentFeedbackRating: Int = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        navigationBar.setBackgroundImage(UIImage(named: "background"), for: .default)
        navigationBar.isTranslucent = true
        navigationBar.layer.shadowOpacity = 1.0
        navigationBar.layer.shadowRadius = 1.0
        navigationBar.layer.shadowOffset = CGSize(width: 1, height: 1)
        automaticallyAdjustsScrollViewInsets = false
        
        newFeedback1.name = "NEHA LALWANI"
        newFeedback1.text = "THANK YOU ALL FOR USING OUR APP, PLEASE FEEL FREE TO ADD ANY COMMENTS AND FEEDBACKS ABOUT THE APP!. WE'LL TRY TO MEET ALL EXPECTATIONS AS SOON AS POSSIBLE!!"
        newFeedback1.numberOfStars = 4
        feedbacks.append(newFeedback1)
        feedbacksTableView.delegate = self
        feedbacksTableView.dataSource = self
        //keyboardListener = KeyboardListener(scrollView: feedbacksTableView!, constraint: bottomConstraint!)
        initBottomViewShadow()
        initTextFieldsUI()
    }
    func textFieldShouldReturn(_ textField: UITextField)-> Bool{
        nameField.resignFirstResponder()
        feebackField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initBottomViewShadow() {
        bottomView?.layer.shadowOpacity = 1.0
        bottomView?.layer.shadowRadius = 1.0
        bottomView?.layer.shadowOffset = CGSize(width: 0, height: -1)
    }
    
    private func initTextFieldsUI() {
        let color = UIColor(red: 130.0/255.0, green: 123.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        
        if let nameField = self.nameField, let namePlaceholder = nameField.placeholder {
            nameField.attributedPlaceholder = NSAttributedString(string: namePlaceholder, attributes: [NSAttributedStringKey.foregroundColor: color])
        }
        
        if let feedbackField = self.feebackField, let feedbackPlaceholder = feedbackField.placeholder {
            feedbackField.attributedPlaceholder = NSAttributedString(string: feedbackPlaceholder, attributes: [NSAttributedStringKey.foregroundColor: color])
        }
    }
    
    private func changeRatingFor(newRating: Int) {
        currentFeedbackRating = newRating
        
        let starImage = UIImage(named: "star_chosen")
        let greyStarImage = UIImage(named: "star_unchosen")
        
        let arrayOfButtons: [UIButton?] = [oneStarBtn, twoStarBtn, threeStarBtn, fourStarBtn, fiveStarBtn]
        
        for i in 0 ... newRating {
            if let btn = arrayOfButtons[i]! as UIButton! {
                btn.setImage(starImage, for: .normal)
            }
        }
        
        for i in 0 ... newRating {
            if let btn = arrayOfButtons[i]! as UIButton! {
                btn.setImage(greyStarImage, for: .normal)
            }
        }
    }

    @IBAction func sendFeedback(_ sender: Any) {
        let newFeedback = FeedBack()
        
        if let name = nameField?.text {
            newFeedback.name = name
        }
        
        if let text = feebackField?.text {
            newFeedback.text = text
        }
        
        newFeedback.numberOfStars = currentFeedbackRating
        feedbacks.append(newFeedback)
        
        feedbacksTableView?.reloadData()
        
        nameField?.text = ""
        feebackField?.text = ""
        nameField?.resignFirstResponder()
        feebackField?.resignFirstResponder()
    }
    
    @IBAction func onOneStar(_ sender: Any) {
        changeRatingFor(newRating: Rating.OneStar.rawValue)
    }
    
    @IBAction func onTwoStar(_ sender: Any) {
        changeRatingFor(newRating: Rating.TwoStars.rawValue)
    }
    
    @IBAction func onThreeStar(_ sender: Any) {
        changeRatingFor(newRating: Rating.ThreeStars.rawValue)
    }
    
    @IBAction func onFiveStar(_ sender: Any) {
        changeRatingFor(newRating: Rating.FiveStars.rawValue)
    }
    
    @IBAction func onFourStar(_ sender: Any) {
        changeRatingFor(newRating: Rating.FourStars.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(feedbacks.count)
        return feedbacks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeedbackTableViewCell = tableView.dequeueReusableCell(withIdentifier: "feedBackCell") as! FeedbackTableViewCell
        cell.backgroundColor = UIColor.clear
        
        let feedback = feedbacks[indexPath.row]
        
        cell.feedbackNameLabel?.text = feedback.name
        cell.feedbackTextLabel?.text = feedback.text
        cell.updateViewForRating(rating: feedback.numberOfStars)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell: FeedbackTableViewCell = tableView.dequeueReusableCell(withIdentifier: "feedBackCell") as! FeedbackTableViewCell
        
        let feedback = feedbacks[indexPath.row]
        
        cell.feedbackNameLabel?.text = feedback.name
        cell.feedbackTextLabel?.text = feedback.text
        
        let height = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        return height
    }
}
