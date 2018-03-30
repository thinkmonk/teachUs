//
//  CollegeSyllabusStatusViewController.swift
//  TeachUs
//
//  Created by ios on 3/18/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CollegeSyllabusStatusViewController: BaseViewController {
    var parentNavigationController : UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("CollegeSyllabusStatusViewController")
        self.addGradientToNavBar()
        // Do any additional setup after loading the view.
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CollegeSyllabusStatusViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Syllabus")
    }
}

