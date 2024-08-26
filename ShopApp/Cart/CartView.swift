import SwiftUI

struct CartView: View {
  @StateObject private var products = BusUI.Value(K.cartList, [String]())
  @State private var showAlert = false
  
  var body: some View {
    VStack {
      List {
        ForEach(products.v, id: \.self) { product in
          Text(product)
        }
      }
      .font(.system(size: 28))
      Button {
        showAlert.toggle()
      } label: {
        Text("BUY")
      }
      .frame(maxWidth: .infinity, maxHeight: 60)
      .background(products.v.count > 0 ? .blue : .blue.opacity(0.3))
      .disabled(products.v.count == 0)
      .foregroundStyle(.white)
      .padding(.horizontal, 15)
      .cornerRadius(10)
      .alert(isPresented: $showAlert) {
        Alert(
          title: Text("Confirm"),
          message: Text("Are you sure you want to buy these items?"),
          primaryButton: .default(Text("Yes")) {
            Bus.send(K.clearCart, "")
          },
          secondaryButton: .cancel()
        )
      }
      Spacer()
    }
    .badge(products.v.count)
  }
}

