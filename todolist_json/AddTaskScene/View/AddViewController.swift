import UIKit

protocol AddViewProtocol: AnyObject {
    func displaySuccess()
    func displayError(_ message: String)
}

final class AddViewController: UIViewController {
    
    var presenter: AddPresenterProtocol?
    var rootPresenter: ToDoListPresenter?
    
    private let titleTextField = makeTextField()
    private let descriptionTextView = makeTextView()
    private lazy var saveButton = makeButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        updateUI()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    private func updateUI() {
        title = "Add View"
        view.backgroundColor = .white
        titleTextField.placeholder = "Enter title"
        saveButton.setTitle("Save", for: .normal)
        saveButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.didTapSaveToDo()
            displaySuccess()
        }, for: .touchUpInside)
    }
    
    private func didTapSaveToDo() {
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
        setupDescriptionTextView()
        setupSaveButton()
    }
    
    func setupTitleTextField() {
        view.addSubview(titleTextField)

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupDescriptionTextView() {
        view.addSubview(descriptionTextView)
 
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupSaveButton() {
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}

private extension AddViewController {
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
}
