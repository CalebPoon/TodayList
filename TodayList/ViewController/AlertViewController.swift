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
    var deleteAlertButton: AddedTouchAreaButton!
    var datePicker: UIDatePicker!
    
    // MARK: Time
    var toSetDate: Date!
    var toSetAlert: Date?
    var AlertType: Int?
    
    var morning: Date!
    var afternoon: Date!
    var evening: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set Time
        setTime()
        
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
        toSetAlert = morning
        AlertType = 1
        unwindAnimation()
    }
    
    
    @IBAction func afternoonButtonClicked(_ sender: Any) {
        toSetAlert = afternoon
        AlertType = 2
        unwindAnimation()
    }
    
    @IBAction func eveningButtonClicked(_ sender: Any) {
        toSetAlert = evening
        AlertType = 3
        unwindAnimation()
    }
    
    @IBAction func otherTimeButtonClicked(_ sender: Any) {
        newLayout()
    }
    
    
    func unwindAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            let frame = self.PopView.frame
            self.PopView.frame = CGRect(x: 0, y: self.view.frame.height, width: frame.width, height: frame.height)
            self.performSegue(withIdentifier: "alertButtonUnwind", sender: self)
        }, completion: nil)
    }
    
    // MARK: - Setup View
    private func setupView() {
        // PopView
        PopView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 174 + 4)
        PopView.backgroundColor = customColor.popViewBackground
        setupCornerRadius()
        
        // Title
        PopViewTitle.textColor = customColor.Black1
        PopViewTitle.sizeToFit()
        PopViewTitle.frame = CGRect(x: 16, y: 24, width: PopViewTitle.frame.width, height: PopViewTitle.frame.height)
        
        // morningButton
        morningButton.setImage(#imageLiteral(resourceName: "morning"), for: .normal)
        morningButton.tintColor = customColor.Orange_alert
        morningButton.frame =  CGRect(x: 16, y: 64 + 4, width: 50, height: 50)
        morningButton.addedTouchArea = 40
        addLabel(type: 1)
        if Date() > morning {
            morningButton.isEnabled = false
        }
        
        // afternoonButton
        afternoonButton.setImage(#imageLiteral(resourceName: "afternoon"), for: .normal)
        afternoonButton.tintColor = customColor.Orange_alert
        afternoonButton.frame =  CGRect(x: 16 + 50 + 32, y: 64 + 4, width: 50, height: 50)
        afternoonButton.addedTouchArea = 40
        addLabel(type: 2)
        if Date() > afternoon {
            afternoonButton.isEnabled = false
        }
        
        // eveningButton
        eveningButton.setImage(#imageLiteral(resourceName: "Evening"), for: .normal)
        eveningButton.tintColor = customColor.Orange_alert
        eveningButton.frame =  CGRect(x: 16 + (50 + 32) * 2, y: 64 + 4, width: 50, height: 50)
        eveningButton.addedTouchArea = 40
        addLabel(type: 3)
        if Date() > evening {
            eveningButton.isEnabled = false
        }
        
        
        // otherTimeButton
        otherTimeButton.setImage(#imageLiteral(resourceName: "moreTime"), for: .normal)
        otherTimeButton.frame = CGRect(x: self.view.frame.width - 25 - 50, y: 64 + 4, width: 50, height: 50)
        otherTimeButton.tintColor = customColor.Blue_Background
        let moreLabel = UILabel()
        moreLabel.text = "其他时间"
        moreLabel.textColor = customColor.Blue_Background
        moreLabel.font = UIFont.systemFont(ofSize: 16)
        moreLabel.sizeToFit()
        moreLabel.center = CGPoint(x: otherTimeButton.center.x, y: otherTimeButton.center.y + otherTimeButton.frame.height/2 + 10 + moreLabel.frame.height/2)
        PopView.addSubview(moreLabel)
        otherTimeButton.addedTouchArea = 40
        
        addDeleteAlertButton()
        if toSetAlert != nil {
            deleteAlertButton.isHidden = false
        }
    }
    
    // Add different types of labels depending on buttons' type
    private func addLabel(type: Int) {
        var dayText: String
        var timeText: String
        var button: AddedTouchAreaButton
        var color = customColor.Orange_alert
        let unableColor = hexStringToUIColor(hex: "#F0EFEE")
        //var date: Date
        if type == 1 {
            dayText = "上午"
            timeText = "09:00"
            button = self.morningButton
            if Date() > morning {
                color = unableColor
            }
        } else if type == 2 {
            dayText = "下午"
            timeText = "14:00"
            button = self.afternoonButton
            if Date() > afternoon {
                color = unableColor
            }
        } else {
            dayText = "晚上"
            timeText = "20:00"
            button = self.eveningButton
            if Date() > evening {
                color = unableColor
            }
        }
        
        let DayLabel = UILabel()
        let TimeLabel = UILabel()
        
        DayLabel.text = dayText
        DayLabel.textColor = color
        DayLabel.font = UIFont.systemFont(ofSize: 16)
        
        TimeLabel.text = timeText
        TimeLabel.textColor = color
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
            self.PopView.frame = CGRect(x: 0, y: self.view.frame.height - 174 - 4, width: self.view.frame.width, height: 174 + 4)
        }, completion: nil)
    }
    
    // Set three different Alert on the 'toSetDate'
    func setTime() {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: toSetDate)
        
        var alertTimeComponents = DateComponents()
        alertTimeComponents.year = dateComponents.year
        alertTimeComponents.month = dateComponents.month
        alertTimeComponents.day = dateComponents.day
        alertTimeComponents.timeZone = TimeZone(abbreviation: "GMT+8")
        
        // morning
        alertTimeComponents.hour = 9
        alertTimeComponents.minute = 0
        alertTimeComponents.second = 0
        morning = calendar.date(from: alertTimeComponents)
        
        // afternoon
        alertTimeComponents.hour = 14
        afternoon = calendar.date(from: alertTimeComponents)
        
        // evening
        alertTimeComponents.hour = 20
        evening = calendar.date(from: alertTimeComponents)
    }
    
    // Mark: - Other Time Setting Methods
    func newLayout() {
        self.deleteAlertButton.isHidden = true
        self.addAlertConfirmButton()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.PopView.frame = CGRect(x: 0, y: self.view.frame.height - 245, width: self.PopView.frame.width, height: 245)
            self.setupCornerRadius()
            self.addMaskView()
            
        }) { (_: Bool) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alertConfirmButton.alpha = 1
                self.addDatePicker()
            })
            
        }
    }
    
    func addDatePicker() {
        // Create a datePicker
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: self.PopView.frame.height - 175 - 16, width: self.PopView.frame.width, height: 175))
        
        datePicker.backgroundColor = customColor.popViewBackground
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.timeZone = TimeZone(abbreviation: "GMT+8")
        datePicker.datePickerMode = .time
        datePicker.minimumDate = Date()
        
        if let setAlert = toSetAlert {
            print(setAlert)
            datePicker.date = setAlert
        } else {
            datePicker.date = Date()
        }
        
        self.PopView.addSubview(datePicker)
        self.PopView.bringSubview(toFront: datePicker)
    }
    
    func addMaskView() {
        let maskView = UIView(frame: CGRect(x: 0, y: self.PopView.frame.height - 175 - 16, width: self.PopView.frame.width, height: 175))
        maskView.backgroundColor =  customColor.popViewBackground
        self.PopView.addSubview(maskView)
        self.PopView.bringSubview(toFront: maskView)
    }
    
    func addAlertConfirmButton() {
        // AlertConfirrmButton
        alertConfirmButton = AddedTouchAreaButton(type: .system)
        
        alertConfirmButton.setImage(#imageLiteral(resourceName: "confirm"), for: .normal)
        alertConfirmButton.tintColor = customColor.Blue_Background
        //alertConfirmButton.setTitle("", for: .normal)
        //alertConfirmButton.setTitleColor(customColor.Blue_Background, for: .normal)
        alertConfirmButton.sizeToFit()

        alertConfirmButton.addedTouchArea = 4
        //alertConfirmButton.alpha = 0
        
        alertConfirmButton.frame = CGRect(x: self.PopView.frame.width - alertConfirmButton.frame.width - 16, y: 24, width: alertConfirmButton.frame.width, height: 32)
        
        alertConfirmButton.addTarget(self, action: #selector(AlertViewController.alertConfirmButtonClicked(_:)) , for: .touchUpInside)
        
        self.PopView.addSubview(alertConfirmButton)
    }
    
    func addDeleteAlertButton() {
        // DeleteAlertButton
        deleteAlertButton = AddedTouchAreaButton(type: .system)
        
        deleteAlertButton.setImage(#imageLiteral(resourceName: "deleteAlert"), for: .normal)
        deleteAlertButton.tintColor = customColor.Red_delete
        deleteAlertButton.setTitle("删除", for: .normal)
        deleteAlertButton.setTitleColor(customColor.Red_delete, for: .normal)
        deleteAlertButton.sizeToFit()
        
        deleteAlertButton.addedTouchArea = 4
        deleteAlertButton.isHidden = true
        
        deleteAlertButton.frame = CGRect(x: otherTimeButton.center.x - deleteAlertButton.frame.width/2, y: PopViewTitle.center.y - deleteAlertButton.frame.height/2, width: deleteAlertButton.frame.width, height: 32)
        
        deleteAlertButton.addTarget(self, action: #selector(AlertViewController.deleteAlertButtonClicked(_:)), for: .touchUpInside)
        
        self.PopView.addSubview(deleteAlertButton)

    }
    
    @objc func alertConfirmButtonClicked(_ sender: AddedTouchAreaButton) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: toSetDate)
        let datePickerComponents = calendar.dateComponents([.hour, .minute], from: datePicker.date)
        
        var alertTimeComponents = DateComponents()
        alertTimeComponents.year = dateComponents.year
        alertTimeComponents.month = dateComponents.month
        alertTimeComponents.day = dateComponents.day

        // get components form datePicker
        alertTimeComponents.hour = datePickerComponents.hour
        alertTimeComponents.minute = datePickerComponents.minute
        alertTimeComponents.timeZone = TimeZone(abbreviation: "GMT+8")
        
        toSetAlert = calendar.date(from: alertTimeComponents)
        print("otherTimeAlert: \(toSetAlert)")
        AlertType = 4
        unwindAnimation()
    }
    
    @objc func deleteAlertButtonClicked(_ sender: AddedTouchAreaButton) {
        toSetAlert = nil
        unwindAnimation()
    }
}
