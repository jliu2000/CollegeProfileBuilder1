//
//  DetailViewController.swift
//  CollegeProfileBuilder1
//
//  Created by jliu on 2/6/17.
//  Copyright © 2017 Jason Liu. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    @IBOutlet weak var collegeName: UITextField!
    @IBOutlet weak var collegeEnrollment: UITextField!
    @IBOutlet weak var collegeLocation: UITextField!
    @IBOutlet weak var collegeImage: UIImageView!
    let realm = try! Realm()
    var detailItem: Colleges? {
        didSet {
            // Update the view!
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        if let college = self.detailItem {
            if collegeName != nil {
                collegeName.text = college.name
                collegeLocation.text = college.location
                collegeEnrollment.text = String(college.numberOfStudents)
                collegeImage.image = UIImage(data: college.image)
            }
        }
    }
    
    @IBAction func onSaveButtonTapped(_ sender: UIButton) {
        if let college = self.detailItem {
            try! realm.write ({
                college.name = collegeName.text!
                college.location = collegeLocation.text!
                college.numberOfStudents = Int(collegeEnrollment.text!)!
                college.image = UIImagePNGRepresentation(collegeImage.image!)!
            })
        }
    }
}
