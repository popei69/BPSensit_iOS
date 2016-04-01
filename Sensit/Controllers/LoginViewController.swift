//
//  LoginViewController.swift
//  Sensit
//
//  Created by Benoit PASQUIER on 29/02/2016.
//  Copyright © 2016 Benoit Pasquier. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, SensitManagerDelegate {

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 66/255, green: 158/255, blue: 166/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    @IBAction func requestUserPermission(sender: AnyObject) {
        
        SensitWebManager.sharedManager.delegate = self
        if let url = SensitWebManager.sharedManager.getUserTokenUrl() {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    // MQRK: - SensitManagerDelegate
    
    func sensitDidAuthenticate(response: AnyObject?) {
        
        let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("DeviceListNavigation")
        navigationController?.modalTransitionStyle = .FlipHorizontal
            
        self.presentViewController(navigationController!, animated: true, completion: nil)
    }
    
    func sensitDidFailAuthenticate(error: NSError) {
        
        let alertViewController = UIAlertController(title: "An error occured", message: error.localizedDescription, preferredStyle: .Alert)
        alertViewController.addAction(UIAlertAction(title: "Close", style: .Destructive, handler: { (action) -> Void in
            alertViewController.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
