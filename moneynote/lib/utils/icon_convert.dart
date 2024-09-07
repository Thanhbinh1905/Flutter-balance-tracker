import 'package:flutter/material.dart';

class IconConverter {
  static final Map<String, IconData> outcomeIconMap = {
    'shopping_cart': Icons.shopping_cart,
    'fastfood': Icons.fastfood,
    'star': Icons.star,
    'wifi': Icons.wifi, // Mạng
    'brush': Icons.brush, // Mỹ phẩm
    'restaurant': Icons.restaurant, // Ăn uống
    'flight_takeoff': Icons.flight_takeoff, // Du lịch
    'medical_services': Icons.medical_services, // Y tế
    'house': Icons.house,
    'celebration': Icons.celebration,
    'local_dining': Icons.local_dining,
    'local_phone': Icons.local_phone,
    'phone_iphone': Icons.phone_iphone,

    'directions_car': Icons.directions_car, // Phương tiện đi lại
    'school': Icons.school, // Giáo dục
    'work': Icons.work, // Công việc
    'local_grocery_store': Icons.local_grocery_store, // Tạp hóa
    'pets': Icons.pets, // Thú cưng
    'fitness_center': Icons.fitness_center, // Thể hình
    'movie': Icons.movie, // Phim ảnh
    'music_note': Icons.music_note, // Âm nhạc
    'book': Icons.book, // Sách
    'camera_alt': Icons.camera_alt, // Máy ảnh
    'directions_bus': Icons.directions_bus, // Xe buýt
    'local_florist': Icons.local_florist, // Cây cối, hoa
    'local_drink': Icons.local_drink, // Đồ uống
    'hotel': Icons.hotel, // Khách sạn
    'gamepad': Icons.gamepad, // Trò chơi
    'coffee': Icons.local_cafe, // Cà phê
    'local_bar': Icons.local_bar, // Quán bar
    'home_repair_service': Icons.home_repair_service, // Dịch vụ sửa nhà
    'child_care': Icons.child_care, // Chăm sóc trẻ em
    'spa': Icons.spa, // Thư giãn, spa
    'haircut': Icons.content_cut, // Cắt tóc
    'laundry': Icons.local_laundry_service, // Giặt ủi
    'electric_car': Icons.electric_car, // Xe điện

    'gas_station': Icons.local_gas_station, // Xăng dầu
    'payment': Icons.payment, // Thanh toán
    'attach_money': Icons.attach_money, // Tài chính
    // Add more icons as needed
  };

  static final Map<String, IconData> _outcomeIconMap = {
    'star': Icons.star,
    'wifi': Icons.wifi, // Mạng
    'brush': Icons.brush, // Mỹ phẩm
    'restaurant': Icons.restaurant, // Ăn uống
    'flight_takeoff': Icons.flight_takeoff, // Du lịch
    'medical_services': Icons.medical_services, // Y tế
    'house': Icons.house,
    'celebration': Icons.celebration,
    'local_dining': Icons.local_dining,
    'local_phone': Icons.local_phone,
    'phone_iphone': Icons.phone_iphone,
    'shopping_cart': Icons.shopping_cart, // Mua sắm
    'directions_car': Icons.directions_car, // Phương tiện đi lại
    'school': Icons.school, // Giáo dục
    'work': Icons.work, // Công việc
    'local_grocery_store': Icons.local_grocery_store, // Tạp hóa
    'pets': Icons.pets, // Thú cưng
    'fitness_center': Icons.fitness_center, // Thể hình
    'movie': Icons.movie, // Phim ảnh
    'music_note': Icons.music_note, // Âm nhạc
    'book': Icons.book, // Sách
    'camera_alt': Icons.camera_alt, // Máy ảnh
    'directions_bus': Icons.directions_bus, // Xe buýt
    'local_florist': Icons.local_florist, // Cây cối, hoa
    'local_drink': Icons.local_drink, // Đồ uống
    'hotel': Icons.hotel, // Khách sạn
    'gamepad': Icons.gamepad, // Trò chơi
    'coffee': Icons.local_cafe, // Cà phê
    'local_bar': Icons.local_bar, // Quán bar
    'home_repair_service': Icons.home_repair_service, // Dịch vụ sửa nhà
    'child_care': Icons.child_care, // Chăm sóc trẻ em
    'spa': Icons.spa, // Thư giãn, spa
    'haircut': Icons.content_cut, // Cắt tóc
    'laundry': Icons.local_laundry_service, // Giặt ủi
    'electric_car': Icons.electric_car, // Xe điện
    'fastfood': Icons.fastfood, // Đồ ăn nhanh
    'gas_station': Icons.local_gas_station, // Xăng dầu
    'payment': Icons.payment, // Thanh toán
    'attach_money': Icons.attach_money, // Tài chính
  };

