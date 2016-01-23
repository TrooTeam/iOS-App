//
//  FeedBackTableVC.swift
//  Troo
//
//  Created by Emil Shirima on 12/19/15.
//  Copyright © 2015 Emil Shirima. All rights reserved.
//

import UIKit
import AVKit
import Parse
import MapKit
import CoreLocation
import AVFoundation

public var audioPlayer = AVPlayer()
public var selectedSongNumber = Int()

class FeedBackTableVC: UITableViewController, AVAudioPlayerDelegate {
    
    let parseClassName: String = "Feedbacks"
    let parseFeedBackName: String = "audioName"
    let parseObjectIDs: String = "objectId"
    let parseFeedBack: String = "audioFile"
    let parseFeedBackTitle: String = "audioTitle"
    var currentLocation: String = String()
    
    var iDArray = [String]()
    var nameArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let objectIDQuery = PFQuery(className: self.parseClassName)
        objectIDQuery.addDescendingOrder("createdAt")
        
        objectIDQuery.findObjectsInBackgroundWithBlock { (objectsArray: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil
            {
                if objectsArray?.count > 0
                {
                    var tempArray = objectsArray
                    
                    for i in 0...tempArray!.count-1
                    {
                        let currentSongID = tempArray![i].valueForKey(self.parseObjectIDs) as! String
                        let currentSongName = tempArray![i].valueForKey(self.parseFeedBackName) as! String
                        var currentTitle = ""
                        
                        if let thisTitle = tempArray![i].valueForKey(self.parseFeedBackTitle)
                        {
                            currentTitle = thisTitle as! String
                        }
                                                
                        if currentSongName == self.currentLocation
                        {
                            self.iDArray.append(currentSongID)
                            self.nameArray.append(currentTitle)
                            self.tableView.reloadData()
                        }
                    }
                }
                else
                {
                    //MARK: This line of code should hypothetically never be executed
                    //TODO: Create an alert to the user
                    print("No objects to retrieve apparently")
                }
            }
            else
            {
                //TODO: Add an alert to the user about the retrieval error
                print("Parse Song Retrieval Error: \(error?.userInfo)")
                print("Parse Song Retrieval L/Description: \(error?.localizedDescription)")
            }
            
            
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func grabSong()
    {
        let songQuery = PFQuery(className: self.parseClassName)
        
        songQuery.getObjectInBackgroundWithId(iDArray[selectedSongNumber]) { (object: PFObject?, error: NSError?) -> Void in
            
            if let songFile = object?[self.parseFeedBack] as? PFFile
            {
                let audioFileUrlString: String = songFile.url!
                let audioFileUrl = NSURL(string: audioFileUrlString)
                audioPlayer = AVPlayer(URL: audioFileUrl!)
                audioPlayer.play()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return iDArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = nameArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedSongNumber = indexPath.row
        grabSong()
    }
}
