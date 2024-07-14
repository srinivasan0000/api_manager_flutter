class ApiConstant {
  ApiConstant._();
  static const baseUrl = "https://reqres.in/api";
  static const userList = "/users?page";
}

class RequestConstants {
  RequestConstants._();
  static const int receiveTimeout = 15000;
  static const int connectionTimeout = 100;
  static const Map<String, String> headers = {
    "Content-Type": "application/json",
  };
}
