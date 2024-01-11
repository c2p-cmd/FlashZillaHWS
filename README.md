# FashZilla

![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fgoogle%2Fgenerative-ai-swift%2Fbadge%3Ftype%3Dswift-versions)

## Introduction:
- Another HWS [tutorial](https://www.hackingwithswift.com/books/ios-swiftui/flashzilla-wrap-up) app
- This was quite different than the other ones.
- Handled Editing Screen differently than Paul.
```swift
   @State private var showEditScreen = false
    
    var body: some View {
        NavigationStack {
            if showEditScreen {
                EditView {
                    showEditScreen = false
                }
            } else {
                FlashCardsView()
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Button {
                                withAnimation {
                                    showEditScreen = true
                                }
                            } label: {
                                Label("Add Cards", systemImage: "plus.circle")
                                    .font(.largeTitle)
                            }
                            .buttonStyle(.borderless)
                            .background(.black.opacity(0.75))
                            .clipShape(.circle)
                            .foregroundStyle(.white)
                        }
                    }
            }
        }
    }
```
