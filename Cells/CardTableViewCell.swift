import UIKit
import QuartzCore

class CardTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var aboutLabel: UILabel!
    @IBOutlet var profilePictureView: UIImageView!
    @IBOutlet var webLabel: UILabel!
    @IBOutlet var webButton: UIButton!
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var facebookImage: UIImageView!
    var facebook:String?
    
    func useMember(member:Member) {
        // Round those corners
        mainView.layer.cornerRadius = 10;
        mainView.layer.masksToBounds = true;
        
        // Fill in the data
        nameLabel.text = member.name
        titleLabel.text = member.title
        locationLabel.text = member.location
        aboutLabel.text = member.about
        profilePictureView.image = UIImage(named: member.imageName!)
        
        // Fill the buttons and show or hide them
        webLabel.text = member.web
        
        
        if let facebookURLString = member.facebook {
            facebookImage.isHidden = false
            facebook = facebookURLString
        }
        else {
            facebookImage.isHidden = true
            facebook = nil
        }
    }
    
    func jumpTo(URLString:String?) {
        if let URL = NSURL(string: URLString!) {
            UIApplication.shared.openURL(URL as URL)
        }
    }
    
    @IBAction func webButtonTapped(sender: AnyObject) {
        jumpTo(URLString: webLabel.text)
    }
    
    @IBAction func facebookButtonTapped(sender: AnyObject) {
        jumpTo(URLString: facebook)
    }
}

