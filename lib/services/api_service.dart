import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';
import 'package:another_telephony/telephony.dart';
class ApiService {
  static const String baseUrl = 'http://192.168.1.205:8000';

  static Future<List<Transaction>> fetchTransactions() async {
    final response = await http.get(Uri.parse('$baseUrl/transactions'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch transactions');
    }
  }

  static Future<Map<String, dynamic>> register(String phone, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"phone": phone, "email": email}),
    );

    return _parseResponse(response);
  }

  static Future<Map<String, dynamic>> login(String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"phone": phone}),
    );

    return _parseResponse(response);
  }

  static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"phone": phone, "otp": otp}),
    );

    return _parseResponse(response);
  }

  static Future<Map<String, dynamic>> verifyLoginOtp(String phone, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-login-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      final error = jsonDecode(response.body)['detail'] ?? 'Unknown error';
      return {'success': false, 'error': error};
    }
  }

  static Future<Map<String, dynamic>> classifyMessages() async {
    try {
      final Telephony telephony = Telephony.instance;
      final bool? granted = await telephony.requestPhoneAndSmsPermissions;

      if (granted != true) return {'success': false, 'error': 'Permission denied'};

      final smsList = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );

      final payload = smsList.map((sms) => {
        'sender': sms.address ?? '',
        'content': sms.body ?? ''
      }).toList();

      print(payload);
      final response = await http.post(
        Uri.parse('$baseUrl/classify-sms'), // Use your configured baseUrl
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'messages': payload}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        return {'success': true, 'messages': data};
      } else {
        return {'success': false, 'error': response.body};
      }
    } catch (e) {
      return {'success':false, 'error': e.toString()};
    }
  }

  static Map<String, dynamic> _parseResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return {"success": true, "data": body};
    } else {
      return {"success": false, "error": body["detail"] ?? "Unknown error"};
    }
  }

}

