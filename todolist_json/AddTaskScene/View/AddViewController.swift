import UIKit


// MARK: - Protocols

protocol AddViewProtocol: AnyObject {
    func displaySuccess()
    func displayError(_ message: String)
}


// MARK: - ViewController

class AddViewController: UIViewController {
    
    var presenter: AddPresenterProtocol?
    var rootPresenter: ToDoListPresenter?
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter title"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add New ToDo"
        view.backgroundColor = .white
        
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(saveButton)
        
        setupConstraints()
        
        saveButton.addTarget(self, action: #selector(saveToDo), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
    @objc private func saveToDo() {
        guard let title = titleTextField.text, !title.isEmpty else {
            displayError("Title cannot be empty")
            return
        }
        presenter?.saveToDo(title: title, description: descriptionTextView.text ?? "")
    }
    
    @objc private func dismissKeyboard() {
        titleTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
}


// MARK: - AddToDoView

extension AddViewController: AddViewProtocol {
    func displaySuccess() {
        dismiss(animated: true, completion: { self.rootPresenter?.fetchToDos() })
    }
    
    func displayError(_ message: String) {
        print("Error adding todo")
    }
}
