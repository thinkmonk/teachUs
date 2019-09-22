//
//  StudentListGridViewController.swift
//  TeachUs
//
//  Created by ios on 9/15/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class StudentListGridViewController: UIViewController {

    @IBOutlet weak var collectionViewStudentsGrid: UICollectionView!
    
    @IBOutlet weak var layoutTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var buttonSubmit: UIButton!
    let cellNibName = "StudentRollNumberCollectionViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibObj = UINib(nibName: cellNibName, bundle: nil)
        self.collectionViewStudentsGrid.register(nibObj, forCellWithReuseIdentifier: Constants.CustomCellId.rollNumberGrid)
        self.collectionViewStudentsGrid.delegate = self
        self.collectionViewStudentsGrid.dataSource = self
        self.buttonSubmit.themeRedButton()
        if let parentVC = self.parent as? StudentsListViewController{
            if (parentVC.buttonSubmit.isHidden){
                self.hideSubmit()
            }else{
                self.showSubmit()
            }
        }
    }
    
    @IBAction func closeView(_ sender: Any) {
        if let parentVC = self.parent as? StudentsListViewController{
            parentVC.tableStudentList.reloadData()
        }
        self.remove()
    }
    
    @IBAction func actionSubmitAttendance(_ sender: Any) {
        if let parentVC = self.parent as? StudentsListViewController, let button = sender as? UIButton{
            parentVC.submitAttendance(button)
        }
    }
    
    func showSubmit() {
        self.buttonSubmit.isHidden = false
        self.layoutTopConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.layoutTopConstraint.constant -= self.buttonSubmit.height()
        }
    }
    
    func hideSubmit() {
        self.layoutTopConstraint.constant = -self.buttonSubmit.height()
        UIView.animate(withDuration: 0.3) {
            self.layoutTopConstraint.constant = 0
            self.buttonSubmit.isHidden = true
        }
    }
    
}


extension StudentListGridViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AttendanceManager.sharedAttendanceManager.arrayStudents.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:StudentRollNumberCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CustomCellId.rollNumberGrid, for: indexPath) as! StudentRollNumberCollectionViewCell
        let student = AttendanceManager.sharedAttendanceManager.arrayStudents.value[indexPath.row]
        cell.setUpCell(studentObj: student)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? StudentRollNumberCollectionViewCell{
            AttendanceManager.sharedAttendanceManager.arrayStudents.value[indexPath.row].isPrsent.toggle()
            cell.isSelected = AttendanceManager.sharedAttendanceManager.arrayStudents.value[indexPath.row].isPrsent
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.width()/5
        let height = CGFloat(35.0)
        return CGSize(width: width, height: height)
    }
}
