// To parse this JSON data, do
//
//     final stripeResponseModel = stripeResponseModelFromJson(jsonString);

import 'dart:convert';

StripeResponseModel stripeResponseModelFromJson(String str) => StripeResponseModel.fromJson(json.decode(str));

String stripeResponseModelToJson(StripeResponseModel data) => json.encode(data.toJson());

class StripeResponseModel {
    StripeResponseModel({
        this.status,
        this.error,
        this.data,
    });

    bool status;
    String error;
    List<StripeModel> data;

    factory StripeResponseModel.fromJson(Map<String, dynamic> json) => StripeResponseModel(
        status: json["status"],
        error: json["error"],
        data: List<StripeModel>.from(json["data"].map((x) => StripeModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class StripeModel {
    StripeModel({
        this.apiKey,
        this.publishableKey,
        this.currency,
        this.status,
    });

    String apiKey;
    String publishableKey;
    String currency;
    String status;

    factory StripeModel.fromJson(Map<String, dynamic> json) => StripeModel(
        apiKey: json["api_key"],
        publishableKey: json["publishable_key"],
        currency: json["currency"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "api_key": apiKey,
        "publishable_key": publishableKey,
        "currency": currency,
        "status": status,
    };
}
