import 'package:club_app/repository/club_app_data_source.dart';
import 'package:club_app/repository/club_app_remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ClubAppRepository extends ClubAppDataSource {
  ClubAppRepository();

  ClubAppRemoteDataSource clubAppRemoteDataSource = ClubAppRemoteDataSource();

  @override
  Future<Response> loginUser(String username, String password) async {
    return clubAppRemoteDataSource.loginUser(username, password);
  }

  Future<Response> loginGoogleUser(
      String email, String firstName, String lastName) {
    return clubAppRemoteDataSource.loginGoogleUser(email, firstName, lastName);
  }

  @override
  Future<Response> signUpUser(String name, String email, String password,
      String confirmPassword, String gender, String phone) async {
    return clubAppRemoteDataSource.signUpUser(
        name, email, password, confirmPassword, gender, phone);
  }

  @override
  Future<Response> getEvents(
      {String startDate = '',
      String endDate = '',
      int page = -1,
      int volume = 10}) async {
    return clubAppRemoteDataSource.getEvents(
        startDate: startDate, endDate: endDate, page: page, volume: volume);
  }

  @override
  Future<Response> getCurrency() async {
    return clubAppRemoteDataSource.getCurrency();
  }

  @override
  Future<Response> getEventsSeats(int eventId) async {
    return clubAppRemoteDataSource.getEventsSeats(eventId);
  }

  @override
  Future<Response> getEventsSeatsAvailability(int eventSeatId) async {
    return clubAppRemoteDataSource.getEventsSeatsAvailability(eventSeatId);
  }

  Future<Response> getVouchers(
      {int page = 1, int volume = 10, String type = ''}) {
    return clubAppRemoteDataSource.getVouchers(
        page: page, volume: volume, type: type);
  }

  @override
  Future<Response> updateGuestList(String name, String email,
      String phoneNumber, int menCount, int womenCount, String referenceName) {
    return clubAppRemoteDataSource.updateGuestList(
        name, email, phoneNumber, menCount, womenCount, referenceName);
  }

  Future<Response> addToCart(int eventId, int guestId, int quantity) {
    return clubAppRemoteDataSource.addToCart(eventId, guestId, quantity);
  }

  Future<Response> addAddonToCart(
      int addonId, String cartIds, int quantity, String addOnFor) {
    return clubAppRemoteDataSource.addAddonToCart(
        addonId, cartIds, quantity, addOnFor);
  }

  @override
  Future<Response> deleteAddonfromCart(int addonCartId) {
    return clubAppRemoteDataSource.deleteAddonfromCart(addonCartId);
  }

  @override
  Future<Response> deleteTablefromCart(int tableId) {
    return clubAppRemoteDataSource.deleteTablefromCart(tableId);
  }

  @override
  Future<Response> deleteEventfromCart(int eventId) {
    return clubAppRemoteDataSource.deleteEventfromCart(eventId);
  }

  @override
  Future<Response> deleteCartItem(String type, int guestId) {
    return clubAppRemoteDataSource.deleteCartItem(type, guestId);
  }

  @override
  Future<Response> fetchTableCartList(String userId) {
    return clubAppRemoteDataSource.fetchTableCartList(userId);
  }

  @override
  Future<Response> fetchCartList(String userId) {
    return clubAppRemoteDataSource.fetchCartList(userId);
  }

  @override
  Future<Response> fetchAddOnList() {
    return clubAppRemoteDataSource.fetchAddOnList();
  }

  @override
  Future<Response> fetchBiddingList() {
    return clubAppRemoteDataSource.fetchBiddingList();
  }

  @override
  Future<Response> updateBid(List<Map<String, dynamic>> bidList) {
    return clubAppRemoteDataSource.updateBid(bidList);
  }

  Future<Response> getUserProfile(String userId) {
    return clubAppRemoteDataSource.getUserProfile(userId);
  }

  Future<Response> getStripeKeys() {
    return clubAppRemoteDataSource.getStripeKeys();
  }

  Future<Response> updateUserProfile(String userId, String name, String gender,
      String nationality, String phone, String email) {
    return clubAppRemoteDataSource.updateUserProfile(
        userId, name, gender, nationality, phone, email);
  }

  Future<Response> createPayment(String userId, String name, String email,
      String phone, String rate, String paymentMethod) {
    return clubAppRemoteDataSource.createPayment(
        userId, name, email, phone, rate, paymentMethod);
  }

  Future<Response> completePayment(
    String expectedArrival,
    String name,
    String currency,
    String email,
    String amount,
    String balanceTransaction,
    String orderId,
    String guestId,
    String cartGuestId,
    String status,
  ) {
    return clubAppRemoteDataSource.completePayment(
      expectedArrival,
      name,
      currency,
      email,
      amount,
      balanceTransaction,
      orderId,
      guestId,
      cartGuestId,
      status,
    );
  }

  Future<Response> registerDeregisterToken(
      String token, int guestId, bool isRegister) {
    return clubAppRemoteDataSource.registerDeregisterToken(
        token, guestId, isRegister);
  }

  Future<Response> getUserBookings(String userId) {
    return clubAppRemoteDataSource.getUserBookings(userId);
  }

  @override
  Future<Response> checkoutEventBookings(String userId, int eventId,
      List<Map<String, dynamic>> eventCategory) async {
    return clubAppRemoteDataSource.checkoutEventBookings(
        userId, eventId, eventCategory);
  }

  @override
  Future<Response> checkoutTableBookings(
      String userId, List<Map<String, dynamic>> daybed) async {
    return clubAppRemoteDataSource.checkoutTableBookings(userId, daybed);
  }

  @override
  Future<Response> checkoutVoucherBookings(
      String userId, List<int> vouchers) async {
    return clubAppRemoteDataSource.checkoutVoucherBookings(userId, vouchers);
  }

  @override
  Future<Response> forgetPassword(String email) async {
    return clubAppRemoteDataSource.forgetPassword(email);
  }

  @override
  Future<Response> verify(String bookingUid) async {
    return clubAppRemoteDataSource.verify(bookingUid);
  }

  Future<Response> getNotifications(
      {@required String userId, @required int page, int volume = 10}) {
    return clubAppRemoteDataSource.getNotifications(
        userId: userId, page: page, volume: volume);
  }

  @override
  Future<Response> fetchBookings(String userId) {
    return clubAppRemoteDataSource.fetchBookings(userId);
  }
}
