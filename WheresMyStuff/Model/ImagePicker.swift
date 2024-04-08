// Allows access to photo library and camera


import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode   // to dismiss the photo library after an image is chosen by the user
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        // return an instance of UIImagePickerController
        // required function when conforming to UIViewControllerRepresentable protocol
        
        let imagePicker = UIImagePickerController() //this class allows access to photo library and camera.
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>){
        // required function when conforming to UIViewControllerRepresentable protocol
        // called when state of app changes like views, required since SwiftUI contantly updates the view
        // can be left empty
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}// end struct

final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker: ImagePicker
    
    init(_ picker: ImagePicker) {
        self.picker = picker
    }
    
    // this method is called when an image is selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.picker.selectedImage = image
        }
        
        self.picker.presentationMode.wrappedValue.dismiss()
    }
}
