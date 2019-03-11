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
    var delegate : ViewClassSelectionDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableviewClassList.delegate = self
        self.tableviewClassList.dataSource = self
        self.buttonSelectAll.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: nil, borderWidth: nil)

    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.delegate.classViewDismissed()
    }
    
    @IBAction func selectAllClasses(_ sender: Any) {
        self.buttonSelectAll.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        self.buttonDeselectAll.makeButtonwith(background: .white, fontColor: .black, cornerRadius: nil, borderColor: nil, borderWidth: nil)


        CollegeClassManager.sharedManager.selectedClassArray = CollegeClassManager.sharedManager.selectedClassArray.map({classSelected in
            classSelected.isSelected = true
            return classSelected
        })
        self.tableviewClassList.reloadData()
    }
    
    @IBAction func deselectAllClasses(_ sender: Any) {
        self.buttonDeselectAll.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        self.buttonSelectAll.makeButtonwith(background: .white, fontColor: .black, cornerRadius: nil, borderColor: nil, borderWidth: nil)

        CollegeClassManager.sharedManager.selectedClassArray = CollegeClassManager.sharedManager.selectedClassArray.map({classSelected in
            classSelected.isSelected = false
            return classSelected
        })
        self.tableviewClassList.reloadData()
    }
    
}

extension ViewClassSelection:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CollegeClassManager.sharedManager.selectedClassArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            return cell
        }()
        
        cell.textLabel?.text = "\(CollegeClassManager.sharedManager.selectedClassArray[indexPath.row].collegeClass?.courseName ?? "") - \(CollegeClassManager.sharedManager.selectedClassArray[indexPath.row].collegeClass?.classDivision ?? "")"
        
        cell.accessoryType = CollegeClassManager.sharedManager.selectedClassArray[indexPath.row].isSelected ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CollegeClassManager.sharedManager.selectedClassArray[indexPath.row].isSelected = !CollegeClassManager.sharedManager.selectedClassArray[indexPath.row].isSelected
        self.tableviewClassList.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        CollegeClassManager.sharedManager.selectedClassArray[indexPath.row].isSelected = !CollegeClassManager.sharedManager.selectedClassArray[indexPath.row].isSelected
        self.tableviewClassList.reloadData()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewClassSelection", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
