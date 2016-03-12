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
    var baseUrl: String?
        
    override init() {
        
    }
}

