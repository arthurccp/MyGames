//
//  AddViewController.swift
//  MyGames
//
//  Created by Arthur Silva on 13/12/22.
//

import UIKit
import CoreData

class AddEditViewController: UIViewController {
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var dpReleaseDate: UIDatePicker!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var btCover: UIButton!
    @IBOutlet weak var ivCover: UIImageView!
    
    var game: Game!
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    var consolesManager = ConsolesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done ))
        let btflexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [btDone,btflexibleSpace,  btCancel]

        tfConsole.inputView = pickerView
        tfConsole.inputAccessoryView = toolbar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        consolesManager.loadConsoles(wth: context)
    }
    
    
    @objc func cancel(){
        tfConsole.resignFirstResponder()
    }
    
    @objc func done(){
        tfConsole.text = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)].name
        
    }
    
    @IBAction func addEditingCover(_ sender: Any) {
        let alert = UIAlertController(title: "Selecionar postar", message: "De onde você quer escolher o poster ?", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default){ (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        let photoAction = UIAlertAction(title: "Álbum de fotos ", style: .default){(action: UIAlertAction)in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photoAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    func selectPicture(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func addEditingGame(_ sender: UIButton) {
        if game == nil{
            game = Game(context: context)
        }
        game.title = tfTitle.text
        game.releaseDate = dpReleaseDate.date
        if !tfConsole.text!.isEmpty{
            let console = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)]
            game.console = console
        }
        game.cover = ivCover.image
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
                navigationController?.popViewController(animated: true)
    }
}

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consolesManager.consoles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        return console.name
    }
}
extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        ivCover.image = image
        btCover.setTitle(nil, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
