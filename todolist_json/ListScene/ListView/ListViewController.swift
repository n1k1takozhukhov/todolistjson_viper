import UIKit

final class ToDoListViewController: UIViewController {
    
    var presenter: ToDoListPresenter?
    var todo: [ToDoItem] = []
    
    private lazy var tableView = makeTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstrain()
        updateUI()
        presenter?.viewDidLoad()
    }
    
    private func updateUI() {
        title = "ToDo List"
        view.backgroundColor = .systemBackground
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        let actionRightBarButtonItem = UIAction(title: "", image: UIImage(systemName: "envelope")) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.showAddToDo()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(primaryAction: actionRightBarButtonItem)
    }
}

extension ToDoListViewController: ToDoListViewProtocol {
    func showToDos(_ toDos: [ToDoItem]) {
        self.todo = toDos
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        print("Error showing todos.")
    }
}

//MARK: - UITableView
extension ToDoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        
        let todo = todo[indexPath.row]
        cell.configure(with: todo)
        return cell
    }
}

extension ToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedToDo = todo[indexPath.row]
        presenter?.showEditToDo(for: selectedToDo)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let toDoToDelete = self.todo[indexPath.row]
            self.presenter?.deleteToDoItem(toDoToDelete)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let todo = todo[indexPath.row]
        let completeAction = UIContextualAction(style: .normal, title: "Completed") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            self.presenter?.toggleComplete(todo)
            completionHandler(true)
        }
        completeAction.backgroundColor = todo.isCompleted ? .systemGray2 : .systemGreen
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
}

extension ToDoListViewController {
    func didAddToDo() {
        presenter?.fetchToDos()
    }
}

private extension ToDoListViewController {
    func setupConstrain() {
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

private extension ToDoListViewController {
    func makeTableView() -> UITableView {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
