//
//  AddTaskPopViewController.swift
//  TodayList
//
//  Created by hula3 on 2018/3/8.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit
import os.log

class AddTaskPopViewController: UIViewController, UITextViewDelegate {
    // MARK: - Properties
    
    // MARK: UI
    @IBOutlet weak var PopView: UIView!
    
    @IBOutlet weak var dismissArea: UIButton!
    
    @IBOutlet weak var TaskTitleTextView: UITextView!
    var placeholderLabel: UILabel!
    
    @IBOutlet weak var AddConFirm: AddedTouchAreaButton!

    @IBOutlet weak var DateButton: AddedTouchAreaButton!
    @IBOutlet weak var AlertButton: AddedTouchAreaButton!
    @IBOutlet weak var TopicButton: AddedTouchAreaButton!
    
    var PopViewHasUpdatedOnce = false
    
    // MARK: Model
    var setDate = Date()
    var setAlert: Date?
    var setTopic: String?
    
    var task: Task?
    
    // MARK: Content
    var editingTaskTitle: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keep draft
        if let text = editingTaskTitle {
            TaskTitleTextView.text = text
        }
        
        // Setup View
        SetupButtons()
        setupPopView()
        setupLineSpace()
        
        // Setup View
        setupTextView()
       
        // Update View
        NotificationCenter.default.addObserver(self, selector: #selector(AddTaskPopViewController.updateView(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddTaskPopViewController.updateView(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddTaskPopViewController.updateView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)

        // Update AddButton
        updateAddButtonState()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.PopView.frame = CGRect(x: 0, y: self.view.frame.height - 140, width: self.view.frame.width, height: 140)
            self.TaskTitleTextView.becomeFirstResponder()
        }) { (_: Bool) in

        }
        resizeTextView(height: TaskTitleTextView.contentSize.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TextView Delegate Methods
    
    func textViewDidChange(_  TaskTitleTextView: UITextView) {
        placeholderLabel.isHidden = !TaskTitleTextView.text.isEmpty

        resizeTextView(height: TaskTitleTextView.contentSize.height)
        
        // Line Space
        //setupLineSpace()
        
        updateAddButtonState()
    }
    

    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            //textView.resignFirstResponder()
            AddConfrim(AddConFirm)
        }
        return true
    }


    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "unwindToTodayList":
            let title = TaskTitleTextView.text ?? ""
            
            // Set the task to be passed to TodayListViewController after the unwind segue.
            task = Task(title: title, isChecked: false, date: setDate, alert: nil, topic: nil, remark: nil)
            
            // Set alert
            if let alert = setAlert {
                task?.alert = alert
            }
            
            // Set Topic
            if let topic = setTopic {
                task?.topic = topic
            }
            
            // Delete Draft
            editingTaskTitle = ""
        
        case "dismissToTodayList":
            if let text = TaskTitleTextView.text {
                editingTaskTitle = text
            }
            
            print("dismissToTodayList")
            
        case "SetDateSegue":
            print("SetDateSegue")
            guard let dateViewController = segue.destination as? DateViewController else {
                fatalError("Unexpected Segue Identifier; \(segue.identifier!)")
            }
            
            dateViewController.toSetDate = setDate
            
        case "setAlertSegue":
            print("setAlertSegue")
            
            // Set the date to be passed to AlertViewController after the segue.
            guard let alertViewController = segue.destination as? AlertViewController else {
                fatalError("Unexpected Segue Identifier; \(segue.identifier!)")
            }
            
            alertViewController.toSetDate = setDate
            
            if let AlertHasSet = setAlert {
                alertViewController.toSetAlert = AlertHasSet
            }
            
            
        case "setTopicSegue":
            print("setTopicSegue")
            guard let topicViewController = segue.destination as? TopicViewController else {
                fatalError("Unexpected Segue Identifier; \(segue.identifier!)")
            }
            topicViewController.toSetTopic = setTopic
            
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier!)")
        }

        
        // Set the Date to be passed to AlertViewController after the segue.
        
    }
    
    
    @IBAction func AddConfrim(_ sender: Any) {
        let TextViewFrame = self.TaskTitleTextView.frame
        self.TaskTitleTextView.frame = CGRect(x: TextViewFrame.origin.x, y: 8, width: TextViewFrame.width, height: 38)
        
        self.AddConFirm.alpha = 0
        self.DateButton.alpha = 0
        self.DateButton.alpha = 0

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            let Popframe = self.PopView.frame
            self.PopView.frame = CGRect(x: 0, y: self.view.frame.height/2 - Popframe.height/2, width: Popframe.width, height: 56)
            
            self.PopView.alpha = 0.8
            
            // CornerRadius
            self.setupCornerRadius(corner: 4, sender: self.PopView)
            
            // Shadow
            //self.PopView.dropShadow(offSet: CGSize(width: 0, height: 0))
            
            self.TaskTitleTextView.resignFirstResponder()
            self.PopView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            
        }, completion: {(_ :Bool) in
            
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                self.PopView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.PopView.alpha = 0
            }, completion: {(_: Bool) in
                
                self.performSegue(withIdentifier: "unwindToTodayList", sender: self)
            })
        })
    }
    
    // Dismiss
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.TaskTitleTextView.resignFirstResponder()
        self.performSegue(withIdentifier: "dismissToTodayList", sender: self)
    }*/
    
    @IBAction func dismissArea(_ sender: Any) {
        self.TaskTitleTextView.resignFirstResponder()
        self.performSegue(withIdentifier: "dismissToTodayList", sender: self)
    }
    
    
    // Unwind from DateViewController
    @IBAction func unwindToAddTaskPopViewWithTodayButton(sender: UIStoryboardSegue) {
        //Animation
        animationOfUnwindFromSettingTaskViews()
        
        // Set Model's date and UI
        if let sourceViewController = sender.source as? DateViewController ,let toSetDate = sourceViewController.toSetDate {
            
            if !compareDate(date1: setDate, date2: toSetDate) {
                setDate = toSetDate
                
                // Determine the date
                let todayDate = Date()
                let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: todayDate)
                let nextWeekDate = Calendar.current.date(byAdding: .day, value: 7, to: todayDate)
                
                // Today
                if compareDate(date1: toSetDate, date2: todayDate) {
                    DateButton.setTitle(" 今日", for: .normal)
                    
                    // Tomorrow
                } else if compareDate(date1: toSetDate, date2: tomorrowDate!) {
                    DateButton.setTitle(" 明日", for: .normal)
                    
                    // NextWeek
                } else if compareDate(date1: toSetDate, date2: nextWeekDate!) {
                    DateButton.setTitle(" 下周", for: .normal)
                    
                    // Other Day
                } else {
                    DateButton.setTitle(" \(getStringOfDate(date: toSetDate, type: 1))", for: .normal)
                }
                
                // Reset Alert
                setAlert = nil
                AlertButton.setImage(#imageLiteral(resourceName: "Alert"), for: .normal)
                AlertButton.tintColor = customColor.Black3
                AlertButton.setTitle("", for: .normal)
                
                self.updateButtonsLayout()
            }
            
           
        }

        print("[Date] A task is set on \(setDate)")
    }
    
    @IBAction func unwindToAddTaskPopViewWithAlert(sender: UIStoryboardSegue) {
        animationOfUnwindFromSettingTaskViews()
        
        // Set Model's alert and UI
        if let sourceViewController = sender.source as? AlertViewController, let toSetAlert = sourceViewController.toSetAlert {
            
            setAlert = toSetAlert
            
            AlertButton.setImage(#imageLiteral(resourceName: "Alert_active"), for: .normal)
            AlertButton.tintColor = customColor.Orange_alert
            AlertButton.setTitle(" \(getStringOfDate(date: toSetAlert, type: 2))", for: .normal)
            
        } else {
            // nil
            setAlert = nil
            AlertButton.setImage(#imageLiteral(resourceName: "Alert"), for: .normal)
            AlertButton.tintColor = customColor.Black3
            AlertButton.setTitle("", for: .normal)

        }
        self.updateButtonsLayout()
        
        if let printAlert = setAlert {
            print("[Alert] A task is set an alert ot \(printAlert)")
        }
    }
    
    @IBAction func unwindToAddTaskPopViewWtihTopic(sender: UIStoryboardSegue) {
        animationOfUnwindFromSettingTaskViews()
        
        // Set Model's topic and UI
        if let sourceViewController = sender.source as? TopicViewController, let toSetTopic = sourceViewController.toSetTopic {
            setTopic = toSetTopic
            
            TopicButton.setImage(#imageLiteral(resourceName: "Topic_active"), for: .normal)
            TopicButton.tintColor = customColor.Gray_topic
            TopicButton.setTitle(" \(toSetTopic)", for: .normal)
        } else {
            // nil
            setTopic = nil
            TopicButton.setImage(#imageLiteral(resourceName: "Topic"), for: .normal)
            TopicButton.tintColor = customColor.Black3
            TopicButton.setTitle("", for: .normal)
        }
        self.updateButtonsLayout()
        
        if let printTopic = setTopic {
            print("[Topic] A topic of \(printTopic) is set")
        }
    }
    
    func animationOfUnwindFromSettingTaskViews() {
        let PopViewFrame = PopView.frame
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.PopView.frame = CGRect(x: PopViewFrame.origin.x, y: self.view.frame.height - PopViewFrame.height, width: PopViewFrame.width, height: PopViewFrame.height)
            if self.TaskTitleTextView.text.isEmpty {
                self.TaskTitleTextView.becomeFirstResponder()
            }
        }, completion: nil)
    }
    
    
    // MARK: - Private Methods
    private func updateAddButtonState() {
        //Disable the Add button if the textView is empty
        let text = TaskTitleTextView.text ?? ""
        AddConFirm.isEnabled = !text.isEmpty
        
        if AddConFirm.isEnabled {
            AddConFirm.alpha = 1
        } else {
            AddConFirm.alpha = 0.5
        }
    }
    
    private func setupLineSpace() {
        /*
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        let attributes = [NSAttributedStringKey.paragraphStyle: style, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: customColor.Black1]
        if TaskTitleTextView.markedTextRange == nil {
            TaskTitleTextView.attributedText = NSAttributedString(string: TaskTitleTextView.text, attributes:attributes)
        }*/
    }
    
    // MARK: - Setup View

    // Setup PopView
    func setupPopView() {
        // Set Frame
        let width = self.view.frame.width
        let height = self.view.frame.height
        PopView.frame = CGRect(x: 0, y: height, width: width, height: 140)
        PopView.alpha = 1
        UpdatePopViewLayout()
        
        dismissArea.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: PopView.frame.origin.y - 4)
    }
    
    // Setup Buttons
    private func SetupButtons() {
        
        // AddButton
        AddConFirm.setTitle("添加", for: .normal)
        AddConFirm.setTitleColor(UIColor.white, for: .normal)
        AddConFirm.backgroundColor = customColor.Blue_Background
        AddConFirm.layer.cornerRadius = 8
        AddConFirm.alpha = 0.5
        AddConFirm.addedTouchArea = 6
        AddConFirm.isEnabled = false
        
        
        
        // Date
        DateButton.setImage(#imageLiteral(resourceName: "Date"), for: .normal)
        DateButton.setTitle(" 今日", for: .normal)
        DateButton.setTitleColor(customColor.Green_date, for: .normal)
        DateButton.sizeToFit()
        DateButton.addedTouchArea = 2
        
        // Alert
        AlertButton.setImage(#imageLiteral(resourceName: "Alert"), for: .normal)
        AlertButton.setTitleColor(customColor.Orange_alert, for: .normal)
        AlertButton.tintColor = customColor.Black3
        AlertButton.addedTouchArea = 2
        
        // Topic
        TopicButton.setImage(#imageLiteral(resourceName: "Topic"), for: .normal)
        TopicButton.setTitleColor(customColor.Gray_topic, for: .normal)
        TopicButton.tintColor = customColor.Black3
        TopicButton.addedTouchArea = 2

    }
    
    // Setup Textiew
    private func setupTextView() {
        TaskTitleTextView.frame = CGRect(x: 16, y: self.PopView.frame.height - 64 - 52, width: self.PopView.frame.width - 32, height: 64)
        
        // Set placeholder
        TaskTitleTextView.delegate = self
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "准备做什么？"
        placeholderLabel.font = UIFont.systemFont(ofSize: 20)
        placeholderLabel.textColor = customColor.Black3
        placeholderLabel.sizeToFit()
        TaskTitleTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (placeholderLabel.font?.pointSize)!/2 - 2)
        placeholderLabel.isHidden = !TaskTitleTextView.text.isEmpty
        
        // Cursor Color
        TaskTitleTextView.tintColor = customColor.Blue_Background
        
        // Return Key
        TaskTitleTextView.returnKeyType = .done
        TaskTitleTextView.enablesReturnKeyAutomatically = true
    }
    
    // MARK: - Update view
    
    // Update PopView Layout
    func UpdatePopViewLayout() {
        // CornerRadius
        setupCornerRadius(corner: 2, sender: PopView)
        
        
        // Buttons
        AddConFirm.frame = CGRect(x: PopView.frame.width - 54 - 16, y: PopView.frame.height - 32 - 16, width: 54, height: 32)
        
        updateButtonsLayout()

    }
    
    // Update Buttons position
    func updateButtonsLayout() {
        DateButton.sizeToFit()
        AlertButton.sizeToFit()
        TopicButton.sizeToFit()
        
        let dateWidth = DateButton.frame.width
        let alertWidth = AlertButton.frame.width
        let topicWidth = TopicButton.frame.width
        DateButton.frame = CGRect(x: 16, y: PopView.frame.height - 24 - 20, width: dateWidth, height: 24)
        AlertButton.frame = CGRect(x: 32 + DateButton.frame.width, y: PopView.frame.height - 24 - 20, width: alertWidth, height: 24)
        TopicButton.frame = CGRect(x: 48 + DateButton.frame.width + AlertButton.frame.width, y: PopView.frame.height - 24 - 20, width: topicWidth, height: 24)
        
        let topicFrame = TopicButton.frame
        if topicFrame.minX + topicFrame.width > AddConFirm.frame.minX {
            let updateTopicWidth = AddConFirm.frame.minX - topicFrame.minX - 16
            TopicButton.frame = CGRect(x: topicFrame.minX, y: topicFrame.minY, width: updateTopicWidth, height: 24)
        }
    }

    
   // MARK: Update Methods
    
    func setupCornerRadius(corner: Int, sender: UIView) {
        // Set cornerRadius
        let maskPath: UIBezierPath
        if corner == 2 {
            maskPath = UIBezierPath(roundedRect: sender.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 0))
        } else  {
            maskPath = UIBezierPath(roundedRect: sender.bounds, byRoundingCorners: [.bottomLeft, .bottomRight, .topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 0))
        }
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        sender.layer.mask = maskLayer
    }
    

    // Update View
    @objc func updateView (notification: Notification) {
        // get keyboard's frame
        let userInfo = notification.userInfo!
        let keyboardEndFrameScreenCoordinates = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        
        // Change y when keyboard shows
        if notification.name == Notification.Name.UIKeyboardWillHide {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut , animations: {
                self.view.frame.origin.y = 0
            }, completion: nil)
            //self.performSegue(withIdentifier: "unwindToTodayList", sender: self)
        } else {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= keyboardEndFrame.height
            //print("show: \(self.view.frame.origin.y)")
        }
        
        dismissArea.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: PopView.frame.origin.y - 4)
        
    }
    
    // Resize when editing
    func resizeTextView(height: CGFloat) {
        
        var resizeOrRecover: Bool = true
        if height < 60 {
            resizeOrRecover = false
        }
        
        let PopViewFrame = PopView.frame
        
        switch resizeOrRecover {
        case true:
            // Resize TextView
            if !PopViewHasUpdatedOnce {
                PopViewHasUpdatedOnce = true
                
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.PopView.frame = CGRect(x: PopViewFrame.origin.x, y: PopViewFrame.origin.y - 24, width: PopViewFrame.width, height: 164)
                    self.UpdatePopViewLayout()
                }, completion: nil)
            }
        default:
            if PopViewHasUpdatedOnce {
                PopViewHasUpdatedOnce = false

                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.PopView.frame = CGRect(x: PopViewFrame.origin.x, y: PopViewFrame.origin.y + 24, width: PopViewFrame.width, height: 164)
                    self.UpdatePopViewLayout()

                    // Buttons
                    self.AddConFirm.frame = CGRect(x: self.PopView.frame.width - 54 - 16, y: self.PopView.frame.height - 72, width: 54, height: 32)
                    
                    let dateWidth = self.DateButton.frame.width
                    let alertWidth = self.AlertButton.frame.width
                    let topicWidth = self.TopicButton.frame.width
                    
                    self.DateButton.frame = CGRect(x: 16, y: self.PopView.frame.height - 68, width: dateWidth, height: 24)
                    self.AlertButton.frame = CGRect(x: 32 + self.DateButton.frame.width, y: self.PopView.frame.height - 68, width: alertWidth, height: 24)
                    self.TopicButton.frame = CGRect(x: 48 + self.DateButton.frame.width + self.AlertButton.frame.width, y: self.PopView.frame.height - 68, width: topicWidth, height: 24)
                    
                }, completion: {(finished: Bool) in
                    self.PopView.frame = CGRect(x: PopViewFrame.origin.x, y: self.PopView.frame.origin.y, width: PopViewFrame.width, height: 140)
                })
            }
        }
    }
    
    // MARK: - Set Task Properties Actions
    
    // Set Date
    @IBAction func todayButtonClicked(_ sender: Any) {
        setTaskSegueAnimation(identifier: "SetDateSegue")
    }
    
    // Set Alert
    @IBAction func AlertButtonClicked(_ sender: AddedTouchAreaButton) {
        setTaskSegueAnimation(identifier: "setAlertSegue")
    }
    
    @IBAction func topicButtonClicked(_ sender: AddedTouchAreaButton) {
        setTaskSegueAnimation(identifier: "setTopicSegue")
    }
    
    
    
    func setTaskSegueAnimation(identifier: String) {
        let PopViewFrame = PopView.frame
        
        if self.TaskTitleTextView.isFirstResponder {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.TaskTitleTextView.resignFirstResponder()
                self.PopView.frame = CGRect(x: PopViewFrame.origin.x, y: self.view.frame.height, width: PopViewFrame.width, height: PopViewFrame.height)
            }, completion:{ (_: Bool) in
                self.performSegue(withIdentifier: identifier, sender: self)
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.PopView.frame = CGRect(x: PopViewFrame.origin.x, y: self.view.frame.height, width: PopViewFrame.width, height: PopViewFrame.height)
                self.performSegue(withIdentifier: identifier, sender: self)
            }, completion: nil)
        }
    }
    
}

