//
//  CollegeList.swift
//  TeachUs
//
//  Created by ios on 11/5/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class CollegeList: UIView {

    @IBOutlet weak var tableviewCollegeList: UITableView!
    let nibCollegeListCell = "ProfessorCollegeListTableViewCell"
    var arrayDataSource : [College] = []
    
    func showView(_ inView:UIView){
        self.alpha = 0.0
        self.frame.size.width = inView.width()
        self.frame.size.height = inView.height() - CGFloat(Constants.NumberConstants.homeTabBarHeight)
        self.frame.origin.y = 0
        inView.addSubview(self)
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }, completion: nil)
        
    }
    
    func setUpTableView(_ dataSource:[College]){
        self.arrayDataSource = dataSource
        let cellNib = UINib(nibName:nibCollegeListCell, bundle: nil)
        self.tableviewCollegeList.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.ProfessorCollegeList)

        self.tableviewCollegeList.delegate = self
        self.tableviewCollegeList.dataSource = self
        self.tableviewCollegeList.reloadData()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CollegeList", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }


}

extension CollegeList:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource[section].collegeSubjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if(cell == nil){
            let collegeCell:ProfessorCollegeListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.ProfessorCollegeList, for: indexPath) as! ProfessorCollegeListTableViewCell
            
            collegeCell.labelSubjectName.text = self.arrayDataSource[indexPath.section].collegeSubjects[indexPath.row].subjectName
            collegeCell.selectionStyle = UITableViewCellSelectionStyle.none
            cell = collegeCell
        }
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.arrayDataSource[section].name
    }
    */
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.sectionHeaderHeight))
        
        let labelTitle = UILabel(frame: CGRect(x: 15.0, y: headerView.height()/2, width: headerView.width(), height: 20))
        labelTitle.textAlignment = .left
        labelTitle.textColor = UIColor.white
        labelTitle.text = self.arrayDataSource[section].name
        labelTitle.font = UIFont.systemFont(ofSize: 14.0)
        headerView.addSubview(labelTitle)
        
        headerView.backgroundColor = UIColor.rgbColor(52, 40, 70)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44.0
    }
    
}
