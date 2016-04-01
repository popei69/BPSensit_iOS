//
//  SensitLocalManager.swift
//  Sensit
//
//  Created by Benoit PASQUIER on 12/03/2016.
//  Copyright © 2016 Benoit Pasquier. All rights reserved.
//

import UIKit

class SensitLocalManager: NSObject {

    static let sharedManager = SensitLocalManager()
    
    let filePath = "data"
    
    func getJsonData() -> NSData? {
        if let path = NSBundle.mainBundle().pathForResource(filePath, ofType: "json") {
            return NSData(contentsOfFile: path)
        }
        
        return nil
    }
    
    func getDevices() -> [[String : AnyObject]]? {
        
        if let jsonData = self.getJsonData() {
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments)
                
                if let devices = json["devices"] as? [[String : AnyObject]] {
                    return devices;
                }
                
            } catch {
                print("error serializing JSON: \(error)")
            }
        }
        
        return nil
    }
    
    func getDeviceDetail(deviceId: Int) -> [String : AnyObject]? {
        
        if let jsonData = self.getJsonData() {
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments)
                
                if let device = json["device-detail"] as? [String : AnyObject] {
                    return device;
                }
                
            } catch {
                print("error serializing JSON: \(error)")
            }
        }
        
        return nil
    }
    
    func getSensorDetail(sensorId: Int) -> [String : AnyObject]? {
        
        if let jsonData = self.getJsonData() {
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments)
                
                if let sensor = json["sensor-detail"] as? [String : AnyObject] {
                    return sensor;
                }
                
            } catch {
                print("error serializing JSON: \(error)")
            }
        }
        
        return nil
    }
}
