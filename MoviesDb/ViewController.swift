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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var movie = Movie()
    var allMovies = [Movie]()
    
    @IBOutlet weak var tableViewMovie: UITableView!
    @IBOutlet weak var movieTF: UITextField!
    
    @IBAction func btnRegister(sender: AnyObject) {
        
        if let movieName = movieTF.text {
            movieTF.text = ""
            getMovie(movieName)
        }
        
    }
    
    override func viewDidLoad() {        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    //func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return "last added movies"
    //}
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMovies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! CustomCell
        
        cell.titleLB.text = self.movie.title
        cell.genreLB.text = self.movie.genre
        
        //cell.imageMovie.image = UIImage(named: images[indexPath.row])
        //cell.imageMovie.layer.cornerRadius = CGRectGetWidth(cell.imageMovie.frame) / 2
        //cell.imageMovie.layer.masksToBounds = true
        
        return cell
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
                
                print("Json value: " + post.description)
                
                let movies = Movie()
                if (post["imdbID"].string! != self.movie.imdbId) {

                    movies.imdbId = post["imdbID"].string
                    movies.title = post["Title"].string!
                    movies.genre = post["Genre"].string!
                    
                    self.allMovies.append(movies)
                    self.tableViewMovie.reloadData()
                    self.movie = movies
                }
            }
        }
    }
}

