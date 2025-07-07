import SwiftUI

struct SolarPositionTemperatureView: View {
    var location: String
    var temperature: String
    var lineWidth: CGFloat = 20
    var sunrise: String
    var sunset: String
    var progress: CGFloat {
        solarProgressBetween(start: sunrise, end: sunset)
    }
    
    var body: some View {
        
        VStack {
            ZStack {
                HalfCircleShape()
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                    .foregroundStyle(.ultraThinMaterial.opacity(0.4))
                    .padding()
                HalfCircleShape().trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                    .foregroundStyle(.white)
                    .padding()
            }.overlay {
                VStack {
                    Text(location)
                        .frame(alignment: .top)
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                    Spacer()
                    Text(temperature)
                        .font(.system(size: 50, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .frame(alignment: .bottom)
                }
            }
            
            HStack {
                Text("\(Image(systemName: "sunrise.fill")) \(sunrise)")
                Spacer()
                Text("\(sunset) \(Image(systemName: "sunset.fill"))")
            }
            .foregroundStyle(.white)
        }
    }
}

private struct HalfCircleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.maxY),
            radius: rect.width / 2,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        return path
    }
}
