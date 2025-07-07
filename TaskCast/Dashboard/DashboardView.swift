import SwiftUI

struct DashboardView<ViewModel: DashboardViewModel,
                     TaskView: View>: View {
    @StateObject private var viewModel: ViewModel
    @Environment(\.colorScheme) private var colorScheme
    var taskView: TaskView
    
    init(viewModel: ViewModel,
         taskView: TaskView) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.taskView = taskView
    }
    
    var body: some View {
        List {
            Section {
                SolarPositionTemperatureView(location: viewModel.locationName,
                                             temperature: viewModel.temperature,
                                             sunrise: viewModel.sunrise,
                                             sunset: viewModel.sunset)
                .frame(height: 280)
                .padding()
            }
            .listRowBackground(Color.clear)
            taskView
        }
        .refreshable {
            await viewModel.fetchWeatherData()
        }
        .background {
            LinearGradient(gradient: Gradient(colors: SkyColor.dusk.rawValue), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    //DashboardView()
}
