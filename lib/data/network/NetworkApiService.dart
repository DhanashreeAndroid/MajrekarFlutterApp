// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart';
import 'dart:convert';
import 'dart:developer';
import '../app_excaptions.dart';
import 'BaseApiServices.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class NetworkApiService extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future getPostApiResponse(
      String url, dynamic data, String encrptkey, String token) async {
    print("url $url");
    print("data $data");
    print("enc $encrptkey");
    print("token  $token");
    dynamic responseJson ;
    try {

     final response = await http.post(
       
        Uri.parse(url),
        headers:
         token.isEmpty ? {"meta": encrptkey,
         
          }  :
        {"meta": encrptkey,
         
         "token": token},
          body: data
      );
      // .timeout(Duration(seconds: 10));
      log(" post data ${response.body}");
      responseJson = returnResponse(response);
      
    }on SocketException {

      throw FetchDataException('No Internet Connection');
    }

    return responseJson ;
  }

  dynamic returnResponse (http.Response response){

    switch(response.statusCode){
      case 200:
        dynamic responseJson =
            // response.body;
        jsonDecode(response.body);
         print("decode $responseJson");
        return responseJson ;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException('Error accured while communicating with server'+
            'with status code' +response.statusCode.toString());

    }
  }

}