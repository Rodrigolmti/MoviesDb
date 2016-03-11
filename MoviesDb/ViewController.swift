//
//  ViewController.swift
//  MoviesDb
//
//  Created by Rodrigo on 3/11/16.
//  Copyright © 2016 Rodrigo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var movieTF: UITextField!
    @IBOutlet weak var nameLB: UILabel!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        getMovie("Frozen")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
        
    func getMovie(query: String) {
        let baseUrl: String = "http://www.omdbapi.com/?t=\(query)&tomatoes=true"
        Alamofire.request(.GET, baseUrl).responseJSON{
            response in guard response.result.error == nil else {
            
                print("Error calling GET on parameters")
                print(response.result.error!)
                return
            }
            
            if let value: AnyObject = response.result.value {
                let post = JSON(value)
                print("The value is: " + post.description)
                
            }

        }
    }
}

