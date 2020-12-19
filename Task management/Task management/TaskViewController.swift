//
//  TaskViewController.swift
//  Task management
//
//  Created by Ivan Ivanušić on 18.12.2020..
//

import UIKit

protocol TaskViewControllerDelegate {
    func addTask(taskName: String, taskMoreinfo: String)
    func editTask(taskName: String, taskMoreinfo: String, taskPosition: Int)
}

class TaskViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var moreInfoField: UITextView!
    
    var delegate: TaskViewControllerDelegate?
    
    var actionType: ActionType?
    var name: String?
    var more_info: String?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                nameField.layer.borderColor = nameField.textColor?.cgColor
                moreInfoField.layer.borderColor = moreInfoField.textColor?.cgColor
            }
        }
    }
    
    @objc func doneTapped() {
        guard let name = self.nameField.text else { return }
        if name == "" {
            let ac = UIAlertController(title: "Please enter the name.", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true)
            return
        }

        switch self.actionType {
        case .add:
            self.delegate?.addTask(taskName: name, taskMoreinfo: self.moreInfoField.text)
        case .update:
            self.delegate?.editTask(taskName: name, taskMoreinfo: self.moreInfoField.text, taskPosition: self.index!)
        default:
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setUI() {
        nameField.layer.borderWidth = 1
        moreInfoField.layer.borderWidth = 1
        nameField.layer.cornerRadius = 5
        moreInfoField.layer.cornerRadius = 5
        nameField.layer.borderColor = nameField.textColor?.cgColor
        moreInfoField.layer.borderColor = moreInfoField.textColor?.cgColor
        
        guard let actionType = actionType else { return }
        switch actionType {
        case .add:
            self.title = "Add task"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
            return
        case .view:
            self.title = "Task detail"
            self.nameField.isUserInteractionEnabled = false
            self.moreInfoField.isUserInteractionEnabled = false
            self.nameField.text = self.name!
            self.moreInfoField.text = self.more_info!
            return
        case .update:
            self.title = "Edit task"
            self.nameField.text = self.name!
            self.moreInfoField.text = self.more_info!
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
            return
        }
    }
}
