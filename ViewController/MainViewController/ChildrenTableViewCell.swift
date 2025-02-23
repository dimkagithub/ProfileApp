//
//  ChildrenTableViewCell.swift
//  ProfileApp
//
//  Created by Дмитрий on 21.02.2025.
//

import UIKit

final class ChildrenTableViewCell: UITableViewCell {
    
    weak var delegate: MainViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(name: String, age: Int) {
        self.nameTextField.text = name
        self.ageTextField.text = age == .zero ? "" : String(age)
    }
    
    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    private func addSubviews() {
        contentView.addSubview(stackView)
    }
    
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
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
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
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
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
        var view = UIStackView(arrangedSubviews: [nameTextFieldStackView, ageTextFieldStackView])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 20.0.fit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var deleteChildButton: UIButton = {
        var view = UIButton()
        view.configuration = .plain()
        view.configuration?.baseForegroundColor = .systemBlue
        view.configuration?.background.backgroundColor = .clear
        view.configuration?.title = "Удалить"
        view.configuration?.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { container in
            var transformer = container
            transformer.font = UIFont.systemFont(ofSize: 16.0.fit)
            return transformer
        }
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.heightAnchor.constraint(equalToConstant: 50.0.fit).isActive = true
        view.addTarget(self, action: #selector(deleteChildButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deleteChildButtonStackView: UIStackView = {
        var view = UIStackView(arrangedSubviews: [deleteChildButton, UIView()])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        var view = UIStackView(arrangedSubviews: [textFieldStackView, deleteChildButtonStackView])
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0.fit),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.0.fit)
        ])
    }
    
    @objc func deleteChildButtonTapped(sender: UIButton) {
        delegate?.deleteChildButtonTapped(sender: sender)
    }
}
