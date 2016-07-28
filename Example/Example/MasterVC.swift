//
//  MasterViewController.swift
//  Example
//
//  Created by Peter Prokop on 17/10/14.
//
//

import UIKit

class MasterVC: UITableViewController {

    var exampleDescriptions = ["Wait overlay",
        "Wait overlay with text",
        "Overlay with text only",
        "Image and text overlay",
        "Progress",
        "Annoying notification on top",
        "Blocking wait overlay",
        "Blocking wait overlay with text",
    ]
    
    var types: Array<OverlayExampleVC.ExampleType> = [
        .wait,
        .waitWithText,
        .textOnly,
        .imageAndText,
        .progress,
        .annoyingNotification,
        .blockingWait,
        .blockingWaitWithText
    ]

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

    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOverlayExample" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let type = types[(indexPath as NSIndexPath).row]
                (segue.destinationViewController as! OverlayExampleVC).type = type
                (segue.destinationViewController ).title = exampleDescriptions[(indexPath as NSIndexPath).row]
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exampleDescriptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let exampleDescription = exampleDescriptions[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = exampleDescription
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: "showOverlayExample", sender: nil)
    }

}

