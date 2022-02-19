//
//  AddData.swift
//  Movies
//
//  Created by Mohamed Kamal on 03/02/2022.
//

import UIKit

class AddData: UIViewController{
    var p : MyProtocol?
    @IBOutlet weak var tit: UITextField!
    @IBOutlet weak var im: UIImageView!
    @IBOutlet weak var rate: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var genre: UITextField!

    var i : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func add(_ sender: Any) {

        p?.add()
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.delegate = self
                vc.allowsEditing = true
                present(vc, animated: true)
        
    }


    
}
extension AddData : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            im.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
