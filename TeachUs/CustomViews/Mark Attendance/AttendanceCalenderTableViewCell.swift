//
//  AttendanceCalenderTableViewCell.swift
//  TeachUs
//
//  Created by ios on 11/6/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AttendanceCalenderTableViewCellDelegate {
    func showSubmit()
    func hideSubmit()
    func numberOfLecturesSelected(lectures:Int)
}

class AttendanceCalenderTableViewCell: UITableViewCell {
    @IBOutlet weak var viewFromTImeBg: UIView!
    @IBOutlet weak var textFieldFromTime: UITextField!
    @IBOutlet weak var buttonFromTime: UIButton!
    
    @IBOutlet weak var viewToTimeBg: UIView!
    @IBOutlet weak var textFieldToTime: UITextField!
    @IBOutlet weak var buttonToTime: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet var buttonArrayNumberOfLectures: [UIButton]!
    
    
    let disposeBag = DisposeBag()
    var delegate:AttendanceCalenderTableViewCellDelegate!
    
    var numberOflecturesTaken:Int!{
        didSet{
            for (index,button) in self.buttonArrayNumberOfLectures.enumerated(){
                if index == numberOflecturesTaken-1{//FF94BA
                    button.backgroundColor = UIColor.rgbColor(255, 255, 255)
                    button.setTitleColor(UIColor.black, for: .normal)

                }else{
                    button.setTitleColor(UIColor.white, for: .normal)
                    button.backgroundColor = UIColor.rgbColor(255, 148, 186)
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewToTimeBg.addWhiteBottomBorder()
        self.viewFromTImeBg.addWhiteBottomBorder()
        self.makeTableCellEdgesRounded()
        self.buttonEdit.dropShadow()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    var attendanceDate = Variable<String>("")
    var attendanceFromTime = Variable<String>("")
    var attendanceToTime = Variable<String>("")
    
    /*
    var isCalenderDataValid:Observable<Bool>{
        return Observable.combineLatest(attendanceDate.asObservable(), attendanceToTime.asObservable(), attendanceFromTime.asObservable(), numberOfLectures.asObservable()){ date, toTime, fromTime, numberOfLecs in
            date.characters.count > 0 && toTime.characters.count > 0 && fromTime.characters.count > 0 && numberOfLecs.characters.count > 0
        }
    }*/
    
    var isCalenderDataValid:Observable<Bool>{
        return Observable.combineLatest(attendanceToTime.asObservable(), attendanceFromTime.asObservable()){toTime, fromTime in
            toTime.count > 0 && fromTime.count > 0 && self.numberOflecturesTaken > 0
        }
    }

    @IBAction func didSelectNumberOfLectures(_ sender: Any) {
        if let senderButton = sender as? UIButton, let count = Int(senderButton.titleLabel?.text ?? "1") {
            self.delegate.numberOfLecturesSelected(lectures: count)
        }
    }
    
    func setUpRx(){
        self.textFieldToTime.rx.text.map{ $0 ?? ""}.bind(to: attendanceToTime).disposed(by: disposeBag)
        self.textFieldFromTime.rx.text.map{$0 ?? ""}.bind(to: attendanceFromTime).disposed(by: disposeBag)
        
        isCalenderDataValid.asObservable().subscribe(onNext: { (isVaild) in
            if(isVaild){
                self.delegate.showSubmit()
            }
            else{
                self.delegate.hideSubmit()
            }
        }).disposed(by: disposeBag)
    }
}
