//
//  TopicViewController.swift
//  TodayList
//
//  Created by hula3 on 2018/4/30.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    
    // MARK: UI
    
    @IBOutlet weak var PopView: UIView!
    @IBOutlet weak var PopViewTitle: UILabel!
    @IBOutlet weak var TopicTableView: UITableView!
    
    // MARK: Topic
    var topics = [String]()
    var toSetTopic: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadTopics()
        
        TopicTableView.delegate = self
        TopicTableView.dataSource = self
        
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        segueAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TopicTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TopicTableViewCell else {
            fatalError("The dequeued cell is not an instance of TopicTableViewCell.")
        }
        
        let topic = topics[indexPath.row]
        cell.TopicTitle.text = topic
        cell.TopicTitle.sizeToFit()
        if indexPath.row == 0 {
            cell.TopicTitle.textColor = customColor.Black3
        }
        
        return cell
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    // Dismiss
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        unwindAnimation()
    }
    
    func unwindAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            let frame = self.PopView.frame
            self.PopView.frame = CGRect(x: 0, y: self.view.frame.height, width: frame.width, height: frame.height)
        })
        self.performSegue(withIdentifier: "topicButtonUnwind", sender: self)
    }

    // MARK: - Setup View
    private func setupView() {
        // TableView
        let countOfTopics = topics.count
        let TopicTableViewHeight = CGFloat((countOfTopics) * 42)
        TopicTableView.frame = CGRect(x: 0, y: 68, width: self.view.frame.width, height:TopicTableViewHeight)
        TopicTableView.backgroundColor = customColor.popViewBackground
        
        // PopView
        PopView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 68 + TopicTableViewHeight + 16)
        PopView.backgroundColor = customColor.popViewBackground
        setupCornerRadius()
        
        // Title
        PopViewTitle.textColor = customColor.Black1
        PopViewTitle.sizeToFit()
        PopViewTitle.frame = CGRect(x: 16, y: 24, width: PopViewTitle.frame.width, height: PopViewTitle.frame.height)
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

    //Animation before view appears
    func segueAnimation() {
        let popViewHeight = PopView.frame.height
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.PopView.frame = CGRect(x: 0, y: self.view.frame.height - popViewHeight, width: self.view.frame.width, height: popViewHeight)
        }, completion: nil)
    }
    
    // loadTopics
    private func loadTopics() {
        var sampleTopic = [String]()
        sampleTopic.append("学习")
        sampleTopic.append("工作")
        
        topics.append("无主题")
        for element in sampleTopic {
            topics.append(element)
        }
    }
    

    
}
