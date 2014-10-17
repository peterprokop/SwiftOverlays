//
//  MasterViewController.swift
//  Example
//
//  Created by Peter Prokop on 17/10/14.
//
//

import UIKit

class MasterVC: UITableViewController {

    var objects = ["Wait overlay", "Wait overlay with text", "Annoying notification on top"]
    var types: Array<OverlayExampleVC.ExampleType> = [.Wait, .WaitWithText, .AnnoyingNotification]

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOverlayExample" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let type = types[indexPath.row]
                (segue.destinationViewController as OverlayExampleVC).type = type
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = objects[indexPath.row]
        cell.textLabel?.text = object
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.performSegueWithIdentifier("showOverlayExample", sender: nil)
    }

}

