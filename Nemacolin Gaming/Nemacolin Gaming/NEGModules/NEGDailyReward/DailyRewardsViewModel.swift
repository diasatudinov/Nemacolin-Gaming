import SwiftUI
import Combine

// ViewModel for managing daily rewards logic
class DailyRewardsViewModel: ObservableObject {
    @Published private(set) var lastClaimDate: Date?
    @Published private(set) var claimedCount: Int = 0
    @Published private(set) var timeRemaining: TimeInterval = 0
    
    private let totalDays = 7
    private var timerCancellable: AnyCancellable?
    
    init() {
        loadState()
        updateTimeRemaining()
        // Start timer to update countdown every second
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTimeRemaining()
            }
    }
    
    deinit {
        timerCancellable?.cancel()
    }
    
    // Determines if the next reward can be claimed
    func canClaimNext() -> Bool {
        guard claimedCount < totalDays else { return false }
        if let last = lastClaimDate {
            return Date() >= last.addingTimeInterval(24 * 60 * 60)
        } else {
            return claimedCount == 0
        }
    }
    
    // Claim the next available reward
    func claimNext() {
        guard canClaimNext() else { return }
        claimedCount += 1
        lastClaimDate = Date()
        saveState()
        updateTimeRemaining()
    }
    
    // Check if a given day is unlocked
    func isDayUnlocked(_ day: Int) -> Bool {
        return day <= claimedCount || (day == claimedCount + 1 && canClaimNext())
    }
    
    // Check if a given day has been claimed
    func isDayClaimed(_ day: Int) -> Bool {
        return day <= claimedCount
    }
    
    // Update countdown until next unlock
    private func updateTimeRemaining() {
        if let last = lastClaimDate, claimedCount < totalDays {
            let nextDate = last.addingTimeInterval(24 * 60 * 60)
            timeRemaining = max(0, nextDate.timeIntervalSince(Date()))
        } else {
            timeRemaining = 0
        }
    }
    
    // Format time interval into HH:mm:ss
    func formattedTimeRemaining() -> String {
        let hours = Int(timeRemaining) / 3600
        let minutes = (Int(timeRemaining) % 3600) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // Persist state to UserDefaults
    private func saveState() {
        let defaults = UserDefaults.standard
        defaults.set(claimedCount, forKey: "claimedCount")
        defaults.set(lastClaimDate, forKey: "lastClaimDate")
    }
    
    // Load state from UserDefaults
    private func loadState() {
        let defaults = UserDefaults.standard
        claimedCount = defaults.integer(forKey: "claimedCount")
        lastClaimDate = defaults.object(forKey: "lastClaimDate") as? Date
    }
}