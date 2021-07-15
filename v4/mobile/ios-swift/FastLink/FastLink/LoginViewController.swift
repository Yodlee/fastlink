// Copyright (c) 2021 Yodlee, Inc. All Rights Reserved.
// Licensed under the MIT License. See `LICENSE` for details.

import UIKit

@available(iOS 13.0, *)
class LoginViewController: UIViewController, UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var SignInBtn: UIButton!
    @IBOutlet weak var FastlinkURLTF: UITextField!
    @IBOutlet weak var AccessTokenTF: UITextField!
    @IBOutlet weak var ExtraParamsTV: UITextView!
    @IBOutlet weak var yodleeImageView: UIImageView!
    
    //File path for Config.plist
    let configFilePath = Bundle.main.path(forResource: "Config", ofType: "plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set dark mode app
        if self.traitCollection.userInterfaceStyle == .dark {
            self.SignInBtn.layer.backgroundColor = UIColor.black.cgColor
            self.SignInBtn.layer.borderColor = UIColor.lightGray.cgColor
            self.SignInBtn.layer.borderWidth = 0.3
            self.yodleeImageView.image = UIImage(named: "yodleeDarkMode")
        }
        
        //Set border color, width and corner radius for extraparams view
        self.ExtraParamsTV.layer.borderColor = UIColor.lightGray.cgColor
        self.ExtraParamsTV.layer.borderWidth = 0.4
        self.ExtraParamsTV.layer.cornerRadius = 5
        
        //Set corner radius for signin button
        self.SignInBtn.layer.cornerRadius = 5

        let fastLinkURL = self.configInfoForKey(key:"FastLinkURL").addingPercentEncoding(withAllowedCharacters:.urlFragmentAllowed)
        
        FastlinkURLTF.text = fastLinkURL
        ExtraParamsTV.text = "configName=Aggregation&intentUrl=yodlee://backtofastlink"
        
        //Move textfield when keypad is persent on the view
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Getting information from config file path
      func configInfoForKey(key:String) -> String {
         let configInfo = NSDictionary(contentsOfFile: self.configFilePath!)
         let infoData = configInfo?.value(forKey: key)
         return infoData as! String
      }
    
    //Fuction for dismiss keyboard
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //Fuction for show keypad
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y = 0
                self.view.frame.origin.y -= 170
                self.view.layoutIfNeeded()
            })
        }
    }

    //Function for hide keypad
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y = 0
                self.view.layoutIfNeeded()
            })
        }
    }

    @IBAction func onSignInClick(_ sender: UIButton) {
        if((FastlinkURLTF.text) == "" || AccessTokenTF.text == ""){
            let alert = UIAlertController(title: "Warning!", message: "Please enter the values", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert, animated: true)
            return
        }
        
        let yourVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FastLinkView") as! FastLinkViewController
        yourVc.fastlinkURL = FastlinkURLTF.text ?? ""
        yourVc.accessToken = AccessTokenTF.text ?? ""
        yourVc.extraParams = ExtraParamsTV.text ?? ""
        yourVc.modalPresentationStyle = .fullScreen
        self.navigationController?.show(yourVc, sender: nil)
    }
    
    //UITextField delegate method to return the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == FastlinkURLTF {
            AccessTokenTF.becomeFirstResponder()
        }
        return true
    }
    
    //UITextView delegate method to return the keyboard
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

