//
//  RecordingViewController.swift
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

class RecordingViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var secondAudioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    var audioRecorder: AVAudioRecorder!
    var soundRecorder: AVAudioRecorder!
    var fileName = "audioFile.m4a"
    
    let parseClassName: String = "Feedbacks"
    let parseFeedBackName: String = "audioName"
    let parseObjectIDs: String = "objectId"
    let parseFeedBack: String = "audioFile"
    let parseFeedBackTitle: String = "audioTitle"
    
    @IBOutlet weak var recordBtn: UIButton!
    
    var imagePlay:UIImage!
    var userSelectedLocation: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeRecordingState(1)
        
        setupRecorder()
        
        let gesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        gesture.minimumPressDuration = 1.0
        
        self.view.addGestureRecognizer(gesture)
    }
    
    func setupRecorder()
    {
        // set up the audio session
        // the audio session acts as the middle man between the app and the system's media service
        // answers question like should the app stops the currently playing music, should be allowed to play back the recording
        let audioSession = AVAudioSession.sharedInstance()
        
        do
        {
            
            try audioSession.setCategory(AVAudioSessionCategoryRecord)

        } catch let error {
            print(error)
        }
        
        let recordSettings: [String : AnyObject] =
        [
            AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatMPEG4AAC),
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue as NSNumber,
            AVEncoderBitRateKey : 320000 as NSNumber,
            AVNumberOfChannelsKey: 2 as NSNumber,
            AVSampleRateKey : 44100.0 as NSNumber
        ]
        
        do
        {
            soundRecorder = try AVAudioRecorder(URL: getFileUrl(), settings: recordSettings)
        }
        catch
        {
            print("An error occured: \(error)")
        }
        
        soundRecorder.delegate = self
        soundRecorder.meteringEnabled = true
        soundRecorder.prepareToRecord()
    }
    
    func getCacheDirectory()->String
    {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return paths[0]
    }
    
    func getFileUrl()->NSURL
    {
        let path = NSString(string: getCacheDirectory()).stringByAppendingPathComponent(fileName)
        
        let filePath = NSURL(string: path)
        
        return filePath!
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeRecordingState(count: Int)
    {
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        switch(count)
        {
        case 1:// recording off
            UIImage(named: "troov2recordinghold")?.drawInRect(self.view.bounds)
            break
        case 2: // recording on
            UIImage(named: "troov2recordingrelease")?.drawInRect(self.view.bounds)
            break
        default:
            break
        }
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    func longPressed(longPress: UIGestureRecognizer)
    {
        if longPress.state == .Began && soundRecorder.recording == false
        {
            changeRecordingState(2)
            do
            {
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setActive(true)    // make the recorder work
                soundRecorder.record()
                print("Starting Recording...")
            }
            catch
            {
                print("An error occured: \(error)")
            }
        }
        else if longPress.state == .Ended
        {
            soundRecorder.stop()
            changeRecordingState(1)
            
            let alert = UIAlertController(title: "Done!", message: "Attach a title to your feedback", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = "E.g. Fun at \(self.userSelectedLocation)"
                //textField.text = "Norris"
            })
            alert.addAction(UIAlertAction(title: "New Post", style: UIAlertActionStyle.Cancel, handler: { (action:UIAlertAction!) -> Void in
                
                let path = NSString(string: self.getCacheDirectory()).stringByAppendingPathComponent(self.fileName)
                let filePath = NSURL(fileURLWithPath: path)
                let dataToUpload : NSData = NSData(contentsOfURL: filePath)!
                let textField = alert.textFields![0] as UITextField
                let soundFile = PFFile(name: self.fileName, data: dataToUpload)
                
                let newFeedBack = PFObject(className: self.parseClassName)
                newFeedBack[self.parseFeedBackTitle] = textField.text
                newFeedBack[self.parseFeedBackName] = self.userSelectedLocation
                newFeedBack[self.parseFeedBack] = soundFile
                newFeedBack.saveInBackground()
                print("saved")
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
//    @IBAction func recordBtnAction(sender: AnyObject)
//    {
//        if soundRecorder.recording == false
//        {
//            soundRecorder.record()
//            print("Starting Recording...")
//        }
//        else
//        {
//            soundRecorder.stop()
//            
//            let alert = UIAlertController(title: "Done!", message: "Attach a title to your feedback", preferredStyle: UIAlertControllerStyle.Alert)
//                        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
//                            textField.placeholder = "E.g. Fun at \(self.userSelectedLocation)"
//                            //textField.text = "Norris"
//                        })
//            alert.addAction(UIAlertAction(title: "New Post", style: UIAlertActionStyle.Cancel, handler: { (action:UIAlertAction!) -> Void in
//                
//                let path = NSString(string: self.getCacheDirectory()).stringByAppendingPathComponent(self.fileName)
//                let filePath = NSURL(fileURLWithPath: path)
//            let dataToUpload : NSData = NSData(contentsOfURL: filePath)!
//            let textField = alert.textFields![0] as UITextField
//            let soundFile = PFFile(name: self.fileName, data: dataToUpload)
//            
//            let newFeedBack = PFObject(className: self.parseClassName)
//            newFeedBack[self.parseFeedBackTitle] = textField.text
//            newFeedBack[self.parseFeedBackName] = self.userSelectedLocation
//            newFeedBack[self.parseFeedBack] = soundFile
//            newFeedBack.saveInBackground()
//                            print("saved")
//                        }))
//            
//            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
//                        
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
//    }
}
