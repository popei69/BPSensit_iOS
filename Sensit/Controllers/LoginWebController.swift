//
//  LoginWebController.swift
//  Sensit
//
//  Created by Benoit PASQUIER on 29/02/2016.
//  Copyright © 2016 Benoit Pasquier. All rights reserved.
//

import UIKit

class LoginWebController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - WebViewDelegate
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print(error)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        print("start load request")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
