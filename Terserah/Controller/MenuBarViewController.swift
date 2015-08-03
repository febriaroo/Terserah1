//
//  MenuBarViewController.swift
//  Terserah
//
//  Created by Febria Roosita Dwi on 7/28/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//

import UIKit

class MenuBarViewController: UIViewController {

    @IBAction func closeButton(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {
            self.navigationController?.popViewControllerAnimated(true)
        });
        
    }
    @IBAction func homeButtonAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {
            self.navigationController?.popViewControllerAnimated(true)
        });
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "MenuBackground.png")!)
        //self.modalPresentationStyle = UIModalPresentationCurrentContext
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
