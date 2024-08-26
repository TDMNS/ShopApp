import SwiftUI
import Combine

@main
struct ShopAppApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      TabView {
        ProductsView()
          .tabItem {
            Label("Menu", systemImage: "list.dash")
          }
        
        CartView()
          .tabItem {
            Label("Cart", systemImage: "cart")
          }
      }
      .onAppear() {
        Bus.send(K.didLaunch, true)
      }
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  let cartService = CartService()
  let productsService = ProductsService()
  let initialProducts = ["Apple": 0, "Banana": 0, "Orange": 0]
  private var subscriptions = Set<AnyCancellable>()
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    Bus.receiveAsync(&subscriptions, [K.didLaunch]) { [weak self] (_, v: Bool) in
      Bus.send(K.initialProducts, self?.initialProducts ?? [])
    }
    return true
  }
}
