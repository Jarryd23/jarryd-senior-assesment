import SwiftUI
import SimpleToast

struct DashboardView<ViewModel: DashboardViewModel,
                     TaskView: View>: View {
    @StateObject private var viewModel: ViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var showMapSelection: Bool = false
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
                                             localTime: viewModel.localTime,
                                             sunrise: viewModel.sunrise,
                                             sunset: viewModel.sunset)
                .frame(height: 250)
                .padding()
            }
            .listRowBackground(Color.clear)
            taskView
        }
        .onAppear {
            Task {
                await viewModel.fetchWeatherData()
            }
        }
        .refreshable {
            await viewModel.fetchWeatherData()
        }
        .background {
            LinearGradient(gradient: Gradient(colors: [.skyTop, .skyBottom]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        }
        .scrollContentBackground(.hidden)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showMapSelection.toggle()
                }) {
                    Image(systemName: "globe.europe.africa.fill")
                }
            }
        }
        .sheet(isPresented: $showMapSelection) {
            DependecyContainer.shared.rootComponent.mapSelectionView
        }
        .simpleToast(isPresented: $viewModel.isError, options: SimpleToastOptions(hideAfter: 5)) {
            Label("An error occured while fetching data", systemImage: "exclamationmark.triangle")
                .padding()
                .background(Color.red.opacity(0.8))
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .padding(.top)
        }
    }
}
