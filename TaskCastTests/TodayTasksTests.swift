import XCTest
import Combine
@testable import TaskCast

final class TodayTaskViewModelTests: XCTestCase {
    var mockProvider: MockTaskProvider!
    var viewModel: ConcreteTodayTaskViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockProvider = MockTaskProvider()
        viewModel = ConcreteTodayTaskViewModel(taskProvider: mockProvider)
    }
    
    override func tearDown() {
        mockProvider = nil
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testTasksDueTodayAreFilteredCorrectly() {
        let tasks = [
            ToDoTask(id: "1", title: "Due Today", description: "", dueDate: Date(), isCompleted: true),
            ToDoTask(id: "2", title: "Due Tomorrow", description: "", dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, isCompleted: true),
            ToDoTask(id: "3", title: "Due Yesterday", description: "", dueDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, isCompleted: true)
        ]

        let expect = expectation(description: "Only today's task")

        viewModel.$tasksDueToday
            .filter { !$0.isEmpty }
            .sink { displayed in
                XCTAssertEqual(displayed.count, 1)
                XCTAssertEqual(displayed.first?.title, "Due Today")
                expect.fulfill()
            }
            .store(in: &cancellables)

        mockProvider.send(tasks)

        wait(for: [expect], timeout: 1)
    }
}

class MockTaskProvider: TaskProvider {
    private let subject = PassthroughSubject<[ToDoTask], Never>()
    var tasksPublisher: AnyPublisher<[TaskCast.ToDoTask], Never> {
        subject.eraseToAnyPublisher()
    }
    
    func addTask(task: TaskCast.ToDoTask) {}
    func getAllTasks() -> [TaskCast.ToDoTask] {[]}
    func deleteTask(id: String) {}
    func updateTaskStatus(for id: String, to completed: Bool) {}
    func observeTasks() {}
    func send(_ tasks: [ToDoTask]) {
        subject.send(tasks)
    }
}
