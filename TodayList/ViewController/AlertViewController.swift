//
//  AlertViewController.swift
//  TodayList
//
//  Created by hula3 on 2018/3/17.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: UI
    
    @IBOutlet weak var PopView: UIView!
    @IBOutlet weak var PopViewTitle: UILabel!
    
    @IBOutlet weak var morningButton: AddedTouchAreaButton!
    @IBOutlet weak var afternoonButton: AddedTouchAreaButton!
    @IBOutlet weak var eveningButton: AddedTouchAreaButton!
    @IBOutlet weak var otherTimeButton: AddedTouchAreaButton!
    
    var alertConfirmButton: AddedTouchAreaButton!
    var datePicker: UIDatePicker!
    
    // MARK: Time
    var toSetDate: Date!
    
    var morning: Date!
    var afternoon: Date!
    var evening: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup View
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        segueAnmiation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    
    @IBAction func morningButtonClicked(_ sender: Any) {
    }
    
    
    @IBAction func afternoonButtonClicked(_ sender: Any) {
    }
    
    @IBAction func eveningButtonClicked(_ sender: Any) {
    }
    
    @IBAction func otherTimeButtonClicked(_ sender: Any) {
    }
    
    func unwindAnimation() {
        
    }
    
    // MARK: - Setup View
    private func setupView() {
        // PopView
        PopView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 174)
        PopView.backgroundColor = customColor.popViewBackground
        setupCornerRadius()
        
        // Title
        PopViewTitle.textColor = customColor.Black1
        PopViewTitle.sizeToFit()
        PopViewTitle.frame = CGRect(x: 16, y: 24, width: PopViewTitle.frame.width, height: PopViewTitle.frame.height)
        
        // morningButton
        morningButton.setImage(#imageLiteral(resourceName: "morning"), for: .normal)
        morningButton.tintColor = customColor.Orange_alert
        morningButton.frame =  CGRect(x: 16, y: 64, width: 50, height: 50)
        morningButton.addedTouchArea = 40
        addLabel(type: 1)
        
        // afternoonButton
        afternoonButton.setImage(#imageLiteral(resourceName: "afternoon"), for: .normal)
        afternoonButton.tintColor = customColor.Orange_alert
        afternoonButton.frame =  CGRect(x: 16 + 50 + 32, y: 64, width: 50, height: 50)
        afternoonButton.addedTouchArea = 40
        addLabel(type: 2)
        
        // eveningButton
        eveningButton.setImage(#imageLiteral(resourceName: "Evening"), for: .normal)
        eveningButton.tintColor = customColor.Orange_alert
        eveningButton.frame =  CGRect(x: 16 + (50 + 32) * 2, y: 64, width: 50, height: 50)
        eveningButton.addedTouchArea = 40
        addLabel(type: 3)
        
        
        // otherTimeButton
        otherTimeButton.setImage(#imageLiteral(resourceName: "moreTime"), for: .normal)
        otherTimeButton.frame = CGRect(x: self.view.frame.width - 25 - 50, y: 64, width: 50, height: 50)
        otherTimeButton.tintColor = customColor.Blue_Background
        let moreLabel = UILabel()
        moreLabel.text = "其他时间"
        moreLabel.textColor = customColor.Blue_Background
        moreLabel.font = UIFont.systemFont(ofSize: 16)
        moreLabel.sizeToFit()
        moreLabel.center = CGPoint(x: otherTimeButton.center.x, y: otherTimeButton.center.y + otherTimeButton.frame.height/2 + 4 + moreLabel.frame.height/2)
        PopView.addSubview(moreLabel)
        otherTimeButton.addedTouchArea = 40
    }
    
    // Add different types of labels depending on buttons' type
    private func addLabel(type: Int) {
        var dayText: String
        var timeText: String
        var button: AddedTouchAreaButton
        //var date: Date
        if type == 1 {
            dayText = "上午"
            timeText = "09:00"
            button = self.morningButton
            //date = todayDate
        } else if type == 2 {
            dayText = "下午"
            timeText = "14:00"
            button = self.afternoonButton
            //date = tomorrowDate
        } else {
            dayText = "晚上"
            timeText = "20:00"
            button = self.eveningButton
            //date = nextWeekDate
        }
        
        let DayLabel = UILabel()
        let TimeLabel = UILabel()
        
        DayLabel.text = dayText
        DayLabel.textColor = customColor.Orange_alert
        DayLabel.font = UIFont.systemFont(ofSize: 16)
        
        TimeLabel.text = timeText
        TimeLabel.textColor = customColor.Orange_alert
        TimeLabel.font = UIFont.systemFont(ofSize: 10)
        
        DayLabel.sizeToFit()
        TimeLabel.sizeToFit()
        
        DayLabel.center = CGPoint(x: button.center.x, y: button.center.y + button.frame.height/2 + 4 + DayLabel.frame.height/2)
        TimeLabel.center = CGPoint(x: button.center.x, y: DayLabel.center.y + DayLabel.frame.height/2 + TimeLabel.frame.height/2)
        
        PopView.addSubview(DayLabel)
        PopView.addSubview(TimeLabel)
    }
    
    // Setup CornerRadius
    private func setupCornerRadius() {
        // Set cornerRadius
        let maskPath: UIBezierPath
        maskPath = UIBezierPath(roundedRect: PopView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        
        PopView.layer.mask = maskLayer
    }
    
    // MARK: - Private Methods
    
    // Animation before view appears
    func segueAnmiation() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.PopView.frame = CGRect(x: 0, y: self.view.frame.height - 174, width: self.view.frame.width, height: 174)
        }, completion: nil)
    }
    
    
}
