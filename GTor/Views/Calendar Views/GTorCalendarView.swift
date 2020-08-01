// Kevin Li - 8:33 PM - 6/24/20

import ElegantCalendar
import ElegantPages
import SwiftUI

struct GTorCalendarView: View {
    @ObservedObject var calendarManager = MonthlyCalendarManager(
        configuration: CalendarConfiguration(startDate: Date(),
                                             endDate: .daysFromToday(365*3)))
    @Binding var date: Date
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            MonthlyCalendarView(calendarManager: calendarManager)
                .theme(.init(primary: Color("Button")))
                .padding(.top, 20)
                .navigationBarTitle("Deadline", displayMode: .inline)
                .navigationBarItems(leading:
                    Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
                        Text("Cancel")
                        .foregroundColor(Color("Button"))
                        .font(.callout)
                    }
                    , trailing:
                    Button(action: {
                        self.date = self.calendarManager.selectedDate ?? Date()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                            .foregroundColor(Color("Button"))
                            .font(.callout)                    }
            )
        }
    }
}

struct GTorCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        GTorCalendarView(date: .constant(Date()))
    }
}
