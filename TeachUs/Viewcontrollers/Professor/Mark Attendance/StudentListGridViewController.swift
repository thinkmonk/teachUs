//
//  StudentListGridViewController.swift
//  TeachUs
//
//  Created by ios on 9/15/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

protocol GridViewDelegate {
    func gridDismissed()
}


class StudentListGridViewController: UIViewController {

    @IBOutlet weak var collectionViewStudentsGrid: UICollectionView!
    
    @IBOutlet weak var layoutTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelAllPresent: UILabel!
    
    @IBOutlet weak var switchMarkAllPresent: UISwitch!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var delegate :GridViewDelegate!
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
        switchMarkAllPresent.isOn = AttendanceManager.sharedAttendanceManager.defaultAttendanceForAllStudents
        performUIChanges()
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate.gridDismissed()
        }
    }
    
    @IBAction func actionSubmitAttendance(_ sender: Any) {
        if let parentVC = self.parent as? StudentsListViewController, let button = sender as? UIButton{
            parentVC.submitAttendance(button)
        }
    }
    fileprivate func performUIChanges() {
        labelAllPresent.text = switchMarkAllPresent.isOn ? "All Present" : "All Absent"
        labelAllPresent.textColor = switchMarkAllPresent.isOn ? Constants.colors.themeBlue : .lightGray
    }
    
    @IBAction func actionAllPresntSwitch(_ sender: Any?) {
        AttendanceManager.sharedAttendanceManager.defaultAttendanceForAllStudents = switchMarkAllPresent.isOn
        performUIChanges()
        _ = AttendanceManager.sharedAttendanceManager.arrayStudents.value.map({
            $0.isPrsent = switchMarkAllPresent.isOn
        })
        collectionViewStudentsGrid.reloadData()
        AttendanceManager.sharedAttendanceManager.defaultAttendanceForAllStudents = switchMarkAllPresent.isOn
    }
    
    func showSubmit() {
        self.buttonSubmit.isHidden = false
        self.layoutTopConstraint.constant = -self.buttonSubmit.height()
        UIView.animate(withDuration: 0.3) {
            self.layoutTopConstraint.constant = 0
        }
    }
    
    func hideSubmit() {
        self.layoutTopConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.layoutTopConstraint.constant = -self.buttonSubmit.height()
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
