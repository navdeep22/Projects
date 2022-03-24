class ClubApp {
  static const String app_name = 'Club App';

  static const String access_token = 'access_token';

  static const String GOOGLE_LOGIN_KEY = 'F3kpPC8khRNy9u20l2nS5K5FflLQVsOT';

  //https://api.thetwelve25.teaseme.co.in/api/
//  static const String BASE_URL = 'https://oxygenadmin.bookbeachclub.com/api/';
  // static const String BASE_URL = 'https://api.thetwelve25.teaseme.co.in/api/';
  static const String BASE_URL = 'https://faces-demo.booknbite.com/api/';
  //'https://api.thetwelve25.teaseme.co.in/';
  //'https://api.dream.bookbeachclub.com/api/';
  static const String url_login = BASE_URL + 'guests/login';
  static const String url_sign_up = BASE_URL + 'guests/register';
  static const String url_get_events = BASE_URL + 'events';
  static const String url_get_currency = BASE_URL + 'settings';
  static const String url_get_event_seats = BASE_URL + 'events/seats/';
  static const String url_get_event_seats_available =
      BASE_URL + 'events/seat_available/';
  static const String url_get_vouchers = BASE_URL + 'vouchers';
  static const String url_update_guest_list =
      BASE_URL + 'guests/updateguestlist';
  static const String url_get_table_cart_list = BASE_URL + 'cart/';
  static const String url_get_booking_list = BASE_URL + '/booking/userbooking/';
  static const String url_get_add_ons_list = BASE_URL + 'addon';
  static const String url_get_bidding_list = BASE_URL + 'bids';
  static const String url_update_bids = BASE_URL + 'bids/update';
  static const String url_user_profile = BASE_URL + 'guests/get/';
  static const String get_stripe_keys = BASE_URL + 'payment/stripe';
  static const String url_update_user_profile = BASE_URL + 'guests/update';
  static const String firebase_token = BASE_URL + 'firebase/token';
  static const String get_user_bookings = BASE_URL + 'guests/';
  static const String checkout_user_bookings = BASE_URL + 'checkout/update';
  static const String api_forget_password = BASE_URL + 'guests/forgetPassword';
  static const String verify_code = BASE_URL + 'checkout/verify';
  static const String get_notifications = BASE_URL + 'firebase/notifications/';
  static const String add_to_cart = BASE_URL + 'events/add_cart';
  static const String add_addon_to_cart = BASE_URL + 'addon/add_cart';
  static const String remove_from_cart = BASE_URL + 'cart/remove';
  static const String remove_addon_from_cart = BASE_URL + 'addon/remove/';
  static const String remove_table_from_cart = BASE_URL + 'cart/remove/cart/';
  static const String remove_event_from_cart = BASE_URL + 'cart/remove/event/';
  static const String create_payment = BASE_URL + 'checkout/create_payment';
  static const String complete_payment = BASE_URL + 'payment/completepayment';

  static const String heading_login = 'Login';
  static const String email_empty_msg = 'Please enter email';
  static const String enter_valid_email = 'Please enter valid email address';
  static const String login = 'Login';
  static const String sign_in = 'Sign in';
  static const String btn_submit = 'Submit';
  static const String btn_book = 'Book';
  static const String btn_checkout = 'Checkout';
  static const String btn_go_cart = 'Go To Cart';
  static const String btn_proceed = 'Proceed';
  static const String hint_user_name = 'Email';
  static const String hint_password = 'Password';
  static const String hint_confirm_password = 'Confirm password';
  static const String hint_gender = 'Gender';
  static const String hint_place_of_residence = 'Place of residence';
  static const String hint_phone = 'Phone';
  static const String remember_me = 'Remember Me';
  static const String password_empty_msg = 'Please enter password';
  static const String confirm_password_empty_msg =
      'Please enter confirm password';
  static const String password_un_match_msg =
      'Password and Confirm password should be same';
  static const String dob_empty_msg = 'Please select date of birth';
  static const String por_empty_msg = 'Please enter place of residency';
  static const String phone_empty_msg = 'Please enter phone number';
  static const String phone_valid_msg = 'Please enter valid phone number';
  static const String register_success_message =
      'User signed up successful!!\n\nPlease login with your email address and password.';

  static const String reset_password_text = 'Reset Password';
  static const String forget_password = 'Forgot Password?';
  static const String label_or = 'OR';
  static const String label_dont_have_account = 'Don\'t have an account?';
  static const String label_sign_up = 'Sign up';
  static const String label_update_profile = 'Update Profile';
  static const String already_have_account = 'Already have an account?';

  static const String hint_event_filter_date = 'Select event date';
  static const String hint_name = 'Name';
  static const String hint_mobile = 'Mobile number';
  static const String hint_email = 'Email';
  static const String hint_dob = 'Date of Birth';
  static const String hint_vehicle_make = 'Vehicle make';
  static const String hint_vehicle_model = 'Vehicle model';
  static const String hint_battery_capacity = 'Battery Capacity';
  static const String hint_reg_no = 'Vehicle Reg. no.';
  static const String hint_address = 'Address';
  static const String name_empty_msg = 'Please enter name';
  static const String mobile_empty_msg = 'Please enter mobile number';
  static const String vehicle_make_empty_msg = 'Please enter vehicle make';
  static const String vehicle_model_empty_msg = 'Please enter vehicle model';
  static const String battery_capacity_empty_msg =
      'Please enter battery capacity';
  static const String reg_no_empty_msg = 'Please enter vehicle reg. no.';
  static const String address_empty_msg = 'Please enter address';
  static const String sign_up = 'Sign Up';

  //Shared Preferences
  static const String loginSuccess = 'loginSuccess';
  static const String userId = 'userId';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String gender = 'gender';
  static const String phone = 'phone';
  static const String email = 'email';
  static const String status = 'status';

  static const String no_internet_message =
      'No internet connection. Please reconnect and try again';
  static String somethingWrong = 'Something went wrong.';

  static const String no_event_seats_available =
      'No Seats available for booking';
  static const String empty_table_cart_message =
      'Cart empty. Please book table to checkout';
  static const String seats_capacity_reached =
      'Seats capacity reached for booking';
  static const String notification = "Notification";
  static const String guest_list = "Guest List";
  static const String guest_list_info =
      "Fill out the below information. Once confirmed, you will receive an email confirmation.";
  static const String request = "Request";
  static const String men_count = "# of Men";
  static const String women_count = "# of Women";
  static const String reference_name = "Reference Name";
  static const String enter_guest_count = "Please enter men or women count";
  static const String guest_list_request =
      "Your request has been submitted successfully. We will notify you once approved";
  static const String enter_correct_count =
      "Please enter correct men or women count";
  static const String enter_valid_mobile_number =
      "Please enter valid mobile number";
  static const String request_bid = "Request to Bid";
  static const String bid_request =
      "Your bid has been submitted successfully. We will notify you once approved";
  static const String bid_request_warning =
      "Please update bid value before requesting";
  static const String event_booking_warning = "Please add event booking first";
  static const String voucher_booking_warning = "Please add voucher first";
  static const String table_booking_warning = "Please add table first";

  static const String btn_remove_table = 'Remove';
  static const String tickets = "Tickets";
  static const String tables = "Tables";
  static const String tablesEvents = "Booking";
  static const String vouchers = "Vouchers";
  static const String reference_empty_msg = "Reference is empty";
  static const String token = "token";
  static  String currencyLbl = "";
  static const String added_to_cart = "successfully added to cart";
}
