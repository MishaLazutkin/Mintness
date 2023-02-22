
class BaseResponse {
  BaseResponse({
    this.status,
    this.message,
  });

  String status;
  String message;

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
    status: json["status"],
    message: json["message"],
  );

}
