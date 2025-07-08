import SwiftUI

struct SolarPositionTemperatureView: View {
    var location: String
    var temperature: String
    var lineWidth: CGFloat = 20
    var localTime: Date
    var sunrise: String
    var sunset: String
    var progress: CGFloat {
        solarProgressBetween(start: sunrise, end: sunset, referenceTime: localTime)
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
                    .animation(.bouncy(duration: 2))
            }.overlay {
                VStack {
                    Text(location)
                        .frame(alignment: .top)
                        .font(.system(size: 35, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text("\(temperature)°C")
                        .font(.system(size: 50, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .frame(alignment: .bottom)
                }
            }
            
            HStack {
                Text("\(Image(systemName: "sunrise.fill")) \(sunrise)")
                    .font(.system(size: 16, weight: .bold, design: .default)).bold()
                Spacer()
                Text("\(sunset) \(Image(systemName: "sunset.fill"))")
                    .font(.system(size: 16, weight: .bold, design: .default)).bold()
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
