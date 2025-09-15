import UIKit

protocol AddEventViewControllerDelegate: AnyObject {
    func addEventViewControllerDidSave()
}

class AddEventViewController: UIViewController {
    
    weak var delegate: AddEventViewControllerDelegate?
    var eventManager: EventManager!
    var selectedDate: Date = Date()
    var eventToEdit: Event?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Tiêu đề sự kiện"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return textView
    }()
    
    private lazy var descriptionPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Mô tả (tùy chọn)"
        label.textColor = .placeholderText
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        return picker
    }()
    
    private lazy var startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .compact
        return picker
    }()
    
    private lazy var endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .compact
        return picker
    }()
    
    private lazy var allDaySwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.addTarget(self, action: #selector(allDaySwitchChanged), for: .valueChanged)
        return switchControl
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var selectedColor: EventColor = .blue
    private var isAllDay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupInitialValues()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = eventToEdit == nil ? "Thêm sự kiện" : "Chỉnh sửa sự kiện"
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleTextField)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(descriptionPlaceholderLabel)
        contentView.addSubview(datePicker)
        contentView.addSubview(startTimePicker)
        contentView.addSubview(endTimePicker)
        contentView.addSubview(allDaySwitch)
        contentView.addSubview(colorCollectionView)
        
        // Add labels
        addLabels()
        
        // Layout
        setupConstraints()
    }
    
    private func addLabels() {
        let labels = [
            ("Mô tả:", descriptionTextView),
            ("Ngày:", datePicker),
            ("Bắt đầu:", startTimePicker),
            ("Kết thúc:", endTimePicker),
            ("Cả ngày:", allDaySwitch),
            ("Màu sắc:", colorCollectionView)
        ]
        
        for (title, view) in labels {
            let label = UILabel()
            label.text = title
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = .label
            contentView.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                label.topAnchor.constraint(equalTo: view.topAnchor, constant: -25)
            ])
        }
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        startTimePicker.translatesAutoresizingMaskIntoConstraints = false
        endTimePicker.translatesAutoresizingMaskIntoConstraints = false
        allDaySwitch.translatesAutoresizingMaskIntoConstraints = false
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 50),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionPlaceholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 8),
            descriptionPlaceholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 8),
            
            datePicker.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 50),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            startTimePicker.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 50),
            startTimePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            startTimePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            endTimePicker.topAnchor.constraint(equalTo: startTimePicker.bottomAnchor, constant: 50),
            endTimePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            endTimePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            allDaySwitch.topAnchor.constraint(equalTo: endTimePicker.bottomAnchor, constant: 50),
            allDaySwitch.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            colorCollectionView.topAnchor.constraint(equalTo: allDaySwitch.bottomAnchor, constant: 50),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 60),
            colorCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveTapped)
        )
    }
    
    private func setupInitialValues() {
        if let event = eventToEdit {
            titleTextField.text = event.title
            descriptionTextView.text = event.description
            descriptionPlaceholderLabel.isHidden = !event.description.isEmpty
            datePicker.date = event.date
            startTimePicker.date = event.startTime
            endTimePicker.date = event.endTime
            allDaySwitch.isOn = event.isAllDay
            selectedColor = event.color
            isAllDay = event.isAllDay
        } else {
            datePicker.date = selectedDate
            let calendar = Calendar.current
            let startTime = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: selectedDate) ?? selectedDate
            let endTime = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: selectedDate) ?? selectedDate
            startTimePicker.date = startTime
            endTimePicker.date = endTime
        }
        
        updateTimePickersVisibility()
        
        // Setup text view delegate
        descriptionTextView.delegate = self
    }
    
    @objc private func allDaySwitchChanged() {
        isAllDay = allDaySwitch.isOn
        updateTimePickersVisibility()
    }
    
    private func updateTimePickersVisibility() {
        startTimePicker.isHidden = isAllDay
        endTimePicker.isHidden = isAllDay
        
        // Update labels visibility
        for subview in contentView.subviews {
            if let label = subview as? UILabel {
                if label.text == "Bắt đầu:" || label.text == "Kết thúc:" {
                    label.isHidden = isAllDay
                }
            }
        }
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(title: "Lỗi", message: "Vui lòng nhập tiêu đề sự kiện")
            return
        }
        
        let description = descriptionTextView.text ?? ""
        let date = datePicker.date
        
        let calendar = Calendar.current
        let startTime: Date
        let endTime: Date
        
        if isAllDay {
            startTime = calendar.startOfDay(for: date)
            endTime = calendar.date(byAdding: .day, value: 1, to: startTime) ?? startTime
        } else {
            startTime = calendar.date(bySettingHour: calendar.component(.hour, from: startTimePicker.date),
                                    minute: calendar.component(.minute, from: startTimePicker.date),
                                    second: 0,
                                    of: date) ?? date
            
            endTime = calendar.date(bySettingHour: calendar.component(.hour, from: endTimePicker.date),
                                  minute: calendar.component(.minute, from: endTimePicker.date),
                                  second: 0,
                                  of: date) ?? date
            
            if endTime <= startTime {
                showAlert(title: "Lỗi", message: "Thời gian kết thúc phải sau thời gian bắt đầu")
                return
            }
        }
        
        let event = Event(
            title: title,
            description: description,
            date: date,
            startTime: startTime,
            endTime: endTime,
            isAllDay: isAllDay,
            color: selectedColor
        )
        
        if let existingEvent = eventToEdit {
            var updatedEvent = event
            updatedEvent = Event(
                title: title,
                description: description,
                date: date,
                startTime: startTime,
                endTime: endTime,
                isAllDay: isAllDay,
                color: selectedColor
            )
            eventManager.updateEvent(updatedEvent)
        } else {
            eventManager.addEvent(event)
        }
        
        delegate?.addEventViewControllerDidSave()
        dismiss(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension AddEventViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        descriptionPlaceholderLabel.isHidden = !textView.text.isEmpty
    }
}

// MARK: - UICollectionViewDataSource
extension AddEventViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EventColor.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCollectionViewCell
        let color = EventColor.allCases[indexPath.item]
        cell.configure(with: color, isSelected: color == selectedColor)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension AddEventViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = EventColor.allCases[indexPath.item]
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AddEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
}

// MARK: - ColorCollectionViewCell
class ColorCollectionViewCell: UICollectionViewCell {
    private let colorView = UIView()
    private let checkmarkView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        colorView.layer.cornerRadius = 20
        colorView.layer.borderWidth = 2
        colorView.layer.borderColor = UIColor.clear.cgColor
        
        checkmarkView.image = UIImage(systemName: "checkmark")
        checkmarkView.tintColor = .white
        checkmarkView.contentMode = .scaleAspectFit
        checkmarkView.isHidden = true
        
        addSubview(colorView)
        colorView.addSubview(checkmarkView)
        
        colorView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            
            checkmarkView.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            checkmarkView.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            checkmarkView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with color: EventColor, isSelected: Bool) {
        colorView.backgroundColor = color.uiColor
        checkmarkView.isHidden = !isSelected
        
        if isSelected {
            colorView.layer.borderColor = UIColor.label.cgColor
        } else {
            colorView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}