import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let toDoListViewController = ToDoListRouter.assembleModule()
        let navigationController = UINavigationController(rootViewController: toDoListViewController)
        window.rootViewController = navigationController
        
        self.window = window
        window.makeKeyAndVisible()
    }
}
