//
//  ViewController.swift
//  MoviesDb
//
//  Created by Rodrigo on 3/11/16.
//  Copyright © 2016 Rodrigo. All rights reserved.
//

import UIKit
import Nuke
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var movie = Movie()
    var allMovies = [Movie]()
    var usersDefault = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var tableViewMovie: UITableView!
    @IBOutlet weak var movieTF: UITextField!
    
    @IBAction func btnRegister(sender: AnyObject) {
        if movieTF.text != ""{
            if let movieName = movieTF.text {
                movieTF.text = ""
                getMovie(movieName)
            }
        } else {
            self.alert(NSLocalizedString("Ops .:.", comment: ""), message: NSLocalizedString("Please put the name of a movie!", comment: "lala"))
        }
        
    }
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        configUser()
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
        
        if ((movie.baseUrl?.isEmpty) == nil) {
            cell.posterIMG.nk_setImageWith(NSURL(string: self.movie.baseUrl!)!)
        }
        
        //cell.imageMovie.layer.cornerRadius = CGRectGetWidth(cell.imageMovie.frame) / 2
        //cell.imageMovie.layer.masksToBounds = true
        
        return cell
    }
    
    func configUser() {
        self.usersDefault.setObject(allMovies, forKey: "movies")
    }

    // Request JSON on OMDB
    
    func getMovie(query: String) {
        
        if NetworkRechability.isConnectedToNetwork() == true {
        
                let baseUrl: String = "http://www.omdbapi.com/?t=\(query)&tomatoes=true"
                Alamofire.request(.GET, baseUrl).validate().responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            
                            print("Json value: " + json.description)
                            
                            let movies = Movie()
                           
                            let error = json["Error"].string
                            if(error == nil) {
                                if (json["imdbID"].string! != self.movie.imdbId) {
                                
                                    movies.imdbId = json["imdbID"].string
                                    movies.title = json["Title"].string!
                                    movies.genre = json["Genre"].string!
                                    movies.director = json["Director"].string!
                                    movies.plot = json["Plot"].stringValue
                                    movies.imdbRating = json["imdbRating"].string!
                                    movies.actors = json["Actors"].stringValue
                                
                                    movies.baseUrl = json["Poster"].stringValue
                                
                                    self.allMovies.append(movies)
                                    self.tableViewMovie.reloadData()
                                
                                    for var i=0; i < self.allMovies.count; i++ {
                                        print("Filmes incluidos: ")
                                        print(self.allMovies[0])
                                    }
                                
                                    self.movie = movies
                                
                                    print(movies.baseUrl!)
                                    print(movies.actors)
                                } else {
                                    self.alert(NSLocalizedString("Movies already added", comment: ""), message: NSLocalizedString("This movies was already added", comment: ""))
                                }
                            } else {
                               self.alert(NSLocalizedString("Ops, Something Wrong", comment: ""), message: NSLocalizedString(error!, comment: ""))
                            }
                        }
                    case .Failure(let error):
                      
                        print(error)
                    }
                }
            
            } else {
                self.alert(NSLocalizedString("No Internet", comment: ""), message: NSLocalizedString("There's no internet connection, try again later", comment: ""))
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableViewMovie?.indexPathForCell(sender as! UITableViewCell) {
            let detailVC = segue.destinationViewController as! MovieDetailController
            let currentMovie = allMovies[indexPath.row]
            
            detailVC.currentMovie = currentMovie
        }
    }
    
    // Alert Errors
    
    func alert(title: String, message: String) {
        if let _: AnyClass = NSClassFromString("UIAlertController") {
            let myAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            myAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
    }
}

