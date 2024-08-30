import XCTest
@testable import todolist_json

class EditPresenterTests: XCTestCase {
    
    var presenter: EditPresenter!
    var mockView: MockEditView!
    var mockInteractor: MockEditInteractor!
    
    override func setUp() {
        super.setUp()
        mockView = MockEditView()
        mockInteractor = MockEditInteractor()
        presenter = EditPresenter(view: mockView, interactor: mockInteractor)
        mockInteractor.output = presenter
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        super.tearDown()
    }

    
    func testDidUpdateToDoCallsDisplaySuccess() {
        presenter.didUpdateToDo()
        XCTAssertTrue(mockView.successCalled, "displaySuccess() должно быть вызвано")
    }
    
    func testDidFailToUpdateToDoCallsDisplayError() {
        let error = NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test Error"])
        presenter.didFailToUpdateToDo(with: error)
        
        XCTAssertTrue(mockView.errorCalled, "displayError() должно быть вызвано")
        XCTAssertEqual(mockView.errorMessage, "Test Error", "Сообщение об ошибке должно совпадать")
    }
}
