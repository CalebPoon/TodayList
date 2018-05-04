//
//  EditViewController.swift
//  TodayList
//
//  Created by hula3 on 2018/3/19.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextViewDelegate {
    // MARK: - Properties
    // MARK: UI
    
    @IBOutlet weak var returnButton: UIBarButtonItem!
    
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var TaskTitleTextView: UITextView!
    var placeholderLabelOfTitle: UILabel!
    @IBOutlet weak var titleCell: UIView!
    
    @IBOutlet weak var remarkTextView: UITextView!
    var placeholderLabelOfRemark: UILabel!
    @IBOutlet weak var remarkCell: UIView!
    
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var topicButton: UIButton!
    
    @IBOutlet weak var moreButton: UIButton!
    
    // MARK: Model
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //task = Task(title: "try", isChecked: false, date: Date(), alert: nil, topic: nil, remark: nil)
        
        setView()
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK: - TextView Delegate Methods
    func textViewDidChange(_ textView: UITextView) {
        // Placeholder
        placeholderLabelOfTitle.isHidden = !TaskTitleTextView.text.isEmpty
        placeholderLabelOfRemark.isHidden = !remarkTextView.text.isEmpty
        
        // Line Space
        let TitleStyle = NSMutableParagraphStyle()
        let RemarkStyle = NSMutableParagraphStyle()
        
        TitleStyle.lineSpacing = 8
        RemarkStyle.lineSpacing = 4
        
        let TitleAttributes = [NSAttributedStringKey.paragraphStyle: TitleStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: .medium) , NSAttributedStringKey.foregroundColor: customColor.Black1]
        if TaskTitleTextView.markedTextRange == nil {
            TaskTitleTextView.attributedText = NSAttributedString(string: TaskTitleTextView.text, attributes:TitleAttributes)
        }
        
        let RemarkAttributes = [NSAttributedStringKey.paragraphStyle: RemarkStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: customColor.Black2]
        if remarkTextView.markedTextRange == nil {
            remarkTextView.attributedText = NSAttributedString(string: remarkTextView.text, attributes:RemarkAttributes)
        }
        
        // TextView Height
        let height = TaskTitleTextView.contentSize.height
        let frame = TaskTitleTextView.frame
        TaskTitleTextView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: height)
        updateLayout()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            TaskTitleTextView.resignFirstResponder()
        }
        return true
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
    func updateLayout(){
        titleCell.frame = CGRect(x: 0, y: 112 + 16, width: self.view.frame.width, height: TaskTitleTextView.frame.height + 8)
        remarkCell.frame = CGRect(x: 0, y: 112 + 16 + titleCell.frame.height, width: self.view.frame.width, height: remarkTextView.frame.height + 20)
    }
    
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
        titleCell.frame = CGRect(x: 0, y: 112 + 16, width: self.view.frame.width, height: 46)
        titleCell.backgroundColor = customColor.globalBackground
        
        // checkbox
        checkbox.setImage(#imageLiteral(resourceName: "Checkmark_L"), for: .normal)
        checkbox.tintColor = customColor.Black3
        checkbox.frame = CGRect(x: 16, y: 12, width: 24, height: 24)
        
        // taskTitle
        TaskTitleTextView.text = "尝试新任务"
        TaskTitleTextView.sizeToFit()
        TaskTitleTextView.frame = CGRect(x: 44, y: 4, width: self.view.frame.width - 16 - 44, height: TaskTitleTextView.frame.height)
        TaskTitleTextView.textColor = customColor.Black1
        TaskTitleTextView.backgroundColor = customColor.globalBackground
        TaskTitleTextView.delegate = self
        
        // TextView Placehold
        TaskTitleTextView.delegate = self
        placeholderLabelOfTitle = UILabel()
        placeholderLabelOfTitle.text = "得给任务定个标题"
        placeholderLabelOfTitle.font = UIFont.systemFont(ofSize: 20)
        placeholderLabelOfTitle.textColor = customColor.Black3
        placeholderLabelOfTitle.sizeToFit()
        TaskTitleTextView.addSubview(placeholderLabelOfTitle)
        placeholderLabelOfTitle.frame.origin = CGPoint(x: 5, y: (placeholderLabelOfTitle.font?.pointSize)!/2 - 2)
        placeholderLabelOfTitle.isHidden = !TaskTitleTextView.text.isEmpty

        // Cursor Color
        TaskTitleTextView.tintColor = customColor.Blue_Background
        
        
        // Return Key
        TaskTitleTextView.returnKeyType = .done
        TaskTitleTextView.enablesReturnKeyAutomatically = true
        
        
        // ----------------
        // remarkCell
        remarkCell.frame = CGRect(x: 0, y: 112 + 16 + titleCell.frame.height, width: self.view.frame.width, height: remarkTextView.frame.height + 20)
        remarkCell.backgroundColor = customColor.globalBackground
        
        // remarkTextView
        remarkTextView.text = task.remark
        remarkTextView.frame = CGRect(x: 44, y: 10, width: self.view.frame.width - 16 - 44, height: 36)
        remarkTextView.textColor = customColor.Black2
        remarkTextView.backgroundColor = customColor.globalBackground
        
        // TextView Placehold
        remarkTextView.delegate = self
        placeholderLabelOfRemark = UILabel()
        placeholderLabelOfRemark.text = "添加备注"
        placeholderLabelOfRemark.font = UIFont.systemFont(ofSize: 16)
        placeholderLabelOfRemark.textColor = customColor.Black3
        placeholderLabelOfRemark.sizeToFit()
        remarkTextView.addSubview(placeholderLabelOfRemark)
        placeholderLabelOfRemark.frame.origin = CGPoint(x: 5, y: (placeholderLabelOfRemark.font?.pointSize)!/2)
        placeholderLabelOfRemark.isHidden = !remarkTextView.text.isEmpty
        
        // Cursor Color
        remarkTextView.tintColor = customColor.Blue_Background
        
        
        // Return Key
        //remarkTextView.returnKeyType = .done
        remarkTextView.enablesReturnKeyAutomatically = true

        // ----------------
        // dateButton
        //dateButton.setImage(#imageLiteral(resourceName: "Date"), for: <#T##UIControlState#>)
        
    }

}

