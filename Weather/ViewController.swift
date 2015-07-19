//
//  ViewController.swift
//  Weather
//
//  Created by Jain, Mohit on 7/18/15.
//  Copyright © 2015 Mohit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var weatherTextField: UITextField!
    @IBOutlet weak var weatherTextView: UITextView!
    
    
    func showError() {
        self.weatherTextView.text = "Unable to find weather for \(self.weatherTextField.text)"
    }
    
    
    func showErrorMeessage() {
        self.weatherTextView.text = "Please enter city"
    }
    
    
    
    @IBAction func findWeather(sender: AnyObject) {
        
        if (weatherTextField.text!.isEmpty ) {
            showErrorMeessage()
            return
        }
        
        let city = weatherTextField.text?.stringByReplacingOccurrencesOfString(" ", withString: "-")
        let url = NSURL(string: "http://www.weather-forecast.com/locations/" + city! + "/forecasts/latest")
        
        if (url != nil) {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {
                (data, response, error) -> Void in
                
                var urlError = false
                
                var weather = ""
                
                if error == nil {
                    
                    let urlContent = NSString(data:data!, encoding:NSUTF8StringEncoding) as NSString!
                    
                    let urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                    
                    
                    if (urlContentArray.count > 0) {
                        
                        let weatherArray = urlContentArray[1].componentsSeparatedByString("</span>")
                        
                        weather = weatherArray[0] as String
                        weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        
                    }
                }
                else {
                    urlError = true
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                if urlError == true {
                    self.showError()
                } else {
                    self.weatherTextView.text = weather
                    }
                }
                
            })
            task?.resume()
            
        }
        else {
            showError()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.weatherTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}

