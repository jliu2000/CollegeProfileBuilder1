//
//  DetailViewController.swift
//  CollegeProfileBuilder1
//
//  Created by jliu on 2/6/17.
//  Copyright © 2017 Jason Liu. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collegeName: UITextField!
    @IBOutlet weak var collegeEnrollment: UITextField!
    @IBOutlet weak var collegeLocation: UITextField!
    @IBOutlet weak var collegeImage: UIImageView!
    @IBOutlet weak var websiteTextField: UITextField!
    let imagePicker = UIImagePickerController()
    
    
    let realm = try! Realm()
    
    var detailItem: Colleges? {
        didSet {
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        imagePicker.delegate = self
    }
    
    func configureView() {
        if let college = self.detailItem {
            if collegeName != nil {
                collegeName.text = college.name
                collegeLocation.text = college.location
                collegeEnrollment.text = String(college.numberOfStudents)
                websiteTextField.text = college.website
                collegeImage.image = UIImage(data: college.image)
            }
        }
    }
    
    @IBAction func onGoButtonTapped(_ sender: UIButton) {
        let urlString = websiteTextField.text!
        let url = URL(string: urlString)
        let avc = SFSafariViewController(url: url!)
        present(avc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true) {
            let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.collegeImage.image = selectedImage
        }
    }

    
    @IBAction func onLibraryButtonTapped(_ sender: UIButton) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func onSaveButtonTapped(_ sender: UIButton) {
        if let college = self.detailItem {
            try! realm.write ({
                college.name = collegeName.text!
                college.location = collegeLocation.text!
                college.numberOfStudents = Int(collegeEnrollment.text!)!
                college.website = websiteTextField.text!
                college.image = UIImagePNGRepresentation(collegeImage.image!)!
            })
            print("Save Completed")
        }
    }
}
