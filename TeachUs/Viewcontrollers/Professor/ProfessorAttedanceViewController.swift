//
//  ProfessorAttedanceViewController.swift
//  TeachUs
//
//  Created by ios on 11/2/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

class ProfessorAttedanceViewController: BaseViewController {

    var parentNavigationController : UINavigationController?
    var arrayCollegeList:[College]? = []
//    var viewCollegeList:CollegeList!
    
    @IBOutlet weak var tableviewCollegeList: UITableView!
    let nibCollegeListCell = "ProfessorCollegeListTableViewCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfessorAttedanceViewController")
        self.view.backgroundColor = UIColor.clear
    
        tableviewCollegeList.delegate = self
        tableviewCollegeList.dataSource = self
        let cellNib = UINib(nibName:nibCollegeListCell, bundle: nil)
        self.tableviewCollegeList.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.ProfessorCollegeList)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCollegeSummaryForProfessor()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getCollegeSummaryForProfessor(){
        self.tableviewCollegeList.alpha = 0
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getClassList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        
        manager.apiPost(apiName: " Get Professor Class list", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            self.arrayCollegeList?.removeAll()
            guard let colleges = response["class_list"] as? [[String:Any]] else{
                return
            }
            for college in colleges{
                let tempCollege = Mapper<College>().map(JSONObject: college)
                self.arrayCollegeList?.append(tempCollege!)
            }
            UIView.animate(withDuration: 1.0, animations: {
                self.tableviewCollegeList.alpha = 1
            })
            self.tableviewCollegeList.reloadData()

            
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }


    }
    func selectedSubject(_ subject: College) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let destinationVC:StudentsListViewController =  storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.studentList) as! StudentsListViewController
        // destinationVC.subject = subject
        
        //self.parentNavigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension ProfessorAttedanceViewController:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayCollegeList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if(cell == nil){
            let collegeCell:ProfessorCollegeListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.ProfessorCollegeList, for: indexPath) as! ProfessorCollegeListTableViewCell
            
            collegeCell.labelSubjectName.text = self.arrayCollegeList![indexPath.row].subjectName
            collegeCell.selectionStyle = UITableViewCellSelectionStyle.none
            cell = collegeCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    /*
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //Need to create a label with the text we want in order to figure out height
        let label: UILabel = createHeaderLabel(section)
        let size = label.sizeThatFits(CGSize(width: tableView.width(), height: CGFloat.greatestFiniteMagnitude))
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
        let label: UILabel = UILabel(frame: CGRect(x: widthPadding, y: 0, width: tableviewCollegeList.width() - widthPadding, height: 0))
        label.text = self.arrayCollegeList![].name// Your text here
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignment.left
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = UIColor.white
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline) //use your own font here - this font is for accessibility
        return label
    }
 */
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedSubject(self.arrayCollegeList![indexPath.row])
    }
}
