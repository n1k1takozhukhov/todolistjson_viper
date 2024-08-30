import XCTest
@testable import todolist_json

class ToDoListPresenterTests: XCTestCase {
    
    var presenter: ToDoListPresenter!
    var mockView: MockToDoListView!
    var mockInteractor: MockToDoListInteractor!
    var mockRouter: MockToDoListRouter!
    
    override func setUp() {
        super.setUp()
        mockView = MockToDoListView()
        mockInteractor = MockToDoListInteractor()
        mockRouter = MockToDoListRouter()
        presenter = ToDoListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testViewDidLoadCallsFetchToDos() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockInteractor.didFetchToDo, "viewDidLoad() should call fetchToDos() on the interactor")
    }
    
    func testFetchToDosCallsInteractorFetchToDo() {
        presenter.fetchToDos()
        XCTAssertTrue(mockInteractor.didFetchToDo, "fetchToDos() should call fetchToDo() on the interactor")
    }
    
    func testShowAddToDoCallsRouter() {
        presenter.showAddToDo()
        XCTAssertTrue(mockRouter.didShowAddToDoViewController, "showAddToDo() should call AddToDoViewController() on the router")
    }
    
    func testDidFailToFetchToDosCallsViewShowError() {
        let dummyError = NSError(domain: "", code: 0, userInfo: nil)
        presenter.didFailToFetchToDos(with: dummyError)
        XCTAssertTrue(mockView.didShowError, "didFailToFetchToDos(with:) should call showError(_:) on the view")
    }
    
    func testDidUpdateToDoCallsFetchToDos() {
        presenter.didUpdateToDo()
        XCTAssertTrue(mockInteractor.didFetchToDo, "didUpdateToDo() should call fetchToDos() on the interactor")
    }
}
