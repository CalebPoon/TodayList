//
//  DateViewController.swift
//  TodayList
//
//  Created by hula3 on 2018/3/14.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var PopView: UIView!
    
    @IBOutlet weak var selectDate: UILabel!
    
    @IBOutlet weak var todayButton: AddedTouchAreaButton!
    @IBOutlet weak var tomorrowButton: AddedTouchAreaButton!
    @IBOutlet weak var nextWeekButton: AddedTouchAreaButton!
    
    @IBOutlet weak var moreDateButton: AddedTouchAreaButton!
    
    
    var todayDate: Date!
    var tomorrowDate: Date!
    var nextWeekDate: Date!

    var toSetDate: Date!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // SetDate
        setDate()
        
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
        /*
        guard  let date = toSetDate else {
            return
        }*/
    }

    @IBAction func todayButtonClicked(_ sender: Any) {
        toSetDate = todayDate
       unwindAnimation()
    }
    
    @IBAction func tomorrowButtonClicked(_ sender: Any) {
        toSetDate = tomorrowDate
        unwindAnimation()
    }
    
    @IBAction func nextWeekButtonClicked(_ sender: Any) {
        toSetDate = nextWeekDate
        unwindAnimation()
    }
    
    @IBAction func moreDateButtonClicked(_ sender: Any) {
        newLayout()
    }
    
    
    
    func unwindAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            let frame = self.PopView.frame
            self.PopView.frame = CGRect(x: 0, y: self.view.frame.height, width: frame.width, height: frame.height)
        }) { (_: Bool) in
            self.performSegue(withIdentifier: "todayButtonUnwind", sender: self)
        }
    }
    
    // MARK: - Setup View
    private func setupView() {
        // PopView
        PopView.frame = CGRect(x: 0, y: self.view.frame.height - 74, width: self.view.frame.width, height: 174)
        PopView.backgroundColor = customColor.popViewBackground
        //PopView.alpha = 0
        setupCornerRadius()

        // Title
        selectDate.textColor = customColor.Black1
        selectDate.sizeToFit()
        selectDate.frame = CGRect(x: 16, y: 24, width: selectDate.frame.width, height: selectDate.frame.height)
        
        // TodayButton
        todayButton.setImage(#imageLiteral(resourceName: "today"), for: .normal)
        todayButton.frame = CGRect(x: 16, y: 64, width: 50, height: 50)
        todayButton.addedTouchArea = 40
        addLabel(type: 1)
        
        // TomorrowButton
        tomorrowButton.setImage(#imageLiteral(resourceName: "tomorrow"), for: .normal)
        tomorrowButton.frame = CGRect(x: 16 + 50 + 32, y: 64, width: 50, height: 50)
        tomorrowButton.addedTouchArea = 40
        addLabel(type: 2)
        
        // NextWeekButton
        nextWeekButton.setImage(#imageLiteral(resourceName: "nextWeek"), for: .normal)
        nextWeekButton.frame = CGRect(x: 16 + (50 + 32) * 2, y: 64, width: 50, height: 50)
        nextWeekButton.addedTouchArea = 40
        addLabel(type: 3)
        
        
        // MoreDateButton
        moreDateButton.setImage(#imageLiteral(resourceName: "moreDate"), for: .normal)
        moreDateButton.frame = CGRect(x: self.view.frame.width - 25 - 50, y: 64, width: 50, height: 50)
        let moreLabel = UILabel()
        moreLabel.text = "其他日期"
        moreLabel.textColor = customColor.Blue_Background
        moreLabel.font = UIFont.systemFont(ofSize: 16)
        moreLabel.sizeToFit()
        moreLabel.center = CGPoint(x: moreDateButton.center.x, y: moreDateButton.center.y + moreDateButton.frame.height/2 + 4 + moreLabel.frame.height/2)
        PopView.addSubview(moreLabel)
        moreDateButton.addedTouchArea = 40
    }
    
    
    // Add different types of labels depending on buttons' type
    private func addLabel(type: Int) {
        var text: String
        var button: AddedTouchAreaButton
        var date: Date
        if type == 1 {
            text = "今日"
            button = self.todayButton
            date = todayDate
        } else if type == 2 {
            text = "明日"
            button = self.tomorrowButton
            date = tomorrowDate
        } else {
            text = "下周"
            button = self.nextWeekButton
            date = nextWeekDate
        }
        
        let DateLabel = UILabel()
        let WeekLabel = UILabel()
        
        DateLabel.text = text
        DateLabel.textColor = customColor.Green_date
        DateLabel.font = UIFont.systemFont(ofSize: 16)
        
        WeekLabel.text = WeekdayString(date: date)
        WeekLabel.textColor = customColor.Green_date
        WeekLabel.font = UIFont.systemFont(ofSize: 10)
        
        DateLabel.sizeToFit()
        WeekLabel.sizeToFit()
        
        DateLabel.center = CGPoint(x: button.center.x, y: button.center.y + button.frame.height/2 + 4 + DateLabel.frame.height/2)
        WeekLabel.center = CGPoint(x: button.center.x, y: DateLabel.center.y + DateLabel.frame.height/2 + WeekLabel.frame.height/2)
        
        PopView.addSubview(DateLabel)
        PopView.addSubview(WeekLabel)
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
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut, animations: {
            self.PopView.frame = CGRect(x: 0, y: self.view.frame.height - 174, width: self.view.frame.width, height: 174)
            self.PopView.alpha = 1
        }, completion: nil)
    }
    
    // Get uppercased string of weekday
    func WeekdayString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let weekdayString = dateFormatter.string(from: date)
        
        let UppercasedString = weekdayString.uppercased()
        return UppercasedString
    }
    
    // Set todayDate, tomorrowDate and nextWeekDate
    private func setDate() {
        todayDate = Date()
        tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: todayDate)
        nextWeekDate = Calendar.current.date(byAdding: .day, value: 7, to: todayDate)
    }
    
    // MARK: - Other Day Setting Methods
    func newLayout() {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.PopView.frame = CGRect(x: 0, y: self.view.frame.height - 245, width: self.PopView.frame.width, height: 245)
            self.setupCornerRadius()
            self.addMaskView()
        }) { (_: Bool) in
            UIView.animate(withDuration: 0.1, animations: {
                self.addDatePicker()
            })
        }
    }
    
    func addDatePicker() {
        
        // Create a datePicker
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: self.PopView.frame.height - 165 - 16, width: self.PopView.frame.width, height: 165))
        
        datePicker.backgroundColor = customColor.popViewBackground
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.datePickerMode = .date
        
        datePicker.addTarget(self, action: #selector(DateViewController.getDateOfDatePicker(datePicker:)), for: .valueChanged)
        
        self.PopView.addSubview(datePicker)
        self.PopView.bringSubview(toFront: datePicker)
    }
    
    func addMaskView() {
        let maskView = UIView(frame: CGRect(x: 0, y: self.PopView.frame.height - 165 - 16, width: self.PopView.frame.width, height: 165))
        maskView.backgroundColor =  customColor.popViewBackground
        self.PopView.addSubview(maskView)
        self.PopView.bringSubview(toFront: maskView)
    }
    
    func addConfirmButton() {
        
    }
    
    @objc func getDateOfDatePicker(datePicker: UIDatePicker) {
        
    }
    
}
