//
//  ViewController.swift
//  TodayList
//
//  Created by hula3 on 2018/3/2.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit
import AudioToolbox

class TodayListViewController: UITableViewController, TodayListTaskTableViewCellDelegate {

    //MARK: Properties
    
    var uncheckedTasks = [Task]()
    var checkedTasks = [Task]()
    
    var checkingRow =  [Int]()
    //var checkingRowValue = [Int: Int]()
    
    var addButton = UIButton.init(type: UIButtonType.system)
    //var addButtonFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var emptyStateView: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Custom Navigation Bar: LageTitle
        self.title = "今日"
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
        
        // Custom Navigation Bar: appearance
        self.navigationController?.navigationBar.barTintColor = customColor.globalBackground
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)

        
        // Whole Background appearabce
        view.backgroundColor = customColor.globalBackground
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Add space below the navBar
        self.tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
        //Add Gesture of Tap and LongPress
        let TapGesture = UITapGestureRecognizer(target: self, action: #selector(TodayListViewController.addButtonTapped(_:)))
        let LongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(TodayListViewController.addButtonLongPressed(_:)))
        addButton.addGestureRecognizer(TapGesture)
        addButton.addGestureRecognizer(LongPressGesture)
        
        // Load the sample data.
        loadSampleTask()
        
        // Setup AddButton
        setupAddButton()
        
        // Setup EmptyState
        setupEmptyStateView()
        
        // EmptyState
        if self.uncheckedTasks.count == 0 {
            TodayListIsEmpty()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return uncheckedTasks.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // able view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TodayTaskCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TodayListTaskTableViewCell else {
            fatalError("The dequeued cell is not an instance of TodayListTaskTableViewCell.")
        }
        
        // Assign cell delegate to view controller
        cell.delegate = self
     
        // Fetches the appropriate task for the data source layout.
        let task = uncheckedTasks[indexPath.row]
        
        cell.TaskTitle.text = task.title
        cell.Checkbox.isChecked = task.isChecked

        return cell
     }
    
    // Keep the addButton floating
    override func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        var frame: CGRect = self.addButton.frame
        frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height
        addButton.frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - 60 - 12
        
        tableView.bringSubview(toFront: addButton)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    
     // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        /*
        switch (segue.identifier ?? "") {
        case "AddTask":
            /*
            guard let AddTaskPop = segue.destination as? AddTaskPopViewController
                else {
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let AddTaskButton = sender as? UIButton else {
                fatalError("Unexpected sender: \(sender)")
            }*/
            
        default:
            fatalError("Unexpected Segue Identifier: \(segue.identifier)")
        }*/
        
    }
    
    @IBAction func dismissToTodayList(sender: UIStoryboardSegue) {
        loadAddButtonAnimation()
    }
    
        
    @IBAction func unwindToTodayList(sender: UIStoryboardSegue) {
        loadAddButtonAnimation()
        
        if let sourceViewController = sender.source as? AddTaskPopViewController, let task = sourceViewController.task {
            //Add a new task
            let newIndexPath = IndexPath(row: uncheckedTasks.count, section: 0)
            
            uncheckedTasks.append(task)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }

    
    // MARK: - Check Task
    
    // Implement Delegate Method
    func checkboxTapped(cell: TodayListTaskTableViewCell) {
        // Get the indexpath of cell where checkbox was tapped
        let indexPath = self.tableView.indexPath(for: cell)
        let row = indexPath!.row
        
        let width = cell.frame.width
        let height = cell.frame.height
        
        // Change checkbox states and update CheckingRowArray
        if cell.Checkbox.isChecked {
            cell.Checkbox.isChecked = false
            
            //Animation
            UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
                cell.backgroundView?.alpha = 0
                cell.backgroundView?.frame = CGRect(x: 0 - width, y: 0, width: width, height: height)
            }, completion: nil)
            
        } else {
            cell.Checkbox.isChecked = true
            
            //Animation
            cell.backgroundView = UIImageView(image: #imageLiteral(resourceName: "CheckedCell"))
            cell.backgroundView?.frame = CGRect(x: 0 - width, y: 0, width: width, height: height)
            
            UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
                cell.backgroundView?.alpha = 1
                cell.backgroundView?.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }, completion: nil)
            
            // push the row in CheckingRowArray when it is checked at the first time
            if self.checkingRow.filter({$0 == row}).isEmpty {
                self.checkingRow.append(row)
                delayCheck(cell: cell, indexPath: indexPath)
            }
        }
    }
    
    func delayCheck(cell: TodayListTaskTableViewCell, indexPath: IndexPath?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // Func should be executed when there is a row waiting for checked
            if !self.checkingRow.isEmpty {
                // FIFO
                let toCheckedRow = self.checkingRow.first
                
                if cell.Checkbox.isChecked {
                    cell.Checkbox.isEnabled = false
                    // Transfer the checkedTask to the array of checkedTasks, and delete it from the table view
                    // Transfer
                    
                    let checkedTask = self.uncheckedTasks[toCheckedRow!]
                    self.uncheckedTasks.remove(at: toCheckedRow!)
                    checkedTask.isChecked = cell.Checkbox.isChecked
                    self.checkedTasks.append(checkedTask)
                    
                    // Delete from tableView
                    var toCheckedIndexPath = indexPath
                    toCheckedIndexPath?.row = toCheckedRow!
                    self.tableView.deleteRows(at: [toCheckedIndexPath!], with: .fade)
                    cell.backgroundView = nil
                    
                    //print("After row\(toCheckedRow) is checked: checkedTasks: \(self.checkedTasks.count), uncheckedTasks: \(self.uncheckedTasks.count)")
                    
                    
                    // Update the checkingRow's row nunmber after deleting and pop the first one
                    if self.checkingRow.count == 1 {
                        self.checkingRow.removeFirst()
                    } else {
                        let count = self.checkingRow.count
                        for index in 1..<count  {
                            if self.checkingRow[index] > self.checkingRow[0] {
                                self.checkingRow[index] -= 1
                            }
                        }
                        self.checkingRow.removeFirst()
                    }
                    
                    if self.uncheckedTasks.count == 0 {
                        self.TodayListIsEmpty()
                    }
                    
                } else {
                    
                    // Pop the row in CheckingRowArray if it is unchecked
                    self.checkingRow.removeFirst()
                    /*
                    if self.checkingRow.count == 1 {
                        self.checkingRow.removeAll()
                    } else {
                        self.checkingRow = self.checkingRow.filter({$0 != row})
                    }*/
                }
            }
        }
    }
    
    //MARK: - Private Methods
    private func loadSampleTask() {
        guard let task1 = Task(title: "点击左侧方框完成任务", isChecked: false) else {
            fatalError("Unable to instantiate task1")
        }
        
        guard let task2 = Task(title: "点击右下角加号按钮添加任务", isChecked: false) else {
            fatalError("Unable to instantiate task2")
        }
        
        guard let task3 = Task(title: "点击任务标题编辑详情", isChecked: false) else {
            fatalError("Unable to instantiate task3")
        }

        uncheckedTasks += [task1, task2, task3]
        
        /*
        // Test Tasks
        for index in 0...12 {
            guard let task = Task(title: "测试任务\(index)", isChecked: false) else {
                fatalError("Unable to instantiate task\(index)")
            }
            self.uncheckedTasks += [task]
        }*/
        
        print("Before check: checkedTasks: \(checkedTasks.count), uncheckedTasks: \(uncheckedTasks.count)")
    }
    
    func setupEmptyStateView() {
        emptyStateView = UILabel()
        emptyStateView.text = "无事。"
        emptyStateView.textColor = customColor.Black2
        emptyStateView.font = UIFont.systemFont(ofSize: 34, weight: .light)
        emptyStateView.sizeToFit()
        
        let frame = emptyStateView.frame
        emptyStateView.frame = CGRect(x: 16, y: 0, width: frame.width, height: frame.height)
        
        emptyStateView.alpha = 0
        emptyStateView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.addSubview(emptyStateView)
        
        emptyStateView.isHidden = true
    }
    
    func TodayListIsEmpty() {
        emptyStateView.isHidden = false
        
        // Animation
        UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseInOut, animations: {
            self.emptyStateView.alpha = 1
            self.emptyStateView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        
    }
    
    private func loadAddButtonAnimation() {
        // AddButton animate
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseInOut, animations: {
            self.addButton.setBackgroundImage(#imageLiteral(resourceName: "AddTask"), for: .normal)
            self.addButton.alpha = 1
            self.addButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
        }, completion: {(finished: Bool) in
            
            UIView.animate(withDuration: 0.2, animations: {
                self.addButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
            })
        })
    }
    

    // MARK: - AddButon functions
    
    // Setup the addButton on homepage
    func setupAddButton() {
        addButton.setTitle("", for: .normal)
        addButton.setBackgroundImage(#imageLiteral(resourceName: "AddTask"), for: .normal)
        addButton.frame.size = CGSize(width: 60, height: 60)
        
        // Set its original place by frame
        addButton.frame = CGRect(x: self.view.frame.width - 60 - 12, y: self.view.frame.height - 112 - 12 - 60 - 12, width: 60, height: 60)
        
        self.view.addSubview(addButton)
        
        /*
        // Keep floating by setting constraints
        addTask.translatesAutoresizingMaskIntoConstraints = false
        addTask.heightAnchor.constraint(equalToConstant: 60)
        addTask.widthAnchor.constraint(equalToConstant: 500)
        if #available(iOS 11.0, *) {
            addTask.rightAnchor.constraint(equalTo: self.tableView.safeAreaLayoutGuide.rightAnchor, constant: -12).isActive = true
            addTask.bottomAnchor.constraint(equalTo: self.tableView.safeAreaLayoutGuide.bottomAnchor, constant: -12).isActive = true
        } else {
            addTask.rightAnchor.constraint(equalTo: tableView.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
            addTask.bottomAnchor.constraint(equalTo: tableView.layoutMarginsGuide.bottomAnchor , constant: -12).isActive = true
        }*/
    }
    
    @objc func addButtonTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
             print("Tapped")
            
            // Animation and Add Segue
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut ,animations: {
                self.addButton.transform = CGAffineTransform(scaleX: 0.9 , y: 0.9)
                self.addButton.alpha = 0.6
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.addButton.alpha = 0
                    self.addButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: {(finished:Bool) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.addButton.transform = CGAffineTransform(scaleX: 0, y: 0)
                        self.performSegue(withIdentifier: "AddTask", sender: self)
                    })
                })
            })
            
            // Actuate 'Peek' feedback
            AudioServicesPlaySystemSound(1519)
        }
    }
    
    @objc func addButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {

            print("Long Pressed")
            // Animation
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut ,animations: {
                self.addButton.alpha = 1
                self.addButton.setBackgroundImage(#imageLiteral(resourceName: "AddIdea"), for: .normal)
                self.addButton.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
                
                // Actuate 'Pop' feedback
                AudioServicesPlaySystemSound(1520)
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                    //self.addButton.setBackgroundImage(#imageLiteral(resourceName: "AddTask"), for: .normal)
                    self.addButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                    // Actuate 'Peek' feedback
                    AudioServicesPlaySystemSound(1519)
                }, completion: nil)
            })
        }
    }
    
}

