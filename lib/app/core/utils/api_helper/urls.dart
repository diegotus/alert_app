// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

class Url {
  static final String _url = kDebugMode
      ? ((kIsWeb || Platform.isAndroid)
          ? "http://localhost:3000/"
          : "http://10.0.2.2:3000/")
      : kIsWeb
          ? "${Uri.base.origin}/"
          : "https://leh.ht/";
  static final String BASE_URL = _url;
  static final String SOCKET_URL = "${BASE_URL}chat_socket";
  static const LOGIN = "auth/signin";
  static const REQUEST_AUTH = "auth/request_auth";
  static const VERIFY_AUTH = "auth/verify_auth";

  static const REGISTER = "auth/signup";
  static const SIGN_OUT = "auth/signout";
  static const VERIFY_REGISTER = "auth/verifysignup";
  static const RESEND_OTP = "auth/resend_otp";
  static const LOAN_REQUEST = "loan";
  static const GET_MESSAGE = "chat/messages/";
  static const USER_LIST = "user/check_contacts";
  static const USER_SAVE_CONTACTS = "user/save_contacts";
  static const BALANCE = "user/balance";
  static const CHAT_LIST = "chat";
  static const CASH_IN = "cash/in";
  static const CASH_DETAIL = "cash/thankyou/";
  static const CASH_DETAIL_METHOD = "cash/paymentReport/";
  static const CASH_FEE = "cash/getFees";
  static const LOAN_OFFER = "loan/offer/";
  static const ADDRESS_APPROVAL = "user/addressapproval";
  static const TRANSACTIONS = "transactions/";
  static const RECENT_TRANSACTIONS = "transactions/recentTransactions";
  static const TRANSFER_MONEY = "transactions/validate_transfer";
  static const GET_VALIDATION_INFO = "transactions/getValidationInfo";
  static const GET_BILLET_TRANS_DETAILS = "transactions/getBilletTransDetail";
  static const TCHALA = "tyala/";

  static const LOAN_ACCEPT_OFFER = "loan/accept_offer/";
  static const LOAN_REJECT_OFFER = "loan/reject_offer/";
  static const LOAN_ACCEPT = "loan/accept_loan/";
  static const LOAN_GIVEN = "loan/given/";
  static const LOAN_RECEIVED = "loan/received/";
  static const RESET_PASSWORD = "auth/reset_password";
  static const LOAN_CONTACTS = "loan/contacts/";
  static const GET_PROFILE_DETAILS = "user/profile";
  static const UPLOAD_PROFILE_IMAGE = "files/avatar";
  static const UPDATE_PROFILE = "user";
  static const UPDATE_USERINFO = "user/userInfo";
  static const UPDATE_USER_DOCS = "user/updateDocs";
  static const UPLOAD_IDENTITY = "files/identity";
  static const UPLOAD_ADDRESS = "files/documents/address/";
  static const UPLOAD_INCOME = "files/documents/income";
  static const UPLOAD_OCCUPATION = "files/documents/occupation";
  static const USER_ADDRESS = "user/address/";
  static const GET_ADDRESS_MARKET = "user/addressmarket";
  static const HELP_CENTER = "help_center";

  static const NEXT_TIRAGE_API = "tirage/next_tirage_date";

  static const tickets = "billet";
  static const ticketDetail = "$tickets/game_of_Billet";
  static const JWE_GAME = "$tickets/jwe";
  static const TICKET_RECEIPT = "$tickets/receipt";

  static const TIRAGE_RESULTS = "tirage/result";
}
