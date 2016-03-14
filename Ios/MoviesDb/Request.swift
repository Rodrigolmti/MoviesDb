//
//  Request.swift
//  MoviesDb
//
//  Created by Rodrigo on 3/12/16.
//  Copyright © 2016 Rodrigo. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Resquest {

    // Request JSON OMDB api
    
    func requestJson(baseUrl: String) -> JSON{
        var json: JSON = nil
        
        Alamofire.request(.GET, baseUrl).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                     json = JSON(value)
                }
            case .Failure(let error):
                print(error)
            }
        }
        return json
    }
}
