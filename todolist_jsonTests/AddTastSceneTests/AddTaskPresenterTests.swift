import XCTest
@testable import todolist_json

class AddTaskPresenterTests: XCTestCase {
    
    var presenter: AddTaskPresenter!
    var mockView: MockAddView!
    var mockInteractor: MockAddInteractor!
    
    override func setUp() {
        super.setUp()
        mockView = MockAddView()
        mockInteractor = MockAddInteractor()
        presenter = AddTaskPresenter(view: mockView, interactor: mockInteractor)
        mockInteractor.output = presenter
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        super.tearDown()
    }
    
    func testSaveToDoCallsInteractor() {
        let title = "Test Title"
        let date = Date()
        let description = "Test Description"
        presenter.saveToDo(
            title: title,
            createdDate: date,
            description: description)
        
        XCTAssertTrue(mockInteractor.addToDoItemCalled, "addToDoItem() должно быть вызвано")
        XCTAssertEqual(mockInteractor.title, title, "Заголовок должен совпадать")
        XCTAssertEqual(mockInteractor.createdDate, date, "Дата должна совпадать")
        XCTAssertEqual(mockInteractor.description, description, "Описание должно совпадать")
    }
    
    func testDidAddToDoCallsDisplaySuccess() {
        presenter.didAddToDo()
        XCTAssertTrue(mockView.successCalled, "displaySuccess() должно быть вызвано")
    }
    
    func testDidFailToAddToDoCallsDisplayError() {
        let error = NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test Error"])
        presenter.didFailToAddToDo(with: error)
        
        XCTAssertTrue(mockView.errorCalled, "displayError() должно быть вызвано")
        XCTAssertEqual(mockView.errorMessage, "Test Error", "Сообщение об ошибке должно совпадать")
    }
}
