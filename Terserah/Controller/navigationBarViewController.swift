//
//  navigationBarViewController.swift
//  Terserah
//
//  Created by Febria Roosita Dwi on 7/23/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//

import UIKit
import Foundation

class navigationBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var bgImageView : UIImageView!
    @IBOutlet var tableView   : UITableView!
    @IBOutlet var dimmerView  : UIView!
    
    var items : [NavigationModel]!
    var snapshot : UIView = UIView()
    var transitionOperator = TransitionOperator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        
        dimmerView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        bgImageView.image = UIImage(named: "nav-bg")
        
        let item1 = NavigationModel(title: "MY ACCOUNT", icon: "icon-home")
        let item2 = NavigationModel(title: "COMMENTS", icon: "icon-chat", count: "3")
        let item3 = NavigationModel(title: "FAVORITES", icon: "icon-star")
        let item4 = NavigationModel(title: "SETTINGS", icon: "icon-filter")
        let item5 = NavigationModel(title: "ABOUT", icon: "icon-info")
        
        items = [item1, item2, item3, item4, item5]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NavigationCell") as! NavigationCell
        let item = items[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.countLabel.text = item.count
        cell.iconImageView.image = UIImage(named: item.icon)
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.snapshot.removeFromSuperview()
        
        if (indexPath.row % 2 == 0){
            performSegueWithIdentifier("listview", sender: self)
        }else{
            performSegueWithIdentifier("othernav", sender: self)
        }
    }
    
    func finalizeTransitionWithSnapshot(snapshot: UIView){
        self.snapshot = snapshot
        view.addSubview(self.snapshot)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController as! UIViewController
        self.modalPresentationStyle = UIModalPresentationStyle.Custom
        toViewController.transitioningDelegate = self.transitionOperator
    }
}

class NavigationModel {
    
    var title : String!
    var icon : String!
    var count : String?
    
    init(title: String, icon : String){
        self.title = title
        self.icon = icon
    }
    
    init(title: String, icon : String, count: String){
        self.title = title
        self.icon = icon
        self.count = count
    }
}

