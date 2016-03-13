//
//  DataMovies.swift
//  MoviesDb
//
//  Created by Rodrigo on 3/13/16.
//  Copyright © 2016 Rodrigo. All rights reserved.
//

import Foundation
import CoreData

@objc(DataMovies)
class DataMovies: NSManagedObject {

    @NSManaged var actors: String?
    @NSManaged var baseimg: String?
    @NSManaged var director: String?
    @NSManaged var genre: String?
    @NSManaged var plot: String?
    @NSManaged var rating: String?
    @NSManaged var title: String?
    @NSManaged var imdbid: String?

}
