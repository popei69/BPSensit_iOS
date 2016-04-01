//
//  DeviceListController.swift
//  Sensit
//
//  Created by Benoit PASQUIER on 08/03/2016.
//  Copyright © 2016 Benoit Pasquier. All rights reserved.
//

import UIKit

class DeviceListController: UIViewController, UITableViewDataSource, UITableViewDelegate, SensitManagerDelegate {
    
    var data : [[String : AnyObject]] = []
    
    @IBOutlet weak var deviceTableView: UITableView!
    let dateFormatter = NSDateFormatter()
    let serverDateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle
        
        serverDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        self.title = "Devices"

        // Do any additional setup after loading the view.
        if let data = SensitLocalManager.sharedManager.getDevices() {
            self.data = data
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        SensitWebManager.sharedManager.delegate = self
        SensitWebManager.sharedManager.getDevices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - TableViewDataSource & Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // build cell device
        let cell : DeviceCell = tableView.dequeueReusableCellWithIdentifier("DeviceCell") as! DeviceCell
        
        let device = self.data[indexPath.row]
        
        if let serialNumber = device["serial_number"] as? String {
            cell.serialLabel.text = serialNumber
        } else {
            cell.serialLabel.text = ""
        }
        
        if let lastConnection = device["last_comm_date"] as? String, let lastDate = serverDateFormatter.dateFromString(lastConnection) {
            cell.dateLabel.text = "Last communication :\n" + dateFormatter.stringFromDate(lastDate)
        } else {
            cell.dateLabel.text = ""
        }
        
        if let battery = device["battery"] as? Int {
            
            if battery > 60 {
                cell.batteryLabel.textColor = UIColor(red: 56/255, green: 157/255, blue: 0, alpha: 1.0) // green
            } else if battery > 20 {
                cell.batteryLabel.textColor = UIColor(red: 208/255, green: 155/255, blue: 0, alpha: 1.0) // yellow
            } else {
                cell.batteryLabel.textColor = UIColor(red: 202/255, green: 0, blue: 0, alpha: 1.0) // red
            }
            
            cell.batteryLabel.layer.cornerRadius = cell.batteryLabel.frame.height / 2
            cell.batteryLabel.layer.borderColor = cell.batteryLabel.textColor.CGColor
            cell.batteryLabel.layer.borderWidth = 1.0
            cell.batteryLabel.text = "\(battery) %"
        } else {
            
            cell.batteryLabel.layer.borderWidth = 0
            cell.batteryLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // select device
        
        let device = self.data[indexPath.row]
        
        let listController = self.storyboard?.instantiateViewControllerWithIdentifier("SensorListController") as! SensorListController
        if let id = device["id"] as? Int {
            listController.deviceId = id
        }
        
        self.navigationController?.pushViewController(listController, animated: true)
    }
    
    
    // MARK: - Sensit
    
    func sensitGetDevices(devices: [[String : AnyObject]]) {
        self.data = devices
        deviceTableView.reloadData()
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
