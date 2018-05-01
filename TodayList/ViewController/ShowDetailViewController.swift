//
//  ShowDetailViewController.swift
//  TodayList
//
//  Created by hula3 on 2018/3/20.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class ShowDetailViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    // MARK: UI
    // @IBOutlet weak var returnButton: UIBarButtonItem!

    //@IBOutlet weak var hideKeybo ardButton: UIBarButtonItem!
    
    @IBOutlet weak var checkbox: CheckBox!
    @IBOutlet weak var titleTextView: UITextView!
    var titlePlaceholder = UILabel()
    
    @IBOutlet weak var remarkTextView: UITextView!
    var remarkPlaceholder =  UILabel()
    
    @IBOutlet weak var dateButton: AddedTouchAreaButton!
    @IBOutlet weak var alertButton: AddedTouchAreaButton!
    @IBOutlet weak var topicButton: AddedTouchAreaButton!
    
    @IBOutlet weak var moreButton: AddedTouchAreaButton!
    @IBOutlet weak var deleteButton: AddedTouchAreaButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    // MARK: Model
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //task = Task(title: "try", isChecked: false, date: Date())
        
        setupView()
        setupGestrueRecognizer()
        
        setupLineSpace()
        
        // Update View
        NotificationCenter.default.addObserver(self, selector: #selector(ShowDetailViewController.updateScrollView(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ShowDetailViewController.updateScrollView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ShowDetailViewController.updateScrollView(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.05) {
            self.navigationController?.navigationBar.alpha = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TextView Delegate Methods
    func textViewDidChange(_ textView: UITextView) {
        // Placeholder
        titlePlaceholder.isHidden = !titleTextView.text.isEmpty
        remarkPlaceholder.isHidden = !remarkTextView.text.isEmpty
        
        // Line Space
        setupLineSpace()
    }
    
    private func setupLineSpace() {
        let titleStyle = NSMutableParagraphStyle()
        let remarkStyle = NSMutableParagraphStyle()
        
        titleStyle.lineSpacing = 8
        remarkStyle.lineSpacing = 4
        
        let titleAttributes = [NSAttributedStringKey.paragraphStyle: titleStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: .medium) , NSAttributedStringKey.foregroundColor: customColor.Black1]
        if titleTextView.markedTextRange == nil {
            titleTextView.attributedText = NSAttributedString(string: titleTextView.text, attributes:titleAttributes)
        }
        
        let remarkAttributes = [NSAttributedStringKey.paragraphStyle: remarkStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: customColor.Black2]
        if remarkTextView.markedTextRange == nil {
            remarkTextView.attributedText = NSAttributedString(string: remarkTextView.text, attributes:remarkAttributes)
        }
    }
    
    // Disable newline in titleTextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            titleTextView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hideKeyboard"), style: .plain, target: self, action: #selector(ShowDetailViewController.hideKeyboardButtonClicked(_:)))
        
        self.navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem = nil
        task.title = titleTextView.text
        task.remark = remarkTextView.text
        
        if titleTextView.text.isEmpty {
            self.navigationItem.leftBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        switch (segue.identifier ?? "") {
            
        case "unwindToTodayListFromEdit":
            print("unwindToTodayListFormEdit")
            
            
        case "unwindToTodayListForDeleting":
            print("unwindToTodayListForDeleting")
            
        case "setDateFromEdit":
            print("SetDateSegue")
            
            // Set maskBackground
            guard let dateViewController = segue.destination as? DateViewController else {
                fatalError("Unexpected Segue Identifier; \(segue.identifier!)")
            }
            dateViewController.view.backgroundColor = customColor.PopviewMaskBackground
            dateViewController.toSetDate = task.date
            
        case "setAlertFromEdit":
            print("setAlertSegue")
            
            // Set toSetDate, toSetAlert & MaskBG
            guard let alertViewController = segue.destination as? AlertViewController else {
                fatalError("Unexpected Segue Identifier; \(segue.identifier!)")
            }
            if let AlertHasSet = task.alert {
                alertViewController.toSetAlert = AlertHasSet
            }
            alertViewController.view.backgroundColor = customColor.PopviewMaskBackground
            alertViewController.toSetDate = task.date

        
       
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier!)")
            
        }
        
        
        //alert
        
        // todaylist
    }

    @IBAction func unwindToShowDetailView(sender: UIStoryboardSegue) {
        // Set Alert
        if let sourceViewController = sender.source as? AlertViewController, let toSetAlert = sourceViewController.toSetAlert {
            task.alert = toSetAlert
            
        // Set Date
        } else if let sourceViewController = sender.source as? DateViewController, let toSetDate = sourceViewController.toSetDate {
            if !compareDate(date1: task.date, date2: toSetDate) {
                task.date = toSetDate
                task.alert = nil
            }
        } else {
            task.alert = nil
        }
        
        updateButtonsInfo()
    }
    
    
    

    // MARK: - Setup View
    
    func setupView() {
        // View Background
        view.backgroundColor = customColor.globalBackground
        
        // ---------------
        //Navigation Bar
        self.navigationController?.navigationBar.alpha = 0.1
        // ReturnButton
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "return"), style: .plain, target: self, action: #selector(ShowDetailViewController.returnButtonClicked(_:)))
        

        // LargeTitle
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        // Navigation Bar
        self.navigationController?.navigationBar.barTintColor = customColor.globalBackground
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // ---------------
        // Content
        
        // checkbox
        //checkbox.setBackgroundImage(#imageLiteral(resourceName: "Checkmark_L"), for: .normal)
        checkbox.checboxType = 1
        //checkbox.tintColor = customColor.Black3
        
        // Title
        titleTextView.delegate = self
        titleTextView.text = task.title
        
        // TitlePlaceholder
        titlePlaceholder.text = "得给任务定个标题"
        titlePlaceholder.font = UIFont.systemFont(ofSize: 20)
        titlePlaceholder.textColor = customColor.Black3
        
        titlePlaceholder.sizeToFit()
        titleTextView.addSubview(titlePlaceholder)
        titlePlaceholder.frame.origin = CGPoint(x: 5, y: (titlePlaceholder.font?.pointSize)!/2 - 2)
        
        titlePlaceholder.isHidden = !titleTextView.text.isEmpty
        
        
        // Remark
        remarkTextView.delegate = self
        remarkTextView.text = task.remark
        
        // RemarkPlaceholder
        remarkPlaceholder.text = "添加备注"
        remarkPlaceholder.font = UIFont.systemFont(ofSize: 16)
        remarkPlaceholder.textColor = customColor.Black3
        
        remarkPlaceholder.sizeToFit()
        remarkTextView.addSubview(remarkPlaceholder)
        remarkPlaceholder.frame.origin = CGPoint(x: 5, y: (remarkPlaceholder.font?.pointSize)!/2)
        
        remarkPlaceholder.isHidden = !remarkTextView.text.isEmpty
        
        
        // Cursor Color
        titleTextView.tintColor = customColor.Blue_Background
        remarkTextView.tintColor = customColor.Blue_Background
        
        // Return Key
        titleTextView.returnKeyType = .done
        titleTextView.enablesReturnKeyAutomatically = true
        remarkTextView.enablesReturnKeyAutomatically = true
        
        
        // ---------------
        // Buttons
        
        // Date
        dateButton.setImage(#imageLiteral(resourceName: "Date"), for: .normal)
        dateButton.tintColor = customColor.Green_date
        
        //dateButton.setTitleColor(customColor.Green_date, for: .normal)
        dateButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        dateButton.addedTouchArea = 2
        
        // Alert
        alertButton.setImage(#imageLiteral(resourceName: "Alert"), for: .normal)
        alertButton.tintColor = customColor.Black3
        
        alertButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        alertButton.addedTouchArea = 2
        
        // Topic
        topicButton.setImage(#imageLiteral(resourceName: "Topic"), for: .normal)
        topicButton.tintColor = customColor.Black3
        
        topicButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        topicButton.addedTouchArea = 2
        
        // moreButton
        moreButton.setImage(#imageLiteral(resourceName: "more"), for: .normal)
        moreButton.tintColor = customColor.Black3
        
        moreButton.setTitle("", for: .normal)
        moreButton.addedTouchArea = 4
        
        // deleteButton
        deleteButton.setImage(#imageLiteral(resourceName: "deleteTask"), for: .normal)
        deleteButton.tintColor = customColor.Red_delete
        
        deleteButton.setTitle("", for: .normal)
        deleteButton.addedTouchArea = 4
        deleteButton.alpha = 0

        updateButtonsInfo()
    }
    
    func setupGestrueRecognizer() {
        // Tap
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(singleTap)
        
        // Pop gestrue
        /*
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        */
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func updateButtonsInfo() {
        // Ddetermin the date
        let todayDate = Date()
        let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: todayDate)
        let nextWeekDate = Calendar.current.date(byAdding: .day, value: 7, to: todayDate)
        
        // Today
        if compareDate(date1: task.date, date2: todayDate) {
            dateButton.setTitle(" 今日", for: .normal)
            
        // Tomorrow
        } else if compareDate(date1: task.date, date2: tomorrowDate!) {
            dateButton.setTitle(" 明日", for: .normal)
            
        // NextWeek
        } else if compareDate(date1: task.date, date2: nextWeekDate!) {
            dateButton.setTitle(" 下周", for: .normal)
            
        // Other Day
        } else {
            dateButton.setTitle(" \(getStringOfDate(date: task.date, type: 1))", for: .normal)
        }
        
        
        // Determin the alert
        if let alert = task.alert {
            alertButton.setTitle(" \(getStringOfDate(date: alert, type: 2))", for: .normal)
            //alertButton.setTitleColor(customColor.Orange_alert, for: .normal)
            
            alertButton.setImage(#imageLiteral(resourceName: "Alert_active"), for: .normal)
            alertButton.tintColor = customColor.Orange_alert
        } else {
            alertButton.setTitle("无提醒", for: .normal)
            //alertButton.setTitleColor(customColor.Black3, for: .normal)
            alertButton.tintColor = customColor.Black3
        }
        
        
        // Determin the topic
        if let topic = task.topic {
        
        } else {
            topicButton.setTitle("无主题", for: .normal)
            topicButton.setTitleColor(customColor.Black3, for: .normal)
        }
        
        // UpdateLayout
        dateButton.sizeToFit()
        alertButton.sizeToFit()
        topicButton.sizeToFit()
    }
    
    // MARK: - Text View Methods
    @objc func updateScrollView(notification: Notification) {
        // get keyboard's frame
        let userInfo = notification.userInfo!
        let keyboardEndFrameScreenCoordinates = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets.zero
            scrollView.scrollRectToVisible(titleTextView.frame, animated: true)
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrame.height + 8, right: 0)
            scrollView.scrollIndicatorInsets = scrollView.contentInset
            scrollView.scrollRectToVisible(dateButton.frame, animated: true)
        }
        
    }
    
    // MARK: - Action Mehtods
    
    // MARK: Gesture functions
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        print("touch")
        self.view.endEditing(true)
    }
    
    
    // MARK: Buttons clicked
    @objc func returnButtonClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.navigationBar.alpha = 0
        self.performSegue(withIdentifier: "unwindToTodayListFromEdit", sender: self)
    }
    
    @objc func hideKeyboardButtonClicked(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        //self.scrollView.endEditing(true)
    }
    
    
    @IBAction func checkboxClicked(_ sender: CheckBox) {
        if checkbox.isChecked {
            checkbox.isChecked = false
            task.isChecked = false
            
        } else {
            checkbox.isChecked = true
            task.isChecked = true
        }
    }
    
    
    @IBAction func dateButtonClicked(_ sender: AddedTouchAreaButton) {
        self.performSegue(withIdentifier: "setDateFromEdit", sender: self)
    }
    
    @IBAction func alertButtonClicked(_ sender: AddedTouchAreaButton) {
        self.performSegue(withIdentifier: "setAlertFromEdit", sender: self)
    }
    
    
    @IBAction func moreButtonClicked(_ sender: AddedTouchAreaButton) {
        self.deleteButton.isEnabled = true
        self.moreButton.isEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.deleteButton.alpha = 1
            self.moreButton.alpha = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            UIView.animate(withDuration: 0.3) {
                self.deleteButton.alpha = 0
                self.moreButton.alpha = 1
            }
            self.deleteButton.isEnabled = false
            self.moreButton.isEnabled = true
        })
    }
    
    @IBAction func deleteButtonClicked(_ sender: AddedTouchAreaButton) {
        print("delete clicked")
        showDeleteActionSheet()
        
    }
    
    func showDeleteActionSheet() {
        let actionSheet = UIAlertController(title: "确定要删除此任务吗？", message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "确认删除", style: .destructive) { action in
            self.performSegue(withIdentifier: "unwindToTodayListForDeleting", sender: self)
        }
        
        actionSheet.addAction(cancel)
        actionSheet.addAction(delete)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
}
