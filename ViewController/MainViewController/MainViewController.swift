//
//  MainViewController.swift
//  ProfileApp
//
//  Created by Дмитрий on 21.02.2025.
//

import UIKit

final class MainViewController: UIViewController {
    
    private lazy var mainView = MainView(subscriber: self)
    private lazy var child = [Child]()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGesture()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTableView() {
        mainView.childrenTableView.delegate = self
        mainView.childrenTableView.dataSource = self
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: .zero, left: .zero, bottom: self.child.count < 5 ? keyboardSize.height : keyboardSize.height - mainView.deleteAllChildButton.bounds.height, right: .zero)
        mainView.childrenTableView.contentInset = contentInsets
        mainView.childrenTableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        mainView.childrenTableView.contentInset = contentInsets
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        mainView.childrenTableView.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        mainView.endEditing(true)
    }
}

extension MainViewController: MainViewDelegate {
    
    func addChildButtonTapped(sender: UIButton) {
        hideKeyboard()
        sender.pulsate(from: 1.0, to: 0.9, speed: 2.0, reverse: true, completion: {
            self.child.append(Child(name: "", age: .zero))
            self.mainView.childrenTableView.reloadData()
            DispatchQueue.main.async {
                self.mainView.childrenTableView.scrollToRow(at: IndexPath(row: self.child.count - 1, section: .zero), at: .bottom, animated: true)
            }
            sender.isEnabled = self.child.count < 5  ? true : false
            sender.imageView?.alpha = self.child.count < 5  ? 1.0 : 0.2
        })
    }
    
    func deleteChildButtonTapped(sender: UIButton) {
        hideKeyboard()
        sender.pulsate(from: 1.0, to: 0.9, speed: 2.0, reverse: true, completion: {
            let position: CGPoint = sender.convert(.zero, to: self.mainView.childrenTableView)
            let indexPath = self.mainView.childrenTableView.indexPathForRow(at: position) ?? IndexPath(row: .zero, section: .zero)
            self.child.remove(at: indexPath.row)
            self.mainView.childrenTableView.deleteRows(at: [indexPath], with: .middle)
            DispatchQueue.main.async {
                UIView.performWithoutAnimation({
                    self.mainView.childrenTableView.reloadSections(IndexSet(integer: .zero), with: .none)
                    self.mainView.childrenTableView.beginUpdates()
                    self.mainView.childrenTableView.endUpdates()
                })
            }
            self.mainView.addChildButton.isEnabled = self.child.count < 5  ? true : false
            self.mainView.addChildButton.imageView?.alpha = self.child.count < 5  ? 1.0 : 0.2
        })
    }
    
    func deleteAllChildButtonTapped(sender: UIButton) {
        hideKeyboard()
        sender.pulsate(from: 1.0, to: 0.9, speed: 2.0, reverse: true, completion: {
            self.showAlert()
        })
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Внимание", message: "Действительно хотите удалить все записи?", preferredStyle: .actionSheet)
        let yesAcion = UIAlertAction(title: "Да", style: .destructive) { _ in
            self.clearData()
        }
        let noAcion = UIAlertAction(title: "Нет", style: .default)
        [yesAcion, noAcion].forEach { action in
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
    
    private func clearData() {
        self.child.removeAll()
        DispatchQueue.main.async {
            UIView.performWithoutAnimation({
                self.mainView.childrenTableView.reloadSections(IndexSet(integer: .zero), with: .none)
                self.mainView.childrenTableView.beginUpdates()
                self.mainView.childrenTableView.endUpdates()
            })
        }
        self.mainView.addChildButton.isEnabled = true
        self.mainView.addChildButton.imageView?.alpha = 1.0
        self.mainView.deleteAllChildButton.isHidden = true
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return child.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChildrenTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.delegate = self
        cell.nameTextField.delegate = self
        cell.ageTextField.delegate = self
        if indexPath.row == child.count - 1  {
            cell.separatorInset = UIEdgeInsets.init(top: .zero, left: UIScreen.main.bounds.width, bottom: .zero, right: .zero)
        } else {
            cell.separatorInset = .zero
        }
        mainView.deleteAllChildButton.isHidden = child.count < 5 ? true : false
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? ChildrenTableViewCell)?.configure(name: child[indexPath.row].name, age: child[indexPath.row].age)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let position: CGPoint = textField.convert(.zero, to: self.mainView.childrenTableView)
        let indexPath = self.mainView.childrenTableView.indexPathForRow(at: position) ?? IndexPath(row: .zero, section: .zero)
        let cell = mainView.childrenTableView.cellForRow(at: indexPath) as! ChildrenTableViewCell
        if textField == cell.nameTextField {
            child[indexPath.row].name = textField.text ?? ""
        } else {
            child[indexPath.row].age = Int(textField.text ?? "") ?? 0
        }
    }
}
