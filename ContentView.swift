import SwiftUI

struct ContentView: View {
    @State private var currentDate = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Analog Clock")
                .font(.largeTitle)
                .padding()
            
            ClockView(currentDate: $currentDate)
                .frame(width: 300, height: 300)
                .onReceive(timer) { _ in
                    self.currentDate = Date()
                }
        }
    }
}

struct ClockView: View {
    @Binding var currentDate: Date
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black, lineWidth: 3)
            
            ForEach(0..<12) { index in
                Text("\(index + 1)")
                    .font(.system(size: 20))
                    .offset(y: -130)
                    .rotationEffect(.degrees(Double(index) * 30), anchor: .bottom)
            }
            
            ClockHand(type: .hour, currentDate: currentDate)
            ClockHand(type: .minute, currentDate: currentDate)
            ClockHand(type: .second, currentDate: currentDate)
        }
    }
}

struct ClockHand: View {
    enum HandType {
        case hour, minute, second
    }
    
    var type: HandType
    var currentDate: Date
    
    var body: some View {
        let calendar = Calendar.current
        let rotation: Double
        
        switch type {
        case .hour:
            let hour = calendar.component(.hour, from: currentDate) % 12
            let minute = calendar.component(.minute, from: currentDate)
            rotation = (Double(hour) * 60 + Double(minute)) / 720 * 360
        case .minute:
            let minute = calendar.component(.minute, from: currentDate)
            let second = calendar.component(.second, from: currentDate)
            rotation = (Double(minute) * 60 + Double(second)) / 3600 * 360
        case .second:
            let second = calendar.component(.second, from: currentDate)
            rotation = Double(second) / 60 * 360
        }
        
        return RoundedRectangle(cornerRadius: 2)
            .fill(type == .second ? Color.red : Color.black)
            .frame(width: type == .second ? 1 : 4, height: type == .hour ? 60 : 90)
            .offset(y: type == .hour ? -30 : -45)
            .rotationEffect(.degrees(rotation))
            .shadow(radius: 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
