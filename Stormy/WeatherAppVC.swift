//
//  ViewController.swift
//  Stormy
//
//  Created by Tejas Chaudhari on 6/14/16.
//  Copyright © 2016 Tejas Chaudhari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentTemparatureLabel: UILabel?
    @IBOutlet weak var currentHumidityLabel: UILabel?
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    
    @IBOutlet weak var image_Label: UIImageView!
    
    private let forcastAPIKey = "6c4ce246271d8268930c9f5e3fc5a0a6"
    //private because we want to access in this viewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCallAndParse()
        
    }
    
    func apiCallAndParse()
    {
        let requestURL: NSURL = NSURL(string: "https://api.forecast.io/forecast/\(forcastAPIKey)/37.8267,-122.423")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    if let jsonDataFromAPI = json["currently"] as? [String: AnyObject] {
                        print(jsonDataFromAPI)
                        
                        let temperature = jsonDataFromAPI["temperature"] as! Double
                        print(temperature)
                        let humidity = jsonDataFromAPI["humidity"] as! Double
                        // print(humidity * 100)
                        print("This is in background thread")
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            print("This is main thread from dispatch asyc")
                            
                            self.currentTemparatureLabel?.text = "\(temperature)º"
                            
                            self.currentHumidityLabel?.text = "\(humidity)"
                            
                            self.load_image("http://www.kaleidosblog.com/tutorial/kaleidosblog.png")
                        }
                        
                    }
                    
                    
                }
                    
                catch {
                    print("Error with Json: \(error)")
                }
                
            }
        }
        print("This is main thread")
        task.resume()
    }
    
func load_image(urlString:String)
    {
        
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response,data,error) -> Void in
                if error == nil {
                    self.image_Label.image = UIImage(data: data!)
                }
        })
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

