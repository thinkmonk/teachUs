//
//  LogsDetailViewController.swift
//  TeachUs
//
//  Created by ios on 11/30/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class LogDetailSyllabus {
    var unitName:String = ""
    var unitNumber:String = ""
    var chapter:Chapter!
}


class LogsDetailViewController: BaseViewController {

    var logs:ProfessorLogs!
    var arrayDataSource:[ProfessorLogsDataSource]! = []
    
    
    @IBOutlet weak var tableLogsDetail: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableLogsDetail.backgroundColor = UIColor.clear
        self.makeDataSource()
        self.tableLogsDetail.delegate = self
        self.tableLogsDetail.dataSource = self
        self.tableLogsDetail.separatorStyle = .none
//        self.tableLogsDetail.alpha = 0
        self.tableLogsDetail.register(UINib(nibName: "LogsDetailTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.LogsDetailTableViewCellId)
        self.tableLogsDetail.register(UINib(nibName: "SyllabusDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.SyllabusDetailsTableViewCellId)

        
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
    
    func makeDataSource(){
        arrayDataSource.removeAll()
        
        let detailsDataSource = ProfessorLogsDataSource(celType: .LogDetails, attachedObject: nil)
        self.arrayDataSource.append(detailsDataSource)
        
        for topic in logs.topics{
            for chapter in topic.chapters!{
                let attachedSyllabus = LogDetailSyllabus()
                attachedSyllabus.unitName = topic.unitName!
                attachedSyllabus.unitNumber = topic.unitNumber!
                attachedSyllabus.chapter = chapter
                let syllabusDatasource = ProfessorLogsDataSource(celType: .SyllabusDetail, attachedObject: attachedSyllabus)
                self.arrayDataSource.append(syllabusDatasource)
            }
        }
//        self.showTableView()
        self.tableLogsDetail.reloadData()
    }
    
    func showTableView(){
        self.tableLogsDetail.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableLogsDetail.alpha = 1.0
            self.tableLogsDetail.transform = CGAffineTransform.identity
        }
    }
}

extension LogsDetailViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDataSource = arrayDataSource[indexPath.row]
        switch cellDataSource.logsCellType! {
        case .LogDetails:
            let cell:LogsDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.LogsDetailTableViewCellId, for: indexPath) as! LogsDetailTableViewCell
            cell.labelNumberOfLecs.text = "\(logs.noOfLecture!)"
            cell.labelAttendanceCount.text = "\(logs.totalAttendance!)"
            cell.labelLectureTime.text = "\(logs.fromTime) to \(logs.toTime)"
            cell.viewTimeOfSubject.alpha = 0
            let datstring = logs.dateTime.getDateFromString()
            cell.labelDate.text = "\(datstring)"
            cell.selectionStyle = .none
            return cell
            
            
        case .SyllabusDetail:
            let cell:SyllabusDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.SyllabusDetailsTableViewCellId, for: indexPath) as! SyllabusDetailsTableViewCell
            let chapterAttached:LogDetailSyllabus = cellDataSource.attachedObject as! LogDetailSyllabus
            cell.imageViewStatus.alpha = 0
            cell.labelChapterNumber.text = "\(chapterAttached.unitNumber) : \(chapterAttached.unitName)"
            cell.labelChapterDetails.text = "\(chapterAttached.chapter.chapterName!)"
            cell.viewSeperator.alpha = 0
            cell.selectionStyle = .none
            return cell
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellDataSource = arrayDataSource[indexPath.row]
        switch cellDataSource.logsCellType! {
        case .LogDetails:
            return 150
        case .SyllabusDetail:
            return 80
        }
    }
}
