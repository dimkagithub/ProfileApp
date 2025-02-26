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
        isChildrenAdded(status: false)
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
        let contentInsets = UIEdgeInsets(top: .zero, left: .zero, bottom: self.child.count < 5 ? keyboardSize.height : keyboardSize.height - mainView.deleteAllChildButtonStackView.bounds.height, right: .zero)
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
    
    private func add(sender: UIButton) {
        mainView.childrenTableView.alpha = 1.0
        child.append(Child(name: "", age: .zero))
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                self.mainView.childrenTableView.reloadSections(IndexSet(integer: .zero), with: .none)
                self.mainView.childrenTableView.beginUpdates()
                self.mainView.childrenTableView.endUpdates()
            }
        }
        DispatchQueue.main.async {
            self.mainView.childrenTableView.scrollToRow(at: IndexPath(row: self.child.count - 1, section: .zero), at: .bottom, animated: true)
        }
        sender.isEnabled = self.child.count < 5 ? true : false
        sender.imageView?.alpha = self.child.count < 5  ? 1.0 : 0.2
        if !child.isEmpty {
            isChildrenAdded(status: true)
        }
        if child.count == 5 {
            mainView.deleteAllChildButtonStackView.alpha = .zero
            mainView.stackView.addArrangedSubview(mainView.deleteAllChildButtonStackView)
            UIView.animate(withDuration: 0.5) {
                self.mainView.stackView.subviews.last!.isHidden = false
                self.mainView.stackView.subviews.last!.alpha = 1.0
            }
        }
    }
    
    private func delete(indexPath: IndexPath) {
        child.remove(at: indexPath.row)
        mainView.childrenTableView.deleteRows(at: [indexPath], with: .middle)
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                self.mainView.childrenTableView.reloadSections(IndexSet(integer: .zero), with: .none)
                self.mainView.childrenTableView.beginUpdates()
                self.mainView.childrenTableView.endUpdates()
            }
        }
        mainView.addChildButton.isEnabled = self.child.count < 5  ? true : false
        mainView.addChildButton.imageView?.alpha = self.child.count < 5  ? 1.0 : 0.2
        if child.isEmpty {
            isChildrenAdded(status: false)
        }
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: .zero, options: [.curveEaseOut], animations: {
            self.mainView.deleteAllChildButtonStackView.isHidden = true
            self.mainView.deleteAllChildButtonStackView.alpha = .zero
            self.mainView.stackView.layoutIfNeeded()
        }, completion: { _ in
            self.mainView.stackView.removeArrangedSubview(self.mainView.deleteAllChildButtonStackView)
            self.mainView.deleteAllChildButtonStackView.removeFromSuperview()
        })
    }
    
    private func clearData() {
        UIView.animate(withDuration: 0.5) {
            self.mainView.childrenTableView.alpha = .zero
            self.mainView.deleteAllChildButtonStackView.alpha = .zero
        } completion: { _ in
            self.child.removeAll()
            DispatchQueue.main.async {
                UIView.performWithoutAnimation({
                    self.mainView.childrenTableView.reloadSections(IndexSet(integer: .zero), with: .none)
                    self.mainView.childrenTableView.beginUpdates()
                    self.mainView.childrenTableView.endUpdates()
                })
            }
            self.isChildrenAdded(status: false)
            self.mainView.addChildButton.isEnabled = true
            self.mainView.addChildButton.imageView?.alpha = 1.0
            self.mainView.stackView.removeArrangedSubview(self.mainView.deleteAllChildButtonStackView)
            self.mainView.deleteAllChildButtonStackView.removeFromSuperview()
        }
    }
    
    private func isChildrenAdded(status: Bool) {
        switch status {
        case true:
            mainView.noChildrenTitle.removeFromSuperview()
        case false:
            mainView.noChildrenTitle.alpha = .zero
            mainView.addSubview(mainView.noChildrenTitle)
            NSLayoutConstraint.activate([
                mainView.noChildrenTitle.centerYAnchor.constraint(equalTo: mainView.childrenTableView.centerYAnchor),
                mainView.noChildrenTitle.centerXAnchor.constraint(equalTo: mainView.childrenTableView.centerXAnchor)
            ])
            UIView.animate(withDuration: 0.5) {
                self.mainView.noChildrenTitle.alpha = 1.0
            }
        }
    }
}

extension MainViewController: MainViewDelegate {
    
    func addChildButtonTapped(sender: UIButton) {
        hideKeyboard()
        sender.pulsate(from: 1.0, to: 0.9, speed: 2.0, reverse: true, completion: {
            self.add(sender: sender)
        })
    }
    
    func deleteChildButtonTapped(sender: UIButton) {
        hideKeyboard()
        let position: CGPoint = sender.convert(.zero, to: self.mainView.childrenTableView)
        let indexPath = self.mainView.childrenTableView.indexPathForRow(at: position) ?? IndexPath(row: .zero, section: .zero)
        sender.pulsate(from: 1.0, to: 0.9, speed: 2.0, reverse: true, completion: {
            self.delete(indexPath: indexPath)
        })
    }
    
    func deleteAllChildButtonTapped(sender: UIButton) {
        hideKeyboard()
        sender.pulsate(from: 1.0, to: 0.9, speed: 2.0, reverse: true, completion: {
            self.showAlert()
        })
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? ChildrenTableViewCell)?.configure(name: child[indexPath.row].name, age: child[indexPath.row].age)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0.fit
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: nil, handler: { (action, view, completionHandler) in
            self.delete(indexPath: indexPath)
            completionHandler(true)
        })
        delete.image = UIImage(systemName: "trash")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        delete.backgroundColor = .systemGray6
        var configuration = UISwipeActionsConfiguration()
        configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let position: CGPoint = textField.convert(.zero, to: mainView.childrenTableView)
        let indexPath = mainView.childrenTableView.indexPathForRow(at: position)
        guard indexPath != nil else { return }
        let cell = mainView.childrenTableView.cellForRow(at: indexPath!) as! ChildrenTableViewCell
        if textField == cell.nameTextField {
            child[indexPath!.row].name = textField.text ?? ""
        } else if textField == cell.ageTextField {
            child[indexPath!.row].age = Int(textField.text ?? "") ?? .zero
        }
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                self.mainView.childrenTableView.reloadSections(IndexSet(integer: .zero), with: .none)
                self.mainView.childrenTableView.beginUpdates()
                self.mainView.childrenTableView.endUpdates()
            }
        }
    }
}

extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        hideKeyboard()
    }
}