  static final Map<String, IconData> _incomeIconMap = {
    'add': Icons.add, // Thêm tiền
    'remove': Icons
        .remove, // Trừ tiền (có thể sử dụng cho các trường hợp hoàn trả hoặc điều chỉnh)
    'attach_money': Icons.attach_money, // Tiền mặt
    'account_balance': Icons.account_balance, // Tài khoản ngân hàng
    'credit_card': Icons.credit_card, // Thẻ tín dụng
    'money': Icons.money, // Tiền giấy
    'savings': Icons.savings, // Tiết kiệm
    'business_center': Icons.business_center, // Kinh doanh
    'work': Icons.work, // Công việc
    'trending_up': Icons.trending_up, // Tăng trưởng
    'euro_symbol': Icons.euro_symbol, // Euro
    'monetization_on': Icons.monetization_on, // Tiền xu
    'account_balance_wallet': Icons.account_balance_wallet, // Ví tiền
    'store': Icons.store, // Cửa hàng
    'real_estate_agent': Icons.real_estate_agent, // Bất động sản
    'shopping_bag': Icons.shopping_bag, // Mua bán
    'paid': Icons.paid, // Thanh toán thành công
    'redeem': Icons.redeem, // Mã khuyến mãi, quà tặng
    'trending_flat': Icons.trending_flat, // Dòng tiền ổn định
    'local_atm': Icons.local_atm, // Máy ATM
    'thumb_up': Icons.thumb_up, // Đầu tư thành công
    'card_giftcard': Icons.card_giftcard, // Quà tặng, nhận quà
    'auto_awesome': Icons.auto_awesome, // Thưởng
    'flight_land':
        Icons.flight_land, // Dòng tiền trở về (như sau một chuyến công tác)
  };

  static IconData? getIconDataFromString(String iconName) {
    // Check if the iconName exists in the income map
    if (_incomeIconMap.containsKey(iconName)) {
      return _incomeIconMap[iconName];
    }
    // Check if the iconName exists in the outcome map
    else if (_outcomeIconMap.containsKey(iconName)) {
      return _outcomeIconMap[iconName];
    }
    // Return null if the iconName is not found in either map
    else {
      return null;
    }
  }

  static Map<String, IconData> incomeIconMap = {
    'salary': Icons.attach_money,
    'investment': Icons.trending_up,
    'gift': Icons.card_giftcard,
        'add': Icons.add, // Thêm tiền
    'remove': Icons
        .remove, // Trừ tiền (có thể sử dụng cho các trường hợp hoàn trả hoặc điều chỉnh)
    'attach_money': Icons.attach_money, // Tiền mặt
    'account_balance': Icons.account_balance, // Tài khoản ngân hàng
    'credit_card': Icons.credit_card, // Thẻ tín dụng
    'money': Icons.money, // Tiền giấy
    'savings': Icons.savings, // Tiết kiệm
    'business_center': Icons.business_center, // Kinh doanh
    'work': Icons.work, // Công việc
    'trending_up': Icons.trending_up, // Tăng trưởng
    'euro_symbol': Icons.euro_symbol, // Euro
    'monetization_on': Icons.monetization_on, // Tiền xu
    'account_balance_wallet': Icons.account_balance_wallet, // Ví tiền
    'store': Icons.store, // Cửa hàng
    'real_estate_agent': Icons.real_estate_agent, // Bất động sản
    'shopping_bag': Icons.shopping_bag, // Mua bán
    'paid': Icons.paid, // Thanh toán thành công
    'redeem': Icons.redeem, // Mã khuyến mãi, quà tặng
    'trending_flat': Icons.trending_flat, // Dòng tiền ổn định
    'local_atm': Icons.local_atm, // Máy ATM
    'thumb_up': Icons.thumb_up, // Đầu tư thành công
    'card_giftcard': Icons.card_giftcard, // Quà tặng, nhận quà
    'auto_awesome': Icons.auto_awesome, // Thưởng
    'flight_land':
        Icons.flight_land, // Dòng tiền trở về (như sau một chuyến công tác)
    // ... add more as needed ...
  };

  // Ví dụ sử dụng
  // String iconString = 'Icons.wifi';
  // IconData? iconData = IconConverter.getIconDataFromString(iconString);
  // Icon(iconData ?? Icons.error) // Hiển thị biểu tượng mặc định nếu không tìm thấy
}