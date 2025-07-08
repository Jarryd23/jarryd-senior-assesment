import SwiftUI
import CoreLocation
import MapKit
import SimpleToast

struct OnboardingView<ViewModel: OnboardingViewModel>: View {
    @StateObject private var viewModel: ViewModel
    @State private var showMapPicker  = false
    
    init(viewmodel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewmodel)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                VStack(spacing: 4) {
                    Image(viewModel.headerImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                        .padding(.bottom, 50)
                    Text(viewModel.title)
                        .font(.largeTitle).bold()
                        .multilineTextAlignment(.center)
                    
                    Text(viewModel.subtitle)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Text(viewModel.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    TaskCastPrimaryButton(buttonText: viewModel.primaryCTATitle) {
                        viewModel.primaryAction()
                    }
                    
                    Button(viewModel.secondaryCTATitle) {
                        showMapPicker.toggle()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .cornerRadius(20)
                    .sheet(isPresented: $showMapPicker) {
                        DependecyContainer.shared.rootComponent.mapSelectionView
                    }
                }
                .padding(.top, 8)
            }
            .padding()
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
}
