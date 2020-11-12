//
//  FastLinkViewController.swift
//  FastLink
//

import UIKit
import WebKit

@available(iOS 13.0, *)
class FastLinkViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    //Creating the instance of the WebView which is added in the StoryBoard
    @IBOutlet weak var webview: WKWebView!
    //Spinner to show when the FastLink to be loaded
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    var eventsInfo = [String]()
    //Data of the following variables will be set from the Login View.
    var fastlinkURL = ""
    var accessToken = ""
    var extraParams = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To Handle the Dark mode for the App
        if self.traitCollection.userInterfaceStyle == .dark {
            self.webview.overrideUserInterfaceStyle = .dark
            self.webview.backgroundColor = UIColor.black
            self.ActivityIndicator.color = UIColor.black
        }

        //Title for screen
        self.navigationItem.title = "FastLink"
        
        //Hiding navigation back button
        self.navigationItem.hidesBackButton = true
        
        self.ActivityIndicator.startAnimating()
        
        self.webview.uiDelegate = self
        self.webview.navigationDelegate = self
        
        //Add the WKScriptMessageHandler handler to the WebView
        //This will listen the events sent from FastLink to native
        //Note that name should be 'YWebViewHandler'. 
        self.webview.configuration.userContentController.add(self, name: "YWebViewHandler")

        //Create the Request Object that will be posted in the WebView
        guard let url = URL(string:fastlinkURL) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        //All the extraParams should be encoded with URL encode 
        guard let escapedExtraParams = extraParams.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
                
        //Construct the HTTP body params
        let postString = "accessToken=Bearer " + accessToken + "&extraParams=" + (escapedExtraParams)
        request.httpBody = postString.data(using: .utf8)

        //Load the request in the WebView
        self.webview.load(request)
        
        self.ActivityIndicator.hidesWhenStopped = true
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ActivityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ActivityIndicator.stopAnimating()
    }
}

//Delegate method for WKScriptMessageHandler
//This will listen the Events passed from FastLink Application to Native
//You can take the appropriate action for the each Event
@available(iOS 13.0, *)
extension FastLinkViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
         if(message.name == "YWebViewHandler") {
            var json = [String: Any]()
            guard let messageBody = message.body as? String else { return }
            eventsInfo.append(messageBody)
            if let data = messageBody.data(using: .utf8) {
                do {
                    json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            //Account Addition status will be passed to native through the POST_MESSAGE event
            //If the 'action' is 'exit', in that case user have clicked on the close/finish button in the FastLink, 
            //You can close the FastLink WebView and navigate to the other views in your Application
            if(json["type"] as! String == "POST_MESSAGE"){
                if let data = json["data"] as? [String:Any] {
                    let action =  data["action"] as! String
                    if(action == "exit"){
                        //Navigating to the EventsInfoView, where all the native events log will be printed
                        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EventsInfoView") as? EventsInfoViewController
                        controller?.modalPresentationStyle = .overCurrentContext
                        controller?.eventsInfo = eventsInfo
                        self.navigationController?.show(controller!, sender: nil)
                    }
                }
            }

            //When user clicks on any External Link 'OPEN_EXTERNAL_URL' event will be triggered. 
            //You can open the Link either in Another WebView or in SFSafariViewController or in default Browser.
            if(json["type"] as! String == "OPEN_EXTERNAL_URL"){
                //In this Sample App External url is opened in the Default browser
                if let data = json["data"] as? [String:Any] {
                    guard let url = URL(string: data["url"] as! String) else { return }
                    UIApplication.shared.open(url)
                }
            }
            print(json["type"] as Any)
         }
     }
}

