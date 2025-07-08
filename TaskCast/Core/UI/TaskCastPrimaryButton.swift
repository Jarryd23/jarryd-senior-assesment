import SwiftUI

struct TaskCastPrimaryButton: View {
    var buttonText: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(buttonText)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(uiColor: .orange))
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding()
        }
    }
}
