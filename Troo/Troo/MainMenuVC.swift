//
//  MainMenuVC.swift
//  Troo
//
//  Created by Emil Shirima on 1/23/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtons()
        findAllFonts()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setButtons()
    {
        editButton.layer.cornerRadius = 0.5 * editButton.bounds.size.width
        searchButton.layer.cornerRadius = 0.5 * searchButton.bounds.size.width
    }
    
//    for(NSString *fontfamilyname in [UIFont familyNames])
//    {
//    NSLog(@"Family:'%@'",fontfamilyname);
//    for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//    {
//    NSLog(@"\tfont:'%@'",fontName);
//    }
//    NSLog(@"~~~~~~~~");
//    }
    
    func findAllFonts()
    {
        for var fontFamilyName in UIFont.familyNames()
        {
            print("Font Family : ", fontFamilyName)
            for var fontName in UIFont.fontNamesForFamilyName(fontFamilyName)
            {
                print("Font: ", fontName)
            }
        }
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
