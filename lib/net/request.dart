import 'package:dio/dio.dart';

class ComResponse<T> {
  int code;
  String msg;
  T data;

  ComResponse({this.code, this.msg, this.data});
}

class NetRequest {
  Dio dio = Dio();

  Future<ComResponse<T>> reqeustData<T>(String path,
      {Map<String, dynamic> queryParameters,
      dynamic data,
      String method = "get"}) async {
    try {
      Response response = method == "get"
          ? await dio.get(path, queryParameters: queryParameters)
          : await dio.post(path, data: data);

      return ComResponse(
          code: response.data['code'],
          msg: response.data['msg'],
          data: response.data['data']);
    } on DioError catch (e) {
      String message = e.message;
      if (e.type == DioErrorType.CONNECT_TIMEOUT)
        message = "连接超时";
      else if (e.type == DioErrorType.RECEIVE_TIMEOUT)
        message = "请求超时";
      else if (e.type == DioErrorType.RESPONSE) {
        message = "Not found ${e.response.statusCode}";
      }
      return Future.error(message);
    }
  }
}
