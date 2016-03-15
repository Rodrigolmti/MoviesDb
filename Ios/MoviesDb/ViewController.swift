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
        self.loadObject()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMovies.count
    }
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell") as! CustomCell
        
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
        let movies = createObject()

        if NetworkRechability.isConnectedToNetwork() == true {
                let baseUrl: String = "http://www.omdbapi.com/?t=\(query)&tomatoes=true&type=movie"
                Alamofire.request(.GET, baseUrl).validate().responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            print(json.description)
                            let error = json["Error"].string
                            
                            if(error == nil) {
                                movies.imdbid = json["imdbID"].string
                                movies.title = json["Title"].string!
                                movies.genre = json["Genre"].string!
                                movies.director = json["Director"].string!
                                movies.plot = json["Plot"].stringValue
                                movies.rating = json["imdbRating"].string!
                                movies.actors = json["Actors"].stringValue
                                movies.baseimg = json["Poster"].stringValue
                                    
                                self.saveObject(movies)
                            } else {
                               self.alert(NSLocalizedString("Ops, Something Wrong", comment: ""), message: NSLocalizedString("Try again", comment: ""))
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
    
    //Crete object
    func createObject() -> DataMovies {
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let ent = NSEntityDescription.entityForName("Movies", inManagedObjectContext: context)
        let movies = DataMovies(entity: ent!, insertIntoManagedObjectContext:context)
        return movies
    }
    //Save object
    func saveObject(movie : DataMovies) {
        let context:NSManagedObjectContext = appDel.managedObjectContext
        do {
            try context.save()
            self.allMovies.append(movie)
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        self.tableViewMovie.reloadData()
    }
    
    //Load object
    func loadObject() {
        let fetchRequest = NSFetchRequest(entityName: "Movies")
        let context:NSManagedObjectContext = appDel.managedObjectContext
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            self.allMovies = results as! [DataMovies]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        self.tableViewMovie.reloadData()
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

