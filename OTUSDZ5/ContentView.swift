import SwiftUI
import PhotosUI


struct ContentView: View {
    @StateObject var viewModel = ViewModel()

    @State var showSelection = false
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        VStack {
            if viewModel.selectedImage != nil {
                Image(uiImage: viewModel.selectedImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0.0, maxWidth: .infinity)
            }
            Button {
                viewModel.tryImage()
            } label: {
                Text("Try")
            }

            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    Text("Загрузить видео из галлереи")
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            viewModel.selectedImage = UIImage(data: data)
                        }
                    }
                }
        }
    }
}
