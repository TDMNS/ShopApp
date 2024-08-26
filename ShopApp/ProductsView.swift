import SwiftUI

struct ProductsView: View {
  @StateObject private var products = BusUI.Value(K.products, [String: Int]())
  
  var body: some View {
    VStack {
      Text("Products")
      ForEach(products.v.keys.sorted(), id: \.self) { product in
        HStack {
          Text(product)
            .foregroundColor(.black)
          Spacer()
          Text("\(products.v[product] ?? 0)")
            .foregroundColor(.black)
          HStack {
            Button {
              Bus.send(K.addToCart, product)
            } label: {
              Text("+")
                .frame(width: 40, height: 40)
                .background(.green)
                .foregroundColor(.white)
                .clipShape(Circle())
            }
            
            Button {
              Bus.send(K.removeFromCart, product)
            } label: {
              Text("-")
                .frame(width: 40, height: 40)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Circle())
            }
          }
        }
        .padding(.horizontal, 15)
      }
      Spacer()
    }
    .font(.system(size: 28))
  }
}
