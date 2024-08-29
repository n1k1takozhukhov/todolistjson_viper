import UIKit

protocol AddViewProtocol: AnyObject {
    func displaySuccess()
    func displayError(_ message: String)
}

final class AddViewController: UIViewController {
    
    var presenter: AddPresenterProtocol?
    var rootPresenter: ToDoListPresenter?
    
    private let toDoTitleLabel = makeTitleLabel()
    private let titleTextField = makeTextField()
    private let dateTitleLabel = makeTitleLabel()
    private let dateTextField = makeTextField()
    private let datePicker = makeDatePicker()
    private let descriptionTitleLabel = makeTitleLabel()
    private let descriptionTextView = makeTextView()
    private lazy var saveButton = makeButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        updateUI()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    private func updateUI() {
        title = "Add View"
        view.backgroundColor = .systemBackground
        toDoTitleLabel.text = "title".uppercased()
        titleTextField.placeholder = "Enter title"
        dateTitleLabel.text = "date".uppercased()
        dateTextField.placeholder = "Enter date"
        dateTextField.inputView = datePicker
        descriptionTitleLabel.text = "description".uppercased()
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.didTapSaveToDo()
        }, for: .touchUpInside)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    private func didTapSaveToDo() {
        guard let title = titleTextField.text, !title.isEmpty else {
            displayError("Title cannot be empty")
            return
        }
        
        presenter?.saveToDo(title: title, createdDate: datePicker.date, description: descriptionTextView.text ?? "")
    }
    
    @objc private func dismissKeyboard() {
        titleTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
}

extension AddViewController: AddViewProtocol {
    func displaySuccess() {
        dismiss(animated: true, completion: { self.rootPresenter?.fetchToDos() })
    }
    
    func displayError(_ message: String) {
        print("Error adding todo")
    }
}


private extension AddViewController {
    func setupConstraint() {
        setupTitleTextField()
        setupDateTextField()
        setupDescriptionTextView()
        setupSaveButton()
    }
    
    func setupTitleTextField() {
        view.addSubview(toDoTitleLabel)
        view.addSubview(titleTextField)
        
        NSLayoutConstraint.activate([
            toDoTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            toDoTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toDoTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleTextField.topAnchor.constraint(equalTo: toDoTitleLabel.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: toDoTitleLabel.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: toDoTitleLabel.trailingAnchor)
        ])
    }
    
    func setupDateTextField() {
        view.addSubview(dateTitleLabel)
        view.addSubview(dateTextField)
        
        NSLayoutConstraint.activate([
            dateTitleLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            dateTitleLabel.leadingAnchor.constraint(equalTo: toDoTitleLabel.leadingAnchor),
            dateTitleLabel.trailingAnchor.constraint(equalTo: toDoTitleLabel.trailingAnchor),
            
            dateTextField.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 10),
            dateTextField.leadingAnchor.constraint(equalTo: toDoTitleLabel.leadingAnchor),
            dateTextField.trailingAnchor.constraint(equalTo: toDoTitleLabel.trailingAnchor)
        ])
    }
    
    func setupDescriptionTextView() {
        view.addSubview(descriptionTitleLabel)
        view.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            descriptionTitleLabel.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 20),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: toDoTitleLabel.leadingAnchor),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: toDoTitleLabel.trailingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: toDoTitleLabel.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: toDoTitleLabel.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupSaveButton() {
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: toDoTitleLabel.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: toDoTitleLabel.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

private extension AddViewController {
    static func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18)
        return view
    }
    
    static func makeTextField() -> UITextField {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.borderStyle = .roundedRect
        view.font = .systemFont(ofSize: 16)
        return view
    }
    
    static func makeTextView() -> UITextView {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16)
        view.isScrollEnabled = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        return view
    }
    
    func makeButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        return button
    }
    
    static func makeDatePicker() -> UIDatePicker {
        let view = UIDatePicker()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .wheels
        view.backgroundColor = .systemBackground
        view.tintColor = .blue
        return view
    }
}
