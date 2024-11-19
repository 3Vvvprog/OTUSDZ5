//
//  ViewModel.swift
//  OTUSDZ5
//
//  Created by Вячеслав Вовк on 19.11.2024.
//

import Foundation
import Vision
import CoreML
import SwiftUI

class ViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    
    private let initialModel = try? mymodel(configuration: MLModelConfiguration())
    private var vnCoreMLModel: VNCoreMLModel?
    private var request: VNCoreMLRequest?

    
    init() {
        guard let initialModel else { return }
        vnCoreMLModel = try? VNCoreMLModel(for: initialModel.model)
        request = VNCoreMLRequest(model: vnCoreMLModel!, completionHandler: response)
    }
    
    func tryImage() {
        guard let image = selectedImage else { return }
        let handler = VNImageRequestHandler(cgImage: image.cgImage!)
        
        try? handler.perform([request!])
    }
    
    func response(request: VNRequest, error: Error?) {
        guard error == nil else {
            print("Error")
            return
        }
        
        guard var observation = request.results as? [VNClassificationObservation] else {
            print("ERROR")
            return
        }
        
        observation.forEach { ob in
            print("id: \(ob.identifier) : \(ob.confidence)")
        }
    }
    
}
