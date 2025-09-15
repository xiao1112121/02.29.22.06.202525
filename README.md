# Ứng Dụng Lịch Cá Nhân iOS

Ứng dụng lịch cá nhân được viết bằng Swift cho iOS, cho phép bạn quản lý các sự kiện và lịch trình hàng ngày.

## Tính Năng

- 📅 **Hiển thị lịch tháng**: Xem lịch theo tháng với khả năng chuyển đổi tháng
- ➕ **Thêm sự kiện**: Tạo sự kiện mới với tiêu đề, mô tả, thời gian và màu sắc
- ✏️ **Chỉnh sửa sự kiện**: Cập nhật thông tin sự kiện đã có
- 🗑️ **Xóa sự kiện**: Xóa sự kiện không cần thiết
- 🎨 **Màu sắc đa dạng**: 8 màu sắc khác nhau để phân loại sự kiện
- ⏰ **Cả ngày hoặc theo giờ**: Tùy chọn sự kiện cả ngày hoặc theo giờ cụ thể
- 💾 **Lưu trữ dữ liệu**: Dữ liệu được lưu trữ cục bộ trên thiết bị
- 📱 **Giao diện thân thiện**: Thiết kế đẹp mắt, dễ sử dụng

## Cấu Trúc Dự Án

```
CalendarApp/
├── Models/
│   └── Event.swift              # Model sự kiện
├── Managers/
│   └── EventManager.swift       # Quản lý sự kiện và lưu trữ
├── ViewControllers/
│   ├── CalendarViewController.swift    # Màn hình chính
│   └── AddEventViewController.swift    # Màn hình thêm/chỉnh sửa sự kiện
├── Views/
│   └── CalendarView.swift       # View hiển thị lịch
├── AppDelegate.swift
├── SceneDelegate.swift
├── Info.plist
├── Main.storyboard
├── LaunchScreen.storyboard
└── Assets.xcassets/
```

## Cách Sử Dụng

### 1. Xem Lịch
- Mở ứng dụng để xem lịch tháng hiện tại
- Sử dụng nút mũi tên để chuyển đổi giữa các tháng
- Chạm vào ngày để xem các sự kiện trong ngày đó

### 2. Thêm Sự Kiện
- Nhấn nút "+" ở góc phải màn hình
- Điền thông tin sự kiện:
  - Tiêu đề (bắt buộc)
  - Mô tả (tùy chọn)
  - Ngày
  - Thời gian bắt đầu và kết thúc
  - Chọn "Cả ngày" nếu sự kiện kéo dài cả ngày
  - Chọn màu sắc cho sự kiện
- Nhấn "Save" để lưu

### 3. Chỉnh Sửa/Xóa Sự Kiện
- Chạm vào sự kiện trong danh sách
- Chọn "Chỉnh sửa" để sửa thông tin
- Chọn "Xóa" để xóa sự kiện

### 4. Dữ Liệu Mẫu
- Nhấn nút "Dữ liệu mẫu" để thêm một số sự kiện mẫu
- Hữu ích để làm quen với ứng dụng

## Yêu Cầu Hệ Thống

- iOS 17.0 trở lên
- Xcode 15.0 trở lên
- Swift 5.0

## Cài Đặt

1. Mở file `CalendarApp.xcodeproj` trong Xcode
2. Chọn thiết bị hoặc simulator
3. Nhấn Cmd+R để build và chạy ứng dụng

## Công Nghệ Sử Dụng

- **Swift**: Ngôn ngữ lập trình chính
- **UIKit**: Framework giao diện người dùng
- **UserDefaults**: Lưu trữ dữ liệu cục bộ
- **MVVM Pattern**: Kiến trúc ứng dụng
- **Protocol-Oriented Programming**: Thiết kế linh hoạt

## Tính Năng Nâng Cao

- **Lưu trữ dữ liệu**: Sử dụng UserDefaults để lưu trữ sự kiện
- **Giao diện responsive**: Tự động điều chỉnh theo kích thước màn hình
- **Hỗ trợ Dark Mode**: Tự động thích ứng với chế độ sáng/tối
- **Localization**: Hỗ trợ tiếng Việt

## Phát Triển Thêm

Có thể mở rộng ứng dụng với các tính năng:
- Đồng bộ với iCloud
- Thông báo nhắc nhở
- Chia sẻ sự kiện
- Lặp lại sự kiện
- Tìm kiếm sự kiện
- Xuất lịch

## Tác Giả

Ứng dụng được tạo bởi AI Assistant để demo các tính năng cơ bản của một ứng dụng lịch iOS.

## Giấy Phép

Dự án này được tạo ra cho mục đích học tập và demo.