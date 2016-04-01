//
//  SensorDetailController.swift
//  Sensit
//
//  Created by Benoit PASQUIER on 13/03/2016.
//  Copyright © 2016 Benoit Pasquier. All rights reserved.
//

import UIKit
import JBChartView

class SensorDetailController: UIViewController, JBLineChartViewDelegate, JBLineChartViewDataSource {
    
    @IBOutlet weak var chartContainer: UIView!
    let lineChartView = JBLineChartView()
    let footerChartView = JBLineChartFooterView()
    var data : [[String : AnyObject]] = []
    var valueData : [CGFloat] = []
    
    let dateFormatter = NSDateFormatter()
    let serverDateFormatter = NSDateFormatter()
    let shortDateFormatter = NSDateFormatter()
    
    var sensorId = 0
    var sensor : [String : AnyObject] = [String : AnyObject]()

    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var selectedValueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedDateLabel.text = ""
        selectedDateLabel.alpha = 0.0
        
        selectedValueLabel.text = ""
        selectedValueLabel.alpha = 0.0
        
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle
        
        serverDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        shortDateFormatter.dateStyle = .ShortStyle
        shortDateFormatter.timeStyle = .NoStyle
        
        // Do any additional setup after loading the view.
        
        if let sensor = SensitLocalManager.sharedManager.getSensorDetail(sensorId) {
            self.sensor = sensor
            
            if let history = sensor["history"] as? [[String : AnyObject]] {
                self.data = history.reverse()
                
                for value in self.data {
                    
                    if let currentValue = value["data"] as? String, let doubleValue = Double(currentValue){
                        valueData.append(CGFloat(doubleValue))
                    }
                }
                
                self.buildChart()
            }
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.displayLastValue()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func buildChart() {
        
        lineChartView.frame = CGRectMake(5, 5, chartContainer.frame.size.width - 10, chartContainer.frame.size.height - 20)
        
        lineChartView.delegate = self
        lineChartView.dataSource = self
        lineChartView.backgroundColor = UIColor.clearColor()
        
        // add footer
        footerChartView.frame = CGRectMake(5, 5, chartContainer.frame.size.width - 10, 20)
        footerChartView.backgroundColor = UIColor.clearColor()
        footerChartView.sectionCount = self.data.count
        footerChartView.leftLabel.text = self.getFirstValueDate()
        footerChartView.rightLabel.text = self.getLastValueDate()
        footerChartView.leftLabel.textColor = UIColor.lightGrayColor()
        footerChartView.rightLabel.textColor = UIColor.lightGrayColor()
        footerChartView.footerSeparatorColor = UIColor.lightGrayColor()
        
        lineChartView.footerView = footerChartView
        
        
        chartContainer.addSubview(lineChartView)
        chartContainer.backgroundColor = UIColor.clearColor()
        
        lineChartView.reloadData()
    }
    
    func displayLastValue() {
        
        if let lastValue = self.data.last {
            
            if let dateString = lastValue["date"] as? String {
            
                if let date = serverDateFormatter.dateFromString(dateString) {
                    selectedDateLabel.text = "Last value registered \n" + dateFormatter.stringFromDate(date)
                }
            }

            
            if let value = self.valueData.last {
                selectedValueLabel.text = "\(value)"
            }
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.selectedValueLabel.alpha = 1.0
                self.selectedDateLabel.alpha = 1.0
            })
        }
    }
    
    func getFirstValueDate() -> String {
        
        if let lastValue = self.data.first, let dateString = lastValue["date"] as? String, let date = serverDateFormatter.dateFromString(dateString) {
            return shortDateFormatter.stringFromDate(date)
        }
        
        return ""
    }
    
    func getLastValueDate() -> String {
        
        if let lastValue = self.data.last, let dateString = lastValue["date"] as? String, let date = serverDateFormatter.dateFromString(dateString) {
                return shortDateFormatter.stringFromDate(date)
        }
        
        return ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - JBChart
    
    func shouldExtendSelectionViewIntoHeaderPaddingForChartView(chartView: JBChartView!) -> Bool {
        return true
    }
    
    func shouldExtendSelectionViewIntoFooterPaddingForChartView(chartView: JBChartView!) -> Bool {
        return false
    }
    
    // MARK: - JBLineChart
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        return UInt(valueData.count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return false
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        
        let index = Int(horizontalIndex)
        return valueData[index]
    }

    func lineChartView(lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        
        return UIColor(red: 66/255, green: 158/255, blue: 166/255, alpha: 1)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        return 1.0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, dotRadiusForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        return 5.0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, lineStyleForLineAtLineIndex lineIndex: UInt) -> JBLineChartViewLineStyle {
        return .Solid
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorStyleForLineAtLineIndex lineIndex: UInt) -> JBLineChartViewColorStyle {
        return .Gradient
    }
    
    func lineChartView(lineChartView: JBLineChartView!, selectionColorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.whiteColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt, touchPoint: CGPoint) {
        
        // select value
        let index = Int(horizontalIndex)
        let currentValue = self.data[index]
        
        if let dateString = currentValue["date"] as? String, let date = serverDateFormatter.dateFromString(dateString) {
            selectedDateLabel.text = dateFormatter.stringFromDate(date)
        }
        
        selectedValueLabel.text = "\(self.valueData[index])"
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.selectedValueLabel.alpha = 1.0
            self.selectedDateLabel.alpha = 1.0
        }
    }
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        // deselect value
        
        UIView.animateWithDuration(0.5, delay: 2.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.selectedValueLabel.alpha = 0.0
            self.selectedDateLabel.alpha = 0.0
            }) { (bool) -> Void in
                self.selectedDateLabel.text = ""
                self.selectedValueLabel.text = ""
                self.displayLastValue()
        }
        
//        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            self.selectedValueLabel.alpha = 0.0
//            self.selectedDateLabel.alpha = 0.0
//            }) { (bool) -> Void in
//                self.selectedValueLabel.text = ""
//                self.selectedDateLabel.text = ""
//        }
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
