//
//  ViewClassSelection.swift
//  TeachUs
//
//  Created by ios on 3/3/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

protocol ViewClassSelectionDelegate {
    func classViewDismissed(_ dataSourceObj:Any?)
    func selectAllClasses(_ dataSourceObj:Any?)
    func deselectAllClasses(_ dataSourceObj:Any?)
}

class ViewClassSelection: UIView {

    @IBOutlet weak var buttonSelectAll: UIButton!
    @IBOutlet weak var buttonDeselectAll: UIButton!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var tableviewClassList: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var viewBg: UIView!
    var delegate : ViewClassSelectionDelegate!
    var dataSOurceArray =  [Any]()
    var isAdminScreen : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableviewClassList.delegate = self
        self.tableviewClassList.dataSource = self
        self.buttonSelectAll.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        self.buttonSubmit.roundedRedButton()

    }
    
    override func draw(_ rect: CGRect) {
        self.viewBg.makeEdgesRounded()
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.delegate.classViewDismissed(self.dataSOurceArray)
    }
    
    @IBAction func selectAllClasses(_ sender: Any) {
        self.buttonSelectAll.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        self.buttonDeselectAll.makeButtonwith(background: .white, fontColor: .black, cornerRadius: nil, borderColor: nil, borderWidth: nil)

        self.delegate.selectAllClasses(self.dataSOurceArray)
        /*
        if isAdminScreen{
            CollegeClassManager.sharedManager.selectedAdminClassArray = CollegeClassManager.sharedManager.selectedAdminClassArray.map({classSelected in
                classSelected.isSelected = true
                self.setUpView(array: CollegeClassManager.sharedManager.selectedAdminClassArray)
                return classSelected
            })
        }else{
            CollegeClassManager.sharedManager.selectedClassArray = CollegeClassManager.sharedManager.selectedClassArray.map({classSelected in
                classSelected.isSelected = true
                self.setUpView(array: CollegeClassManager.sharedManager.selectedClassArray )
                return classSelected
            })
        }
        self.tableviewClassList.reloadData()
         */
    }
    
    func setUpView(array:[Any]){
        self.dataSOurceArray = array
        self.tableviewClassList.reloadData()
    }
    
    @IBAction func deselectAllClasses(_ sender: Any) {
        self.buttonDeselectAll.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        self.buttonSelectAll.makeButtonwith(background: .white, fontColor: .black, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        self.delegate.deselectAllClasses(self.dataSOurceArray)
        /*
        if isAdminScreen{
            CollegeClassManager.sharedManager.selectedAdminClassArray = CollegeClassManager.sharedManager.selectedAdminClassArray.map({classSelected in
                classSelected.isSelected = false
                self.setUpView(array: CollegeClassManager.sharedManager.selectedAdminClassArray)
                return classSelected
            })
        }else{
            
            CollegeClassManager.sharedManager.selectedClassArray = CollegeClassManager.sharedManager.selectedClassArray.map({classSelected in
                classSelected.isSelected = false
                self.setUpView(array: CollegeClassManager.sharedManager.selectedClassArray)
                
                return classSelected
            })
        }
        self.tableviewClassList.reloadData()
         */
    }
    
}

extension ViewClassSelection:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSOurceArray as? [SelectCollegeClass]{
            return dataSource.count
        }
        return dataSOurceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            return cell
        }()
        if let dataSource = dataSOurceArray as? [SelectCollegeClass], let classObj = dataSource[indexPath.row].collegeClass {
            cell.textLabel?.text = "\(classObj.yearName )\(classObj.courseCode)\(classObj.classDivision)"
            
            cell.accessoryType = dataSource[indexPath.row].isSelected! ? .checkmark : .none
        }
        if let dataSource = dataSOurceArray as? [UserControl]{
            let  controlObj = dataSource[indexPath.row]
            cell.textLabel?.text = controlObj.user ?? ""
            cell.accessoryType = dataSource[indexPath.row].isSelected ? .checkmark : .none
        }
        if let dataSource = dataSOurceArray as? [RoleNameId] {
            let role = dataSource[indexPath.row]
            cell.textLabel?.text = role.key ?? ""
            cell.accessoryType = dataSource[indexPath.row].isSelected ? .checkmark : .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dataSource = dataSOurceArray as? [SelectCollegeClass]{
            dataSource[indexPath.row].isSelected = !dataSource[indexPath.row].isSelected
        }
        if let dataSource = dataSOurceArray as? [UserControl]{
            dataSource[indexPath.row].isSelected.toggle()
        }
        if let dataSource = dataSOurceArray as? [RoleNameId] {
            dataSource[indexPath.row].isSelected.toggle()
        }
        
        self.tableviewClassList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let dataSource = dataSOurceArray as? [SelectCollegeClass]{
            dataSource[indexPath.row].isSelected = !dataSource[indexPath.row].isSelected
        }
        if let dataSource = dataSOurceArray as? [UserControl]{
            dataSource[indexPath.row].isSelected.toggle()
        }
        if let dataSource = dataSOurceArray as? [RoleNameId] {
            dataSource[indexPath.row].isSelected.toggle()
        }

        self.tableviewClassList.reloadData()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewClassSelection", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
