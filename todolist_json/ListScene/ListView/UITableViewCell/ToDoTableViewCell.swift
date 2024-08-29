import UIKit

final class ToDoTableViewCell: UITableViewCell {
    
    static let identifier = "ToDoTableViewCell"
    
    private let titleLabel = makeTextLabel()
    private let descriptionLabel = makeTextLabel()
    private let dateLabel = makeTextLabel()
    private let completedImage = makeCompletedImage()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstrain()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
        titleLabel.font = .systemFont(ofSize: 18)
        completedImage.image = UIImage(systemName: "paperplane")
    }
    
    func configure(with todo: ToDoItem) {
        titleLabel.text = todo.title
        descriptionLabel.text = todo.todoDescription
        let buttonImageName = todo.isCompleted ? "paperplane.fill" : "paperplane"
        completedImage.image = UIImage(systemName: buttonImageName)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateLabel.text = dateFormatter.string(from: todo.createdDate ?? Date())
    }
}

private extension ToDoTableViewCell {
    func setupConstrain() {
        setupCompletedImage()
        setupTitleLabel()
        setupDescriptionLabel()
        setupDateLabelLabel()
    }
    
    func setupCompletedImage() {
        contentView.addSubview(completedImage)
        
        NSLayoutConstraint.activate([
            completedImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            completedImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
    }
    
    func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: completedImage.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    func setupDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: completedImage.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    func setupDateLabelLabel() {
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}


private extension ToDoTableViewCell {
    static func makeTextLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14)
        view.numberOfLines = 0
        return view
    }
    
    static func makeCompletedImage() -> UIImageView {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return view
    }
}
