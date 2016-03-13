//
//  DataMovies.swift
//  MoviesDb
//
//  Created by Rodrigo on 3/12/16.
//  Copyright © 2016 Rodrigo. All rights reserved.
//

import CoreData

class DataMovies: NSManagedObject {

    @NSManaged var actors: String!
    @NSManaged var baseimg: String!
    @NSManaged var director: String!
    @NSManaged var genre: String!
    @NSManaged var imdbid: String!
    @NSManaged var plot: String!
    @NSManaged var rating: String!    
    @NSManaged var title: String!
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}
