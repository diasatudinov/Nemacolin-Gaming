struct DailyRewardsView: View {
    @StateObject private var viewModel = DailyRewardsViewModel()
    
    // 7 columns for each day
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 7)
    
    var body: some View {
        VStack(spacing: 20) {
            // Grid of circles for each day
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(1...7, id: \.self) { day in
                    VStack {
                        ZStack {
                            Circle()
                                .strokeBorder(viewModel.isDayUnlocked(day) ? Color.accentColor : Color.gray, lineWidth: 2)
                                .frame(width: 50, height: 50)

                            if viewModel.isDayClaimed(day) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            } else {
                                Text("\(day)")
                                    .foregroundColor(viewModel.isDayUnlocked(day) ? .accentColor : .gray)
                            }
                        }
                        Text("Day \(day)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal)
            
            // Claim button or countdown message
            if viewModel.canClaimNext() {
                Button(action: viewModel.claimNext) {
                    Text("Claim Day \(viewModel.claimedCount + 1) Reward")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            } else if viewModel.claimedCount < 7 {
                Text("Next reward in \(viewModel.formattedTimeRemaining())")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Text("All rewards claimed!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}