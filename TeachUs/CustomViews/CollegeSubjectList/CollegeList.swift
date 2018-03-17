//
//  CollegeList.swift
//  TeachUs
//
//  Created by ios on 11/5/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

protocol CollegeListDelegate {
    func selectedSubject(_ collegeSubject:College)
}

class CollegeList: UIView {

    @IBOutlet weak var tableviewCollegeList: UITableView!
    let nibCollegeListCell = "ProfessorCollegeListTableViewCell"
    var arrayDataSource : [College] = []
    var delegate:CollegeListDelegate!
    
    func showView(_ inView:UIView){
        self.alpha = 0.0
        self.frame.size.width = inView.width()
        self.frame.size.height = inView.height()
        self.frame.origin.y = 0
        self.tableviewCollegeList.backgroundColor = UIColor.clear
        inView.addSubview(self)
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }, completion: nil)
        
    }
    
    func reloadAllData(){
        self.tableviewCollegeList.reloadData()
    }
    
    func setUpTableView(_ dataSource:[College]){
        self.arrayDataSource.removeAll()
        self.arrayDataSource = dataSource
        let cellNib = UINib(nibName:nibCollegeListCell, bundle: nil)
        self.tableviewCollegeList.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.ProfessorCollegeList)

        self.tableviewCollegeList.delegate = self
        self.tableviewCollegeList.dataSource = self
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if(cell == nil){
            let collegeCell:ProfessorCollegeListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.ProfessorCollegeList, for: indexPath) as! ProfessorCollegeListTableViewCell
            
            collegeCell.labelSubjectName.text = self.arrayDataSource[indexPath.section].subjectName
            collegeCell.selectionStyle = UITableViewCellSelectionStyle.none
            cell = collegeCell
        }
        return cell
    }

    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //Need to create a label with the text we want in order to figure out height
        let label: UILabel = createHeaderLabel(section)
        let size = label.sizeThatFits(CGSize(width: self.width(), height: CGFloat.greatestFiniteMagnitude))
        let padding: CGFloat = 20.0
        return size.height + padding
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        bgView.backgroundColor = UIColor.rgbColor(52, 40, 70)
        headerView.backgroundView = bgView
        let label = createHeaderLabel(section)
        label.autoresizingMask = [.flexibleHeight]
//        label.backgroundColor = UIColor.rgbColor(52, 40, 70)
//        headerView.backgroundColor = UIColor.rgbColor(52, 40, 70)

        headerView.addSubview(label)

        return headerView
    }
    
    func createHeaderLabel(_ section: Int)->UILabel {
        let widthPadding: CGFloat = 15.0
        let label: UILabel = UILabel(frame: CGRect(x: widthPadding, y: 0, width: self.width() - widthPadding, height: 0))
        label.text = self.arrayDataSource[section].name// Your text here
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignment.left
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = UIColor.white
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline) //use your own font here - this font is for accessibility
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(delegate != nil){
            delegate.selectedSubject(self.arrayDataSource[indexPath.section])
        }
    }
}
