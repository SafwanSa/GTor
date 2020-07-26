// Kevin Li - 8:33 PM - 6/24/20

import ElegantCalendar
import ElegantPages
import SwiftUI

fileprivate let turnAnimation: Animation = .spring(response: 0.4, dampingFraction: 0.95)

class SelectionModel: ObservableObject {
    
    @Published var showCalendar = false
    @Published var calendarManager: ElegantCalendarManager = .init(configuration: .init(startDate: Date(),                                                                                        endDate: .daysFromToday(365*3)))
    
    init() {
        calendarManager.delegate = self
    }
    
}

extension SelectionModel: ElegantCalendarDelegate {
    
    func calendar(didSelectDay date: Date) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(turnAnimation) {
                self.showCalendar = false
            }
        }
    }
    
}

struct GTorCalendarView: View {
    
    @ObservedObject var model: SelectionModel = .init()
    
    var calendarManager: ElegantCalendarManager {
        model.calendarManager
    }
    
    private var offset: CGFloat {
        model.showCalendar ? -screen.width : -screen.width*2
    }
    
    @Binding var date: Date
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            HStack(alignment: .center, spacing: 0) {
                    calendarView
                        .frame(width: screen.width*2, height: screen.height, alignment: .trailing)
                    homeView
                        .frame(width: screen.width, height: screen.height)
                }
                .frame(width: screen.width, height: screen.height, alignment: .leading)
                .offset(x: offset)
                .navigationBarTitle("Deadline", displayMode: .inline)
                .navigationBarItems(leading:
                    Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
                        Text("Cancel")
                    }
                    , trailing:
                    Button(action: {
                        self.date = self.calendarManager.selectedDate ?? Date()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                            .foregroundColor(Color("Button"))
                    }
            )
        }
    }
    
    private var calendarView: some View {
        ElegantCalendarView(calendarManager: calendarManager).theme(.init(primary: Color("Secondry")))
    }
    
    
    
    private var homeView: some View {
        VStack {
            NewCardView(content: AnyView(
                HStack {
                    Text(calendarManager.selectedDate?.fullDate ?? "No date selected")
                        .foregroundColor(Color("Primary"))
                    Spacer()
                    Button(action: {
                        withAnimation(turnAnimation) {
                            self.model.showCalendar = true
                        }
                    }) {
                        Text("Select").foregroundColor(Color("Button"))
                    }
                    
                }
            ))
            Spacer()
        }
        .padding(.top, 80)
    }
    
}

struct GTorCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        GTorCalendarView(date: .constant(Date()))
    }
}
