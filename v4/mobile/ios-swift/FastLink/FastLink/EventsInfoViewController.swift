//
//  EventsInfoViewController.swift
//  FastLink
//

import UIKit

@available(iOS 13.0, *)
class EventsInfoViewController: UIViewController {

    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var eventsInfoTextView: UITextView!
    
    var eventsInfo = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set dark mode app
        if self.traitCollection.userInterfaceStyle == .dark {
            self.logoutBtn.layer.backgroundColor = UIColor.black.cgColor
            self.logoutBtn.layer.borderColor = UIColor.lightGray.cgColor
            self.logoutBtn.layer.borderWidth = 0.3
        }
        
        //Setting border color, border width and corner round radius for ExtraParams TextView.
        self.eventsInfoTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.eventsInfoTextView.layer.borderWidth = 0.5
        self.eventsInfoTextView.layer.cornerRadius = 5
        self.logoutBtn.layer.cornerRadius = 5
        
        //Title for screen
        self.navigationItem.title = "Event Info"
        
        //Hiding navigation back button
        self.navigationItem.hidesBackButton = true
        
        var eventsInfoText = ""
        
        for (value) in eventsInfo {
           print("(\(value))")
            eventsInfoText = eventsInfoText + value + "\n\n"
        }
        
        eventsInfoTextView.isEditable = false
        eventsInfoTextView.text = eventsInfoText
    }

    
    @IBAction func onLogoutBtnClick(_ sender: UIButton) {
        for vc in (self.navigationController?.viewControllers ?? [] ){
            if vc is LoginViewController {
                _ = self.navigationController?.popToViewController(vc, animated: false)
            }
        }
    }
}
