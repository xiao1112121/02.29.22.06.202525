import UIKit

class CalendarViewController: UIViewController {
    
    private let eventManager = EventManager()
    private var selectedDate = Date()
    
    private lazy var calendarView: CalendarView = {
        let view = CalendarView()
        view.delegate = self
        return view
    }()
    
    private lazy var eventsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addEventTapped)
        )
        return button
    }()
    
    private lazy var sampleDataButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Dữ liệu mẫu",
            style: .plain,
            target: self,
            action: #selector(addSampleDataTapped)
        )
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        updateDateLabel()
        updateEvents()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Lịch Cá Nhân"
        
        // Add subviews
        view.addSubview(calendarView)
        view.addSubview(dateLabel)
        view.addSubview(eventsTableView)
        
        // Layout
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        eventsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: 350),
            
            dateLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            eventsTableView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            eventsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eventsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [addButton, sampleDataButton]
    }
    
    private func updateDateLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        formatter.locale = Locale(identifier: "vi_VN")
        dateLabel.text = formatter.string(from: selectedDate)
    }
    
    private func updateEvents() {
        let events = eventManager.getEvents(for: selectedDate)
        calendarView.updateEvents(eventManager.events)
        eventsTableView.reloadData()
    }
    
    @objc private func addEventTapped() {
        let addEventVC = AddEventViewController()
        addEventVC.eventManager = eventManager
        addEventVC.selectedDate = selectedDate
        addEventVC.delegate = self
        
        let navController = UINavigationController(rootViewController: addEventVC)
        present(navController, animated: true)
    }
    
    @objc private func addSampleDataTapped() {
        eventManager.addSampleEvents()
        updateEvents()
        
        let alert = UIAlertController(
            title: "Thành công",
            message: "Đã thêm dữ liệu mẫu vào lịch",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - CalendarViewDelegate
extension CalendarViewController: CalendarViewDelegate {
    func calendarView(_ calendarView: CalendarView, didSelectDate date: Date) {
        selectedDate = date
        updateDateLabel()
        updateEvents()
    }
    
    func calendarView(_ calendarView: CalendarView, didChangeMonth month: Date) {
        // Update events for the new month
        updateEvents()
    }
}

// MARK: - UITableViewDataSource
extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventManager.getEvents(for: selectedDate).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        let events = eventManager.getEvents(for: selectedDate)
        let event = events[indexPath.row]
        cell.configure(with: event)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let events = eventManager.getEvents(for: selectedDate)
        let event = events[indexPath.row]
        
        let alert = UIAlertController(
            title: event.title,
            message: event.description.isEmpty ? "Không có mô tả" : event.description,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Chỉnh sửa", style: .default) { _ in
            let editEventVC = AddEventViewController()
            editEventVC.eventManager = self.eventManager
            editEventVC.eventToEdit = event
            editEventVC.delegate = self
            
            let navController = UINavigationController(rootViewController: editEventVC)
            self.present(navController, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Xóa", style: .destructive) { _ in
            self.eventManager.deleteEvent(event)
            self.updateEvents()
        })
        
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - AddEventViewControllerDelegate
extension CalendarViewController: AddEventViewControllerDelegate {
    func addEventViewControllerDidSave() {
        updateEvents()
    }
}

// MARK: - EventTableViewCell
class EventTableViewCell: UITableViewCell {
    private let containerView = UIView()
    private let colorIndicator = UIView()
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.1
        
        colorIndicator.layer.cornerRadius = 3
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label
        
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = .secondaryLabel
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        
        contentView.addSubview(containerView)
        containerView.addSubview(colorIndicator)
        containerView.addSubview(titleLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(descriptionLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        colorIndicator.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            colorIndicator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            colorIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            colorIndicator.widthAnchor.constraint(equalToConstant: 6),
            colorIndicator.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: colorIndicator.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: colorIndicator.trailingAnchor, constant: 12),
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            descriptionLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: colorIndicator.trailingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with event: Event) {
        titleLabel.text = event.title
        colorIndicator.backgroundColor = event.color.uiColor
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        if event.isAllDay {
            timeLabel.text = "Cả ngày"
        } else {
            let startTime = timeFormatter.string(from: event.startTime)
            let endTime = timeFormatter.string(from: event.endTime)
            timeLabel.text = "\(startTime) - \(endTime)"
        }
        
        descriptionLabel.text = event.description
        descriptionLabel.isHidden = event.description.isEmpty
    }
}