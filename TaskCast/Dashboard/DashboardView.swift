import SwiftUI

struct DashboardView: View {
    var body: some View {
        VStack {
            SolarPositionTemperatureView(title: "Johannesburg",
                                         progress: 23,
                                         minValue: 0,
                                         maxValue: 100)
                .frame(height: 300)
                .padding()
            Spacer()
            Text("Today's Tasks")
                .foregroundStyle(.white)
                .font(.largeTitle)
                .bold()
                .padding(.top)
            CurrentTaskView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: SkyColor.night.rawValue), startPoint: .top, endPoint: .bottom)
        )
    }
}

#Preview {
    DashboardView()
}

