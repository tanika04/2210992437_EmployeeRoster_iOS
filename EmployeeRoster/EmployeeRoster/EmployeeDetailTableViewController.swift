
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTypeDelegate {
    func didselect(employeeType: EmployeeType) {
        self.employeeType = employeeType
        employeeTypeLabel.text = employeeType.description
        employeeTypeLabel.textColor = .black
        updateSaveButtonState()
    }
    

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var employeeTypeLabel: UILabel!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    
    var isEditingBirthday: Bool = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    weak var delegate: EmployeeDetailTableViewControllerDelegate?
    var employee: Employee?
    var employeeType: EmployeeType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        updateSaveButtonState()
        dobDatePicker.minimumDate = Date()
    }
    
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            
            dobLabel.text = employee.dateOfBirth.formatted(date: .abbreviated, time: .omitted)
            dobLabel.textColor = .label
            employeeTypeLabel.text = employee.employeeType.description
            employeeTypeLabel.textColor = .label
        } else {
            navigationItem.title = "New Employee"
        }
    }
    
    private func updateSaveButtonState() {
        let shouldEnableSaveButton = nameTextField.text?.isEmpty == false
        
        if employeeType != nil {
            saveBarButtonItem.isEnabled = shouldEnableSaveButton
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text else {
            return
        }
        
        if let employeeType = employeeType {
            let employee = Employee(name: name, dateOfBirth: dobDatePicker.date, employeeType: employeeType)
            delegate?.employeeDetailTableViewController(self, didSave: employee)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
    }

    @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isEditingBirthday && indexPath.row == 2 {
            return 0
        }
        else if isEditingBirthday && indexPath.row == 2 {
            return 200
        }
        return UITableView.automaticDimension
    }
    
    
    @IBAction func dateChanged(_ sender: Any) {
        dobLabel.text = dobDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            isEditingBirthday.toggle()
            dobLabel.textColor = .label
            dobLabel.text = dobDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? EmployeeTypeTableViewController else { return }
        destination.employeeType = employee?.employeeType
        destination.delegate = self
    }
}
