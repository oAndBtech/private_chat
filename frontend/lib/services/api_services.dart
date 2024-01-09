import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  String backendUrl = "${dotenv.env['backendIp']!}:${dotenv.env['port']!}";
  
  

}