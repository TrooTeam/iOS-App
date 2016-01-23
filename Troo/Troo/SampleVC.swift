//
//  SampleVC.swift
//  Troo
//
//  Created by Emil Shirima on 12/20/15.
//  Copyright © 2015 Emil Shirima. All rights reserved.
//

import UIKit

class SampleVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add tap gesture recognizer to View
        var singleFingerTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        self.view!.addGestureRecognizer(singleFingerTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //The event handling method
    
    func handleSingleTap(recognizer: UITapGestureRecognizer)
    {
        var location: CGPoint = recognizer.locationInView(recognizer.view!.superview!)
        //Do stuff here...
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        UIImage(named: "troo main page 2")?.drawInRect(self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        print("This works")
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
