class Data {
  String? active, bar, col, fire, flowM, temp;

  Data({this.active, this.bar, this.col, this.fire, this.flowM, this.temp});
}

class Order {
  final String? azsName, city;

  Order(this.azsName, this.city);
}

class UsersInfo {
  final String? surName, u_name, middleName, email, date, phoneNumber;

  UsersInfo(
      {this.surName,
      this.u_name,
      this.middleName,
      this.email,
      this.date,
      this.phoneNumber});

  factory UsersInfo.fromJson({required Map<dynamic, dynamic> json}) {
    return UsersInfo(
      surName: json['u_surname'],
      u_name: json['u_name'],
      middleName: json['u_patronymic'],
      email: json['u_email'],
      date: json['u_date'],
      phoneNumber: json['u_phone'],
    );
  }
}

class History {
  String? azs, city, comment, status, time, ucomment2, vid;

  History(
      {this.azs,
      this.city,
      this.comment,
      this.status,
      this.time,
      this.ucomment2,
      this.vid});
}

class Pipe {
  String? pipeName;

  Pipe({this.pipeName});
}
