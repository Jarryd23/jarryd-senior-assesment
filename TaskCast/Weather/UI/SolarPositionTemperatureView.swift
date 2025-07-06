import SwiftUI

struct SolarPositionTemperatureView: View {
    var title: String
    var progress: Double
    var lineWidth: CGFloat = 20
    var minValue: CGFloat
    var maxValue: CGFloat
    var body: some View {

        VStack {
            ZStack {
                    HalfCircleShape()
                        .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                        .foregroundStyle(.gray.opacity(0.3))
                        .padding()
                    HalfCircleShape().trim(from: 0.0, to: normalizedProgress)
                        .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                        .foregroundStyle(.white)
                        .padding()
            }.overlay {
                VStack {
                    Text(String(title))
                        .frame(alignment: .top)
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                    Spacer()
                    Text(String("\(Int(progress))°C"))
                        .font(.system(size: 70, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .frame(alignment: .bottom)
                }
            }

            HStack {
                Text("\(Image(systemName: "sunrise.fill")) 7:30 AM")
                Spacer()
                Text("18:00 PM \(Image(systemName: "sunset.fill"))")
            }
            .foregroundStyle(.white)
        }
    }
    
    private var normalizedProgress: CGFloat {
        (progress - minValue) / (maxValue - minValue)
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
