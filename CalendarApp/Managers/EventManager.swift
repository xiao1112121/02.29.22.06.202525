import Foundation
import UIKit

class EventManager: ObservableObject {
    @Published var events: [Event] = []
    
    private let userDefaults = UserDefaults.standard
    private let eventsKey = "SavedEvents"
    
    init() {
        loadEvents()
    }
    
    // MARK: - Event Management
    
    func addEvent(_ event: Event) {
        events.append(event)
        saveEvents()
    }
    
    func updateEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
            saveEvents()
        }
    }
    
    func deleteEvent(_ event: Event) {
        events.removeAll { $0.id == event.id }
        saveEvents()
    }
    
    func getEvents(for date: Date) -> [Event] {
        let calendar = Calendar.current
        return events.filter { event in
            calendar.isDate(event.date, inSameDayAs: date)
        }.sorted { $0.startTime < $1.startTime }
    }
    
    func getEvents(for month: Date) -> [Event] {
        let calendar = Calendar.current
        return events.filter { event in
            calendar.isDate(event.date, equalTo: month, toGranularity: .month)
        }
    }
    
    // MARK: - Data Persistence
    
    private func saveEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            userDefaults.set(encoded, forKey: eventsKey)
        }
    }
    
    private func loadEvents() {
        if let data = userDefaults.data(forKey: eventsKey),
           let decoded = try? JSONDecoder().decode([Event].self, from: data) {
            events = decoded
        }
    }
    
    // MARK: - Sample Data
    
    func addSampleEvents() {
        let calendar = Calendar.current
        let today = Date()
        
        let sampleEvents = [
            Event(
                title: "Họp nhóm",
                description: "Thảo luận về dự án mới",
                date: today,
                startTime: calendar.date(byAdding: .hour, value: 9, to: today) ?? today,
                endTime: calendar.date(byAdding: .hour, value: 10, to: today) ?? today,
                color: .blue
            ),
            Event(
                title: "Bữa trưa với bạn",
                description: "Nhà hàng ABC",
                date: today,
                startTime: calendar.date(byAdding: .hour, value: 12, to: today) ?? today,
                endTime: calendar.date(byAdding: .hour, value: 13, to: today) ?? today,
                color: .green
            ),
            Event(
                title: "Sinh nhật mẹ",
                description: "Mua quà và gọi điện",
                date: calendar.date(byAdding: .day, value: 1, to: today) ?? today,
                startTime: calendar.date(byAdding: .day, value: 1, to: today) ?? today,
                endTime: calendar.date(byAdding: .day, value: 1, to: today) ?? today,
                isAllDay: true,
                color: .red
            )
        ]
        
        for event in sampleEvents {
            addEvent(event)
        }
    }
}