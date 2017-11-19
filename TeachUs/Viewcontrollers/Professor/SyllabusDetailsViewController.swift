//
//  SyllabusDetailsViewController.swift
//  TeachUs
//
//  Created by ios on 11/19/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class SyllabusDetailsViewController: BaseViewController {
    @IBOutlet weak var labelCompletionStatus: UILabel!
    @IBOutlet weak var tableSyllabusDetails: UITableView!
    var arrayDataSource:[Topic] = []
    var completionStatus:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableSyllabusDetails.register(UINib(nibName: "SyllabusDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.SyllabusDetailsTableViewCellId)
        self.tableSyllabusDetails.delegate = self
        self.tableSyllabusDetails.dataSource = self
        self.labelCompletionStatus.text = "Completion: \(self.completionStatus)"
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addGradientToNavBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SyllabusDetailsViewController:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrayDataSource[section].chapters?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SyllabusDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.SyllabusDetailsTableViewCellId, for: indexPath) as! SyllabusDetailsTableViewCell
        let chapter = self.arrayDataSource[indexPath.section].chapters![indexPath.row]
        cell.labelChapterDetails.text = chapter.chapterName
        cell.labelChapterNumber.text = chapter.chapterNumber
        switch chapter.status {
        case "PROGRESS"?:
            cell.imageViewStatus.image = UIImage(named: Constants.Images.syllabusInProgress)
            break
        case "COMPLETE"?:
            cell.imageViewStatus.image = UIImage(named: Constants.Images.syllabusCompleted)
            break
        case "NOTSTARTED"?:
            cell.imageViewStatus.image = UIImage(named: Constants.Images.syllabusNotStarted)
            break
        default:
            cell.imageViewStatus.image =  UIImage(named: Constants.Images.syllabusNotStarted)
            break
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == ((self.arrayDataSource[indexPath.section].chapters?.count)! - 1)){
            cell.makeBottomEdgesRounded()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableSyllabusDetails.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableSyllabusDetails.width(), height: 30.0))
        headerView.backgroundColor = UIColor.white
        headerView.makeTopEdgesRounded()
        
        let label:UILabel = UILabel(frame: CGRect(x: 15.0, y: 0.0, width: headerView.width(), height: 15))
        label.center.y = headerView.centerY()
        label.text = self.arrayDataSource[section].unitName!
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        headerView.addSubview(label)
        
        return headerView
    }

}
