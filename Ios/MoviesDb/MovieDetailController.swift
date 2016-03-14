//
//  MovieDetailController.swift
//  MoviesDb
//
//  Created by Rodrigo on 3/11/16.
//  Copyright © 2016 Rodrigo. All rights reserved.
//

import UIKit
import Nuke
import CoreData

class MovieDetailController: UIViewController {

    @IBOutlet weak var imageDetal: UIImageView!
    @IBOutlet weak var titleDetail: UILabel!
    @IBOutlet weak var directorDetail: UILabel!
    @IBOutlet weak var plotDetail: UILabel!
    @IBOutlet weak var actorsDetail: UILabel!
    @IBOutlet weak var ratingDetail: UILabel!
    @IBOutlet weak var genreDetail: UILabel!
    
    var baseImg: String!
    var titleMovie: String!
    var director: String!
    var plot: String!
    var actors: String!
    var genre: String!
    var rating: String!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configDetail()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createObject(movie: DataMovies) -> DataMovies{
        return movie
    }
    
    func configDetail() {        
        imageDetal.nk_setImageWith(NSURL(string: baseImg!)!)
        titleDetail.text = titleMovie
        directorDetail.text = director
        plotDetail.text = plot
        actorsDetail.text = actors!
        ratingDetail.text = rating
        genreDetail.text = genre
    }
    
}
