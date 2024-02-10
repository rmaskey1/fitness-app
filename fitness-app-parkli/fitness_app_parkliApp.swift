import SwiftUI

// Extension to allow hex color values
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let rgbValue = UInt32(hex, radix: 16)
        let r = Double((rgbValue! & 0xFF0000) >> 16) / 255
        let g = Double((rgbValue! & 0x00FF00) >> 8) / 255
        let b = Double(rgbValue! & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// Sets app's starting color scheme
// Allows for color data to be stored
class AppSettings: ObservableObject {
    @AppStorage("backgroundColor") var backgroundColor: String = "35413D"
    @AppStorage("calorieColor") var calorieColor: String = "FF5326"
    @AppStorage("stepColor") var stepColor: String = "A72AFF"
    @AppStorage("exerciseColor") var exerciseColor: String = "21FFE6"
}

/* Navigation and page setup for each view in the app
 *     - FirstOnboadingScreenView and SecondOnboardingScreenView make up the welcome/onboarding portion
 *     - ProgressSlidersView is the main content screen
 *     - SettingsView is the settings page
 */
struct NavView: View {
    @State private var currentPage: Int = 0
    @StateObject private var settings = AppSettings() // Stores setting for instance of app

    var body: some View {
        NavigationView {
            TabView(selection: $currentPage) {
                FirstOnboardingScreenView(goToNextPage: {
                    withAnimation { // Allows swipe between FirstOnboadingScreenView and SecondOnboardingScreenView
                        currentPage = 1
                    }
                })
                .tag(0)

                SecondOnboardingScreenView()
                    .tag(1)
                
                ProgressSlidersView() // Main content screen
                    .tag(2)
                    .environmentObject(settings)

                SettingsView() // Settings screen
                    .tag(3)
                    .environmentObject(settings)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .background(Color(hex: settings.backgroundColor).ignoresSafeArea())

            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(settings)
        }
    }
}

// First onboarding screen
struct FirstOnboardingScreenView: View {
    var goToNextPage: () -> Void

    var body: some View {
        // All the main content of this screen
        VStack {
            Text("Set Your Daily...")
                .font(.system(size: 36, weight: .heavy))
                .foregroundColor(Color(hex: "C3FF61"))

            Image(systemName: "flame.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(Color(hex: "FF5326"))

            Text("Calorie Goal")
                .font(.system(size: 28, weight: .heavy))
                .foregroundColor(Color(hex: "C3FF61"))
                .padding(.bottom, 30)
            
            Image("icons8-shoe-print-100")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .font(.title)
                .colorMultiply(Color(hex: "A72AFF"))

            Text("Step Goal")
                .font(.system(size: 28, weight: .heavy))
                .foregroundColor(Color(hex: "C3FF61"))
                .padding(.bottom, 30)

            Image(systemName: "figure.walk.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .font(.title)
                .foregroundColor(Color(hex: "21FFE6"))
                
            Text("Exercise Goal")
                .font(.system(size: 28, weight: .heavy))
                .foregroundColor(Color(hex: "C3FF61"))

            Button(action: {
                goToNextPage() // Used to execute swiping action to the next page
            }) {
                Text("CONTINUE")
                    .font(.system(size: 36, weight: .heavy))
                    .padding(.horizontal, 60)
                    .padding(.vertical, 20)
                    .foregroundColor(Color(hex: "35413D"))
                    .background(Capsule().fill(Color(hex: "C3FF61")))
            }
            .padding(.bottom, 70)

        }
    }
}

//Second onboarding screen
struct SecondOnboardingScreenView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            VStack {
                Image(systemName: "flame.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color(hex: "FF5326"))
                    .overlay(
                        Circle()
                            .stroke(Color(hex: "FF5326"), lineWidth: 10)
                            .frame(width: 100, height: 100)
                    )
                    .padding(.bottom, 25)

                Text("Check your daily progress")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(Color(hex: "C3FF61"))
                    .padding()
            }
        
            
            HStack {
                VStack {
                    Image(systemName: "flame.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color(hex: "FF5326"))
                    Text("CALS")
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundColor(Color(hex: "C3FF61"))
                }
                Slider(value: .constant(0.5))
                    .accentColor(Color(hex: "FF5326"))
                    .padding(.horizontal)
                    .frame(width: 250)
                Text("800")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(Color(hex: "C3FF61"))
            }
            
            Text("Adjust your goals")
                .font(.system(size: 20, weight: .heavy))
                .foregroundColor(Color(hex: "C3FF61"))
                .padding(.bottom, 30)
            
            VStack {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .font(.title)
                    .foregroundColor(Color(hex: "C3FF61"))

                Text("Customize your experience")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(Color(hex: "C3FF61"))
                    .padding(.bottom, 30)
            }
            
            // Links this page to the ProgressSlidersView page by pressing the button below
            NavigationLink(destination: ProgressSlidersView()) {
                Text("LET'S GO!")
                    .font(.system(size: 36, weight: .heavy))
                    .padding(.horizontal, 60)
                    .padding(.vertical, 20)
                    .foregroundColor(Color(hex: "35413D"))
                    .background(Capsule().fill(Color(hex: "C3FF61")))
            }
            .padding(.bottom, 75)
            
        }
    }
}

struct ProgressSlidersView: View {
    @EnvironmentObject var settings: AppSettings
    @State private var calories: Double = 800
    @State private var steps: Double = 10
    @State private var minutes: Double = 30
    
    var body: some View {
        
        VStack {
            Spacer(minLength: 70)
            
            // Navigates to the settings page when the gear icon is clicked
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color(hex: "C3FF61"))
                    .padding(.leading, 300)
            }
            .padding(-20)
           
            // Progress rings on the top half of the screen
            // Progress is represented dynamically depending on the value set by the sliders below
            VStack(spacing: 30) {
                VStack {
                    Text("Meet your goals")
                        .font(.system(size: 32, weight: .heavy))
                        .foregroundColor(Color(hex: "C3FF61"))
                        .padding(.bottom, 30)
                    ProgressRing(progress: (634/calories), color: Color(hex: settings.calorieColor))
                        .overlay(
                            Image(systemName: "flame.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color(hex: settings.calorieColor))
                        )
                    Text("634")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(Color(hex: "C3FF61"))
                    + Text("/\(String(format: "%.0f", calories))")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(Color(hex: settings.calorieColor))
                }
                HStack(spacing: 70) {
                    VStack {
                        ProgressRing(progress: (4.2/steps), color: Color(hex: settings.stepColor))
                            .overlay(
                                Image("icons8-shoe-print-100")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .colorMultiply(Color(hex: settings.stepColor))
                            )
                        Text("4.2")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(Color(hex: "C3FF61"))
                        + Text("/\(String(format: "%.0f", steps))")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(Color(hex: settings.stepColor))
                    }
                    VStack {
                        ProgressRing(progress: (15/minutes), color: Color(hex: settings.exerciseColor))
                            .overlay(
                                Image(systemName: "figure.walk.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color(hex: settings.exerciseColor))
                            )
                        Text("15")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(Color(hex: "C3FF61"))
                        + Text("/\(String(format: "%.0f", minutes))")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(Color(hex: settings.exerciseColor))
                    }
                    
                }
            }
            .padding()

            Spacer()
            
            // Sliders to set goal value for each category
            // Values of calories, steps, and minutes dynamically change to the values set by the sliders
            VStack(alignment: .center, spacing:20) {
                Text("Make your goals")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(Color(hex: "C3FF61"))
                    .padding()
                HStack {
                    VStack {
                        Image(systemName: "flame.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color(hex: settings.calorieColor))
                        Text("CALS")
                            .font(.system(size: 13, weight: .heavy))
                            .foregroundColor(Color(hex: "C3FF61"))
                    }
                    Slider(value: $calories, in: 400...1200, step: 10.0)
                        .accentColor(Color(hex: settings.calorieColor))
                        .padding(.horizontal)
                        .frame(width: 250)
                    Text("\(String(format: "%.0f", calories))")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(Color(hex: "C3FF61"))
                }
                HStack {
                    VStack {
                        Image("icons8-shoe-print-100")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .font(.title)
                            .colorMultiply(Color(hex: settings.stepColor))
                        Text("STEPS")
                            .font(.system(size: 13, weight: .heavy))
                            .foregroundColor(Color(hex: "C3FF61"))
                    }
                
                    Slider(value: $steps, in: 5...20, step: 1.0)
                        .accentColor(Color(hex: settings.stepColor))
                        .padding(.horizontal)
                        .frame(width: 250)
                    Text("\(String(format: "%.0f", steps))K")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(Color(hex: "C3FF61"))
                }
                
                HStack {
                    VStack {
                        Image(systemName: "figure.walk.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .font(.title)
                            .foregroundColor(Color(hex: settings.exerciseColor))
                        Text("MINS")
                            .font(.system(size: 13, weight: .heavy))
                            .foregroundColor(Color(hex: "C3FF61"))
                    }
                    Slider(value: $minutes, in: 0...120, step: 5.0)
                        .accentColor(Color(hex: settings.exerciseColor))
                        .padding(.horizontal)
                        .frame(width: 250)
                    Text("\(String(format: "%.0f", minutes))")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(Color(hex: "C3FF61"))
                }
                
            }
            .padding(.bottom, 70)

        }
        .frame(width: 500)
        .background(Color(hex: settings.backgroundColor)).ignoresSafeArea()
        .navigationBarTitle("My Progress", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings
    
    // Color set for background colors
    let bgColorOptions: [(name: String, hex: String)] = [
        ("Dark Green", "35413D"),
        ("Dark Blue", "3A4354"),
        ("Dark Purple", "4E4254"),
        ("Dark Red", "4B3B3B")
    ]
    
    // Color set for calorie, step, and exercise tracker colors
    let colorOptions: [(name: String, hex: String)] = [
        ("Red Orange", "FF5326"),
        ("Purple", "A72AFF"),
        ("Neon Blue", "21FFE6"),
        ("Hot Pink", "FF00D6"),
        ("Orange", "FFA900"),
        ("Neon Green", "26FF00"),
        ("Yellow", "FBFF00")
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Settings")
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundColor(Color(hex: "C3FF61"))
                    .frame(alignment: .center)
                HStack {
                    // This VStack displayed all the labels in a vertical fashion
                    VStack(alignment: .leading, spacing: 23) {
                        Spacer()
                        Text("Background")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(Color(hex: "C3FF61"))
                            .padding(.leading, 60)
                        
                        Text("Calorie Tracker")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(Color(hex: "C3FF61"))
                            .padding(.leading, 60)
                        
                        Text("Step Tracker")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(Color(hex: "C3FF61"))
                            .padding(.leading, 60)
                        
                        Text("Exercise Tracker")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(Color(hex: "C3FF61"))
                            .padding(.leading, 60)
                        
                        Spacer()
                    }
                    .padding(.leading, -20)
                    
                    // This VStack displays all color menus for the corresponding labels from above in a vertical fashion
                    VStack(alignment: .trailing) {
                        Spacer()
                        Picker("", selection: $settings.backgroundColor) {
                            // Iterates through bgColorOptions set to display all available colors for background
                            ForEach(bgColorOptions, id: \.hex) { colorOption in
                                HStack {
                                    Text(colorOption.name)
                                        .font(.system(size: 16, weight: .heavy))
                                        .foregroundColor(Color(hex: "C3FF61"))
                                    Spacer()
                                }
                                .tag(colorOption.hex)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        // Iterates through colorOptions set to display all available colors for calorie tracker
                        Picker("", selection: $settings.calorieColor) {
                            ForEach(colorOptions, id: \.hex) { colorOption in
                                HStack {
                                    Text(colorOption.name)
                                        .font(.system(size: 16, weight: .heavy))
                                        .foregroundColor(Color(hex: "C3FF61"))
                                    Spacer()
                                }
                                .tag(colorOption.hex)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        
                        // Iterates through colorOptions set to display all available colors for step tracker
                        Picker("", selection: $settings.stepColor) {
                            ForEach(colorOptions, id: \.hex) { colorOption in
                                HStack {
                                    Text(colorOption.name)
                                        .font(.system(size: 16, weight: .heavy))
                                        .foregroundColor(Color(hex: "C3FF61"))
                                    Spacer()
                                }
                                .tag(colorOption.hex)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        // Iterates through colorOptions set to display all available colors for exercise tracker
                        Picker("", selection: $settings.exerciseColor) {
                            ForEach(colorOptions, id: \.hex) { colorOption in
                                HStack {
                                    Text(colorOption.name)
                                        .font(.system(size: 16, weight: .heavy))
                                        .foregroundColor(Color(hex: "C3FF61"))
                                    Spacer()
                                }
                                .tag(colorOption.hex)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Spacer()
                    }
                    .padding(.trailing, 30)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: settings.backgroundColor))
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}


// ProgressRing component used in ProgressSlidersView for the progress ring elements used for the calorie, step, and exercise trackers
struct ProgressRing: View {
    var progress: Double
    var color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
                .foregroundColor(Color.gray)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear(duration: 0.5)) // Deprecated but still displays an animation
        }
        .frame(width: 100, height: 100)
    }
}

// App start
@main
struct OnboardingApp: App {
    @StateObject private var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            NavView()
                .environmentObject(settings)
        }
    }
}

