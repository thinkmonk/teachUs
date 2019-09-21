//
//  ViewClassSelection.swift
//  TeachUs
//
//  Created by ios on 3/3/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

protocol ViewClassSelectionDelegate {
    func classViewDismissed()
}

class ViewClassSelection: UIView {

    @IBOutlet weak var buttonSelectAll: UIButton!
    @IBOutlet weak var buttonDeselectAll: UIButton!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var tableviewClassList: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
    var delegate : ViewClassSelectionDelegate!
    var dataSOurceArray =  [SelectCollegeClass]()
    var isAdminScreen : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableviewClassList.delegate = self
        self.tableviewClassList.dataSource = self
        self.buttonSelectAll.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        self.buttonSubmit.roundedRedButton()

    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.delegate.classViewDismissed()
    }
    
    @IBAction func selectAllClasses(_ sender: Any) {
        self.buttonSelectAll.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        self.buttonDeselectAll.makeButtonwith(background: .white, fontColor: .black, cornerRadius: nil, borderColor: nil, borderWidth: nil)

        if isAdminScreen{
            CollegeClassManager.sharedManager.selectedAdminClassArray = CollegeClassManager.sharedManager.selectedAdminClassArray.map({classSelected in
                classSelected.isSelected = true
                self.setUpView(array: CollegeClassManager.sharedManager.selectedAdminClassArray , isAdminScreenFlag: isAdminScreen)
                return classSelected
            })
        }else{
            CollegeClassManager.sharedManager.selectedClassArray = CollegeClassManager.sharedManager.selectedClassArray.map({classSelected in
                classSelected.isSelected = true
                self.setUpView(array: CollegeClassManager.sharedManager.selectedClassArray , isAdminScreenFlag: isAdminScreen)
                return classSelected
            })
        }
        self.tableviewClassList.reloadData()
    }
    
    func setUpView(array:[SelectCollegeClass], isAdminScreenFlag :Bool){
        self.dataSOurceArray = array
        self.isAdminScreen = isAdminScreenFlag
    }
    
    @IBAction func deselectAllClasses(_ sender: Any) {
        self.buttonDeselectAll.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        self.buttonSelectAll.makeButtonwith(background: .white, fontColor: .black, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        if isAdminScreen{
            CollegeClassManager.sharedManager.selectedAdminClassArray = CollegeClassManager.sharedManager.selectedAdminClassArray.map({classSelected in
                classSelected.isSelected = false
                self.setUpView(array: CollegeClassManager.sharedManager.selectedAdminClassArray, isAdminScreenFlag: isAdminScreen)
                return classSelected
            })
        }else{
            
            CollegeClassManager.sharedManager.selectedClassArray = CollegeClassManager.sharedManager.selectedClassArray.map({classSelected in
                classSelected.isSelected = false
                self.setUpView(array: CollegeClassManager.sharedManager.selectedClassArray, isAdminScreenFlag: isAdminScreen)

                return classSelected
            })
        }
        self.tableviewClassList.reloadData()
    }
    
}

extension ViewClassSelection:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSOurceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            return cell
        }()
        
        cell.textLabel?.text = "\(dataSOurceArray[indexPath.row].collegeClass?.yearName ?? "")\(dataSOurceArray[indexPath.row].collegeClass?.courseCode ?? "") - \(dataSOurceArray[indexPath.row].collegeClass?.classDivision ?? "")"
        
        cell.accessoryType = dataSOurceArray[indexPath.row].isSelected! ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSOurceArray[indexPath.row].isSelected = !dataSOurceArray[indexPath.row].isSelected
        self.tableviewClassList.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        dataSOurceArray[indexPath.row].isSelected = !dataSOurceArray[indexPath.row].isSelected
        self.tableviewClassList.reloadData()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewClassSelection", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
