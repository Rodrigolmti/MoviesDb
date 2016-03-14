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
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var allMovies = [DataMovies]()

    @IBOutlet weak var tableViewMovie: UITableView!
    @IBOutlet weak var movieTF: UITextField!
    
    @IBAction func btnRegister(sender: AnyObject) {
        if movieTF.text != ""{
            if let movieName = movieTF.text {
                movieTF.text = ""
                getMovie(movieName)
            }
        } else {
            self.alert(NSLocalizedString("Ops .:.", comment: ""), message: NSLocalizedString("Please put the name of a movie!", comment: ""))
        }
        
    }
    
    override func viewDidLoad() {        
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {

        let fetchRequest = NSFetchRequest(entityName: "Movies")
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            self.allMovies = results as! [DataMovies]
            self.tableViewMovie.reloadData()
            //print(self.allMovies)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.allMovies.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "last added movies"
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMovies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! CustomCell
        
        var movieRow = createObject()
        movieRow = self.allMovies[indexPath.row]
        
        cell.titleLB.text = movieRow.title
        cell.genreLB.text = movieRow.genre
        
        if ((movieRow.baseimg?.isEmpty) != nil) {
            cell.imageIMG.nk_setImageWith(NSURL(string: movieRow.baseimg!)!)
        }
        
        return cell
    }
    
    // Request JSON on OMDB
    
    func getMovie(query: String) {
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let ent = NSEntityDescription.entityForName("Movies", inManagedObjectContext: context)
        let movies = DataMovies(entity: ent!, insertIntoManagedObjectContext:context)
        
        if NetworkRechability.isConnectedToNetwork() == true {
        
                let baseUrl: String = "http://www.omdbapi.com/?t=\(query)&tomatoes=true&type=movie"
                        
                Alamofire.request(.GET, baseUrl).validate().responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            let error = json["Error"].string
                            
                            if(error == nil) {
                                if (json["imdbID"].string! != movies.imdbid){
                                    
                                    movies.imdbid = json["imdbID"].string
                                    movies.title = json["Title"].string!
                                    movies.genre = json["Genre"].string!
                                    movies.director = json["Director"].string!
                                    movies.plot = json["Plot"].stringValue
                                    movies.rating = json["imdbRating"].string!
                                    movies.actors = json["Actors"].stringValue
                                    movies.baseimg = json["Poster"].stringValue
                                    
                                    self.allMovies.append(movies)
                                    self.tableViewMovie.reloadData()
                                    
                                    do {
                                        try context.save()
                                    } catch {
                                        fatalError("Failure to save context: \(error)")
                                    }

                                    print("Object saved!")
                                    print("Object: ")
                                    print(movies)
                                    
                                    
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
    
    func createObject() -> DataMovies {
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let ent = NSEntityDescription.entityForName("Movies", inManagedObjectContext: context)
        let movies = DataMovies(entity: ent!, insertIntoManagedObjectContext:context)
        return movies
    }
    
    // Detail segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableViewMovie?.indexPathForCell(sender as! UITableViewCell) {
            let detailVC = segue.destinationViewController as! MovieDetailController
            let currentMovie = allMovies[indexPath.row]
            
            detailVC.baseImg = currentMovie.baseimg
            detailVC.titleMovie = currentMovie.title
            detailVC.director = currentMovie.director
            detailVC.plot = currentMovie.plot
            detailVC.rating = currentMovie.rating
            detailVC.actors = currentMovie.actors
            detailVC.genre = currentMovie.genre

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

