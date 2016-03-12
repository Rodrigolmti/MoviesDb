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
        
        var movieRow = Movie()
        movieRow = self.allMovies[indexPath.row]
        
        cell.titleLB.text = movieRow.title
        cell.genreLB.text = movieRow.genre
        
        if ((movieRow.baseUrlImg?.isEmpty) != nil) {
            cell.imageIMG.nk_setImageWith(NSURL(string: movieRow.baseUrlImg!)!)
            //cell.imageIMG.layer.cornerRadius = CGRectGetWidth(cell.imageIMG.frame) / 2
            //cell.imageIMG.layer.masksToBounds = true
        }
        
        return cell
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
                            
                            let error = json["Error"].string
                            if(error == nil) {
                                if (json["imdbID"].string! != self.movie.imdbId) {
                                
                                    var movies = Movie()
                                    var aux = Movie()
                                    
                                    movies.imdbId = json["imdbID"].string
                                    movies.title = json["Title"].string!
                                    movies.genre = json["Genre"].string!
                                    movies.director = json["Director"].string!
                                    movies.plot = json["Plot"].stringValue
                                    movies.imdbRating = json["imdbRating"].string!
                                    movies.actors = json["Actors"].stringValue
                                    movies.baseUrlImg = json["Poster"].stringValue
                                
                                    aux = movies
                                    
                                    self.allMovies.append(aux)
                                    self.tableViewMovie.reloadData()
                                
                                    self.movie = movies
                                    movies = Movie()
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
    
    // Detail segue
    
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

