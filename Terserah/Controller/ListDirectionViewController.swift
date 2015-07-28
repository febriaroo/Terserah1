////
////  ListDirectionViewController.swift
////  Terserah
////
////  Created by Febria Roosita Dwi on 7/27/15.
////  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
////
//
//import UIKit
//
//class ListDirectionViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource  {
//
//        
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        println("You selected cell #\(indexPath.row)!")
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
//        
//        cell.textLabel?.text = self.items[indexPath.row]
//        
//    }
//    
//
//
//}
