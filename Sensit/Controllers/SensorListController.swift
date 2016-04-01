//
//  SensorListController.swift
//  Sensit
//
//  Created by Benoit PASQUIER on 13/03/2016.
//  Copyright © 2016 Benoit Pasquier. All rights reserved.
//

import UIKit

class SensorListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sensors : [[String : AnyObject]] = []
    
    var device : [String : AnyObject] = [String : AnyObject]()
    var deviceId : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let device = SensitLocalManager.sharedManager.getDeviceDetail(deviceId) {
            
            self.device = device
            
            if let serialNumber = device["serial_number"] as? String {
                self.title = serialNumber
            }
            
            if let sensors = device["sensors"] as? [[String : AnyObject]] {
                
                // remove button from sensors
                for sensor in sensors {
                    if let sensorType = sensor["sensor_type"] as? String where sensorType != "button" {
                        self.sensors.append(sensor)
                    }
                }
            }
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
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
        return sensors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // build sensor cell
        
        let cell : DeviceCell = tableView.dequeueReusableCellWithIdentifier("SensorCell") as! DeviceCell
        
        let sensor = sensors[indexPath.row]
        
        if let sensorType = sensor["sensor_type"] as? String {
            cell.serialLabel.text = sensorType.capitalizedString
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // sensor selected
        
        let sensor = sensors[indexPath.row]
        
        let viewController : SensorDetailController = self.storyboard?.instantiateViewControllerWithIdentifier("SensorDetailController") as! SensorDetailController
        
        if let sensorId = sensor["id"] as? Int {
            viewController.sensorId = sensorId
        }
        
        if let sensorType = sensor["sensor_type"] as? String {
            viewController.title = sensorType.capitalizedString
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
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
