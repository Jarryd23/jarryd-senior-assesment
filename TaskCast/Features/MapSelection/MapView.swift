import SwiftUI
import MapKit

protocol MapSelectionDelegate {
    func didSelect(coordinate: CLLocationCoordinate2D)
}

public struct MapView: View {
    @State private var selectedCoordinate: CLLocationCoordinate2D? = nil
    @Environment(\.dismiss) private var dismiss
    var delegate: MapSelectionDelegate?
    
    public var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                MapReader { proxy in
                    Map{
                        if let selectedCoordinate {
                            Marker("", coordinate: selectedCoordinate)
                        }
                    }
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            withAnimation {
                                selectedCoordinate = coordinate
                            }
                        }
                    }
                }
                if let selectedCoordinate {
                    TaskCastPrimaryButton(buttonText: "Confirm Location") {
                        delegate?.didSelect(coordinate: selectedCoordinate)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MapView()
}
