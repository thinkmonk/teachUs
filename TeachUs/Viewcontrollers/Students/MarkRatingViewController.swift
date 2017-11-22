//
//  MarkRatingViewController.swift
//  TeachUs
//
//  Created by ios on 11/23/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class MarkRatingViewController: BaseViewController {

    var arrayDataSource:[RatingDetails] = []
    var professsorDetails:ProfessorDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(professsorDetails.professorName!)
        print(arrayDataSource.count)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addGradientToNavBar()
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
