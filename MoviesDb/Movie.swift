//
//  Movie.swift
//  MoviesDb
//
//  Created by Rodrigo on 3/11/16.
//  Copyright © 2016 Rodrigo. All rights reserved.
//

import Foundation

class Movie: NSObject {
    
    var title: String?
    var plot: String?
    var director: String?
    var genre: String?
    var imdbId: String?
    
    var json: [String : AnyObject]?
    
    override init() {
        
    }
    
    init(json: [String : AnyObject]) {
        self.json = json
        self.title = json["Title"] as? String
        self.plot = json["Plot"] as? String
        self.director = json["Director"] as? String
        self.genre = json["Genre"] as? String
        self.imdbId = json["imdbID"] as? String
    }

}

