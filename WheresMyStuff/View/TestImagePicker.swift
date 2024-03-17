//TODO: DELETE THIS FILE BEFORE PUBLISHING


import SwiftUI

struct TestImagePicker: View {
    @State private var isShowPhotoLibrary = false   //this is for the sheet
    @State private var image: UIImage?    //ImagePicker will require a binding variable so that the selected image can be accessed

    var body: some View {
        VStack {
            
            Image(uiImage: (self.image ?? UIImage(named: "tiltedParrot"))!)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            Button (action: {
                self.isShowPhotoLibrary = true
            }) {
                HStack {
                    Image(systemName: "photo")
                        .font(.system(size: 20))
                    Text("Photo Library")
                        .font(.headline)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
            }
        }
        .sheet( isPresented: $isShowPhotoLibrary) {
            // to choose an existing photo
//            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
            
            // to choose a new photo
            ImagePicker(sourceType: .camera, selectedImage: $image)
        }
    }
}

#Preview {
    TestImagePicker()
}
