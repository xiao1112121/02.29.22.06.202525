import UIKit

protocol CalendarViewDelegate: AnyObject {
    func calendarView(_ calendarView: CalendarView, didSelectDate date: Date)
    func calendarView(_ calendarView: CalendarView, didChangeMonth month: Date)
}

class CalendarView: UIView {
    
    weak var delegate: CalendarViewDelegate?
    
    private var currentDate = Date()
    private var selectedDate = Date()
    private var events: [Event] = []
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("‹", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("›", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        return button
    }()
    
    private lazy var weekdaysStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        let weekdays = ["CN", "T2", "T3", "T4", "T5", "T6", "T7"]
        for weekday in weekdays {
            let label = UILabel()
            label.text = weekday
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            stackView.addArrangedSubview(label)
        }
        
        return stackView
    }()
    
    private lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: "CalendarDayCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateMonthLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        updateMonthLabel()
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        // Month header
        let monthHeaderStackView = UIStackView(arrangedSubviews: [previousButton, monthLabel, nextButton])
        monthHeaderStackView.axis = .horizontal
        monthHeaderStackView.distribution = .fill
        monthHeaderStackView.alignment = .center
        
        addSubview(monthHeaderStackView)
        addSubview(weekdaysStackView)
        addSubview(calendarCollectionView)
        
        // Layout
        monthHeaderStackView.translatesAutoresizingMaskIntoConstraints = false
        weekdaysStackView.translatesAutoresizingMaskIntoConstraints = false
        calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            monthHeaderStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            monthHeaderStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            monthHeaderStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            weekdaysStackView.topAnchor.constraint(equalTo: monthHeaderStackView.bottomAnchor, constant: 16),
            weekdaysStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weekdaysStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weekdaysStackView.heightAnchor.constraint(equalToConstant: 30),
            
            calendarCollectionView.topAnchor.constraint(equalTo: weekdaysStackView.bottomAnchor, constant: 8),
            calendarCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendarCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            calendarCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Button constraints
        previousButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    private func updateMonthLabel() {
        dateFormatter.dateFormat = "MMMM yyyy"
        monthLabel.text = dateFormatter.string(from: currentDate).capitalized
    }
    
    @objc private func previousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        updateMonthLabel()
        calendarCollectionView.reloadData()
        delegate?.calendarView(self, didChangeMonth: currentDate)
    }
    
    @objc private func nextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        updateMonthLabel()
        calendarCollectionView.reloadData()
        delegate?.calendarView(self, didChangeMonth: currentDate)
    }
    
    func updateEvents(_ events: [Event]) {
        self.events = events
        calendarCollectionView.reloadData()
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        calendarCollectionView.reloadData()
    }
    
    private func getDaysInMonth() -> [Date?] {
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let numDays = range.count
        
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        var days: [Date?] = []
        
        // Add empty cells for days before the first day of the month
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        // Add days of the month
        for day in 1...numDays {
            let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
            days.append(date)
        }
        
        return days
    }
    
    private func hasEvents(for date: Date) -> Bool {
        return events.contains { event in
            calendar.isDate(event.date, inSameDayAs: date)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getDaysInMonth().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        
        let days = getDaysInMonth()
        let date = days[indexPath.item]
        
        if let date = date {
            let day = calendar.component(.day, from: date)
            cell.configure(day: day, isSelected: calendar.isDate(date, inSameDayAs: selectedDate), hasEvents: hasEvents(for: date))
        } else {
            cell.configure(day: nil, isSelected: false, hasEvents: false)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CalendarView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let days = getDaysInMonth()
        guard let date = days[indexPath.item] else { return }
        
        selectedDate = date
        collectionView.reloadData()
        delegate?.calendarView(self, didSelectDate: date)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        return CGSize(width: width, height: 50)
    }
}

// MARK: - CalendarDayCell
class CalendarDayCell: UICollectionViewCell {
    private let dayLabel = UILabel()
    private let eventIndicator = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont.systemFont(ofSize: 16)
        
        eventIndicator.backgroundColor = .systemBlue
        eventIndicator.layer.cornerRadius = 2
        
        addSubview(dayLabel)
        addSubview(eventIndicator)
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        eventIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            eventIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            eventIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            eventIndicator.widthAnchor.constraint(equalToConstant: 4),
            eventIndicator.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
    func configure(day: Int?, isSelected: Bool, hasEvents: Bool) {
        if let day = day {
            dayLabel.text = "\(day)"
            dayLabel.isHidden = false
            
            if isSelected {
                backgroundColor = .systemBlue
                dayLabel.textColor = .white
                layer.cornerRadius = 20
            } else {
                backgroundColor = .clear
                dayLabel.textColor = .label
                layer.cornerRadius = 0
            }
        } else {
            dayLabel.isHidden = true
            backgroundColor = .clear
            layer.cornerRadius = 0
        }
        
        eventIndicator.isHidden = !hasEvents
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        layer.cornerRadius = 0
    }
}