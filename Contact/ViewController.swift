//
//  ViewController.swift
//  Contact
//
//  Created by Apple on 25.08.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var contacts: [ContactProtocol] = []{
        didSet{
            contacts.sort{$0.title < $1.title}
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    private func loadContacts(){
        contacts.append(Contact(title: "Mark", phone: "+9995828909"))
        contacts.append(Contact(title: "Jon", phone: "+0518070732"))
        contacts.append(Contact(title: "Hanter", phone: "+13336409"))

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContacts()
    }
    
    @IBAction func showNewContactAlert(){
        let alertController = UIAlertController(title: "Создать новый контакт", message: "Введите имя и телефон", preferredStyle: .alert)
        
        alertController.addTextField{ textField in
            textField.placeholder = "Имя"
        }
        alertController.addTextField{ textField in
            textField.placeholder = "Номер телефона"
        }
        
        // кнопка создания контакта
        let createButton = UIAlertAction(title: "Создать", style: .default){ _ in
            guard let contactName = alertController.textFields?[0].text,
                  let contactPhone = alertController.textFields?[1].text else{
                return
            }
            //  новый контакт
            let contact = Contact(title: contactName, phone: contactPhone)
            self.contacts.append(contact)
            self.tableView.reloadData()
        }
        
        // кнопка отмены
        let cancelButton = UIAlertAction(title: "Отменить", style: .cancel)
        
        alertController.addAction(cancelButton)
        alertController.addAction(createButton)
        
        self.present(alertController, animated: true)
    }
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "MyCell"){
            print("Используем старую ячейку для строки с индексом \(indexPath.row)")
            cell = reuseCell
        }else{
            print("Создаем новую ячейку для строки с индексом \(indexPath.row)")
            cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        }
         configure(cell: &cell, for: indexPath)
        return cell
    }
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        // имя
        configuration.text = contacts[indexPath.row].title
        // номер
        configuration.secondaryText = contacts[indexPath.row].phone
        
        cell.contentConfiguration = configuration
    }
}


extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // удаление действие
        let actionDelete =  UIContextualAction(style: .destructive, title: "Удалить"){
            _,_,_ in
            // удаление контакта
            self.contacts.remove(at: indexPath.row)
            // обнавляем табличное предстовление
            tableView.reloadData()
        }
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}
