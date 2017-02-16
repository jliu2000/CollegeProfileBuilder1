//
//  MasterViewController.swift
//  CollegeProfileBuilder1
//
//  Created by jliu on 2/6/17.
//  Copyright © 2017 Jason Liu. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices
class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    let realm = try! Realm()
    lazy var colleges: Results<Colleges> = {
    self.realm.objects(Colleges.self)
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        for college in colleges {
            objects.append(college)
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        let alert = UIAlertController(title: "Add College", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "College Name"
        }
        alert.addTextField { (textField) in //need autocompletion for this one. then press enter enter
            textField.placeholder = "Location of College"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "College Enrollment (No. Students)"
            textField.keyboardType = UIKeyboardType.numberPad //accesses UIKEYBOARDTYPE's numberpad property
        }
        alert.addTextField { (textField) in
            textField.placeholder = "College URL"
            textField.keyboardType = UIKeyboardType.URL
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)// handler is asking if there's something we want to do if the cancel gets activated. Could be useful.
        alert.addAction(cancelAction)
        let insertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let collegeName = alert.textFields![0] as UITextField
            let collegeLocation = alert.textFields![1] as UITextField
            let collegeEnrollment = alert.textFields![2] as UITextField
            let collegeWebsite = alert.textFields![3] as UITextField
            guard let image = UIImage(named: collegeName.text!) else { //make sure it's the same as the  college
                print("missing \(collegeName.text!)'s image")
                return
            }
            if let enrollment = Int((collegeEnrollment.text)!) {
                let college = Colleges(name: collegeName.text!, location: collegeLocation.text!, numberOfStudents: enrollment, image: UIImagePNGRepresentation(image)!, website: collegeWebsite.text!)
                
                self.objects.append(college)
                try! self.realm.write {
                self.realm.add(college)
                }
                self.tableView.reloadData()
                
            }
        }
        alert.addAction(insertAction)
        present(alert, animated: true, completion: nil)
        
        //different iteration of UIAlertAction() achieved by pressing enter on the handler an additional time
    
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! Colleges
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row] as! Colleges
        cell.textLabel!.text = object.name
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let college = objects.remove(at: indexPath.row) as! Colleges
            try! self.realm.write{
                self.realm.delete(college)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

