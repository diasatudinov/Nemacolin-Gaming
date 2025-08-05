//
//  NGAchievementsViewModel.swift
//  Nemacolin Gaming
//
//


import SwiftUI

class NGAchievementsViewModel: ObservableObject {
    
    @Published var achievements: [MGAchievement] = [
        MGAchievement(image: "achieve1ImageNEG", title: "Zombie party", subtitle: "There should be 15 zombies in one field." ,isAchieved: false),
        MGAchievement(image: "achieve2ImageNEG", title: "Brain Party", subtitle: "Collect 1000 brains" ,isAchieved: false),
        MGAchievement(image: "achieve3ImageNEG", title: "Full house at cemetery", subtitle: "Lose 1000 zombies" ,isAchieved: false),
        MGAchievement(image: "achieve4ImageNEG", title: "Five hundred dead", subtitle: "Kill 500 warriors" ,isAchieved: false),

    ] {
        didSet {
            saveAchievementsItem()
        }
    }
    
    init() {
        loadAchievementsItem()
        
    }
    
    private let userDefaultsAchievementsKey = "achievementsKeyNG"
    
    func achieveToggle(_ achive: MGAchievement) {
        guard let index = achievements.firstIndex(where: { $0.id == achive.id })
        else {
            return
        }
        achievements[index].isAchieved.toggle()
        
    }
    
    
    func saveAchievementsItem() {
        if let encodedData = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsAchievementsKey)
        }
        
    }
    
    func loadAchievementsItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsAchievementsKey),
           let loadedItem = try? JSONDecoder().decode([MGAchievement].self, from: savedData) {
            achievements = loadedItem
        } else {
            print("No saved data found")
        }
    }
}

struct MGAchievement: Codable, Hashable, Identifiable {
    var id = UUID()
    var image: String
    var title: String
    var subtitle: String
    var isAchieved: Bool
}
