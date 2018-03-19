//
//  EditViewController.swift
//  TodayList
//
//  Created by hula3 on 2018/3/19.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    // MARK: - Properties
    // MARK: UI
    @IBOutlet weak var returnButton: UIBarButtonItem!
    
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var TaskTitleTextView: UITextView!
    @IBOutlet weak var titleCell: UIView!

    @IBOutlet weak var remarkTextView: UITextView!
    @IBOutlet weak var remarkCell: UIView!
    
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var topicButton: UIButton!
    
    @IBOutlet weak var moreButton: UIButton!
    
    // MAKRK: Model
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    // MARK: - Set View
    func setView() {
        // View Background
        view.backgroundColor = customColor.globalBackground
        
        // ---------------
        // returnButton
        returnButton.image = #imageLiteral(resourceName: "return")
        returnButton.tintColor = customColor.Black3
        returnButton.title = ""
        
        // LargeTitle
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
        self.navigationController?.navigationBar.barTintColor = customColor.globalBackground
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        // ---------------
        // titleCell
        titleCell.frame = CGRect(x: 0, y: 16, width: self.view.frame.width, height: TaskTitleTextView.frame.height + 8)
        
        // checkbox
        checkbox.setImage(#imageLiteral(resourceName: "Checkmark_L"), for: .normal)
        checkbox.tintColor = customColor.Black3
        checkbox.frame = CGRect(x: 16, y: 11, width: 24, height: 24)
        
        // taskTitle
        TaskTitleTextView.text = task.title
        TaskTitleTextView.sizeToFit()
        TaskTitleTextView.frame = CGRect(x: 44, y: 4, width: self.view.frame.width - 16 - 44, height: TaskTitleTextView.frame.height)
        TaskTitleTextView.textColor = customColor.Black1

        
        // ----------------
        // remarkCell
        remarkCell.frame = CGRect(x: 0, y: 16 + titleCell.frame.height, width: self.view.frame.width, height: remarkTextView.frame.height + 20)
        
        // remarkTextView
        remarkTextView.frame = CGRect(x: 44, y: 10, width: self.view.frame.width - 16 - 44, height: 36)
        remarkTextView.textColor = customColor.Black2
        // **** TextView Placehold
        

        // ----------------
        // dateButton
        
        
    }

}

