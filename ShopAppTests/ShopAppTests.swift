import XCTest
@testable import ShopApp

final class ShopAppTests: XCTestCase {
  
  var dataBus: DataBus!
  
  override func setUpWithError() throws {
    // Инициализация DataBus перед каждым тестом
    dataBus = DataBus()
  }
  
  override func tearDownWithError() throws {
    // Удаление DataBus после каждого теста
    dataBus = nil
  }
  
  func testAddProduct() throws {
    let product = Product(name: "Test Product", price: 10.0)
    
    // Проверяем, что корзина пуста
    XCTAssertEqual(dataBus.cartItems[product], nil)
    
    // Добавляем продукт
    Bus.send(.addToCart, product)
    
    // Проверяем, что продукт был добавлен
    XCTAssertEqual(dataBus.cartItems[product], 1)
    
    // Добавляем продукт снова
    Bus.send(.addToCart, product)
    
    // Проверяем, что количество продукта увеличилось
    XCTAssertEqual(dataBus.cartItems[product], 2)
  }
  
  func testRemoveProduct() throws {
    let product = Product(name: "Test Product", price: 10.0)
    
    // Добавляем продукт
    Bus.send(.addToCart, product)
    Bus.send(.addToCart, product)
    
    // Проверяем, что количество продукта равно 2
    XCTAssertEqual(dataBus.cartItems[product], 2)
    
    // Удаляем продукт
    Bus.send(.removeFromCart, product)
    
    // Проверяем, что количество продукта уменьшилось
    XCTAssertEqual(dataBus.cartItems[product], 1)
    
    // Удаляем продукт снова
    Bus.send(.removeFromCart, product)
    
    // Проверяем, что продукт был удален
    XCTAssertEqual(dataBus.cartItems[product], nil)
  }
  
  func testRemoveNonExistentProduct() throws {
    let product = Product(name: "Test Product", price: 10.0)
    
    // Проверяем, что корзина пуста
    XCTAssertEqual(dataBus.cartItems[product], nil)
    
    // Пытаемся удалить несуществующий продукт
    Bus.send(.removeFromCart, product)
    
    // Проверяем, что корзина все еще пуста
    XCTAssertEqual(dataBus.cartItems[product], nil)
  }
}
