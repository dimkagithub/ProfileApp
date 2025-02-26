//
//  MainView.swift
//  ProfileApp
//
//  Created by Дмитрий on 21.02.2025.
//

import UIKit

final class MainView: UIView {
    
    weak var delegate: MainViewDelegate?
    
    init(subscriber: MainViewDelegate?) {
        super.init(frame: .zero)
        
        delegate = subscriber
        addSubView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubView() {
        addSubview(stackView)
    }
    
    private lazy var personalDataTitle: UILabel = {
        var view = UILabel()
        view.font = UIFont.systemFont(ofSize: 18.0.fit)
        view.textColor = .lightGray
        view.numberOfLines = 1
        view.textAlignment = .left
        view.text = "Персональные данные"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameTitle: UILabel = {
        var view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16.0.fit)
        view.textColor = .lightGray
        view.numberOfLines = 1
        view.textAlignment = .left
        view.text = "Имя"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var nameTextField: CustomTextField = {
        var view = CustomTextField()
        view.font = UIFont.systemFont(ofSize: 18.0.fit)
        view.textColor = .white
        view.backgroundColor = .systemGray4
        view.textColor = .white
        view.tintColor = .white
        view.textAlignment = .left
        view.placeholder = "Имя"
        view.clearButtonMode = .whileEditing
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12.0.fit
        view.autocapitalizationType = .words
        view.keyboardType = .default
        view.heightAnchor.constraint(equalToConstant: 50.0.fit).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameTextFieldStackView: UIStackView = {
        var view = UIStackView(arrangedSubviews: [nameTitle, nameTextField])
        view.layoutMargins = UIEdgeInsets(top: 10.0.fit, left: 20.0.fit, bottom: 20.0.fit, right: 20.0.fit)
        view.isLayoutMarginsRelativeArrangement = true
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 10.0.fit
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12.0.fit
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1.0.fit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var ageTitle: UILabel = {
        var view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16.0.fit)
        view.textColor = .lightGray
        view.numberOfLines = 1
        view.textAlignment = .left
        view.text = "Возраст"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var ageTextField: CustomTextField = {
        var view = CustomTextField()
        view.font = UIFont.systemFont(ofSize: 18.0.fit)
        view.textColor = .white
        view.backgroundColor = .systemGray4
        view.textColor = .white
        view.tintColor = .white
        view.textAlignment = .left
        view.placeholder = "Возраст"
        view.clearButtonMode = .whileEditing
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12.0.fit
        view.autocapitalizationType = .words
        view.keyboardType = .numberPad
        view.heightAnchor.constraint(equalToConstant: 50.0.fit).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var ageTextFieldStackView: UIStackView = {
        var view = UIStackView(arrangedSubviews: [ageTitle, ageTextField])
        view.layoutMargins = UIEdgeInsets(top: 10.0.fit, left: 20.0.fit, bottom: 20.0.fit, right: 20.0.fit)
        view.isLayoutMarginsRelativeArrangement = true
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 10.0.fit
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12.0.fit
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1.0.fit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        var view = UIStackView(arrangedSubviews: [personalDataTitle, nameTextFieldStackView, ageTextFieldStackView])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 20.0.fit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var childrenTitle: UILabel = {
        var view = UILabel()
        view.font = UIFont.systemFont(ofSize: 18.0.fit)
        view.textColor = .lightGray
        view.numberOfLines = 1
        view.textAlignment = .left
        view.text = "Дети (макс. 5)"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var addChildButton: UIButton = {
        var view = UIButton()
        view.configuration = .borderedTinted()
        view.configuration?.baseForegroundColor = .white
        view.configuration?.background.backgroundColor = .systemBlue
        view.configuration?.title = "Добавить ребёнка"
        view.configuration?.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 15.0.fit, bottom: .zero, trailing: 15.0.fit)
        view.configuration?.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { container in
            var transformer = container
            transformer.font = UIFont.systemFont(ofSize: 16.0.fit)
            return transformer
        }
        view.configuration?.image = UIImage(systemName: "plus")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        view.configuration?.imagePadding = 10.0.fit
        view.configuration?.cornerStyle = .capsule
        view.heightAnchor.constraint(equalToConstant: 50.0.fit).isActive = true
        view.addTarget(self, action: #selector(addChildButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var childrenTableView: UITableView = {
        var view = UITableView()
        view.register(cell: ChildrenTableViewCell.self)
        view.contentInsetAdjustmentBehavior = .automatic
        view.isScrollEnabled = true
        view.backgroundColor = .clear
        view.separatorStyle = .singleLine
        view.separatorColor = .lightGray
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.sectionHeaderTopPadding = .zero
        view.allowsMultipleSelection = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var childrenStackView: UIStackView = {
        var view = UIStackView(arrangedSubviews: [childrenTitle, addChildButton])
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 20.0.fit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deleteAllChildButton: UIButton = {
        var view = UIButton()
        view.configuration = .borderedTinted()
        view.configuration?.baseForegroundColor = .white
        view.configuration?.background.backgroundColor = .systemRed
        view.configuration?.title = "Очистить"
        view.configuration?.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 30.0.fit, bottom: .zero, trailing: 30.0.fit)
        view.configuration?.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { container in
            var transformer = container
            transformer.font = UIFont.systemFont(ofSize: 16.0.fit)
            return transformer
        }
        view.configuration?.cornerStyle = .capsule
        view.heightAnchor.constraint(equalToConstant: 50.0.fit).isActive = true
        view.addTarget(self, action: #selector(deleteAllChildButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var deleteAllChildButtonStackView: UIStackView = {
        var view = UIStackView(arrangedSubviews: [deleteAllChildButton])
        view.layoutMargins = UIEdgeInsets(top: .zero, left: 60.0.fit, bottom: .zero, right: 60.0.fit)
        view.isLayoutMarginsRelativeArrangement = true
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var stackView: UIStackView = {
        var view = UIStackView(arrangedSubviews: [textFieldStackView, childrenStackView, childrenTableView])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 20.0.fit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var noChildrenTitle: UILabel = {
        var view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20.0.fit)
        view.textColor = .lightGray
        view.numberOfLines = .zero
        view.textAlignment = .center
        view.text = "Дети не добавлены"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.0.fit),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20.0.fit),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20.0.fit),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func addChildButtonTapped(sender: UIButton) {
        delegate?.addChildButtonTapped(sender: sender)
    }
    
    @objc func deleteAllChildButtonTapped(sender: UIButton) {
        delegate?.deleteAllChildButtonTapped(sender: sender)
    }
}
