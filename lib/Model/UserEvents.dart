class UserEvents {
  List<Events> events;

  UserEvents({this.events});

  UserEvents.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      events = new List<Events>();
      json['events'].forEach((v) {
        events.add(new Events.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.events != null) {
      data['events'] = this.events.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Events {
  int id;
  String eventName;
  String eventPhoto;
  VendorName vendorName;
  bool refundAvailable;
  String website;
  int shareCount;
  int checkInCount;
  String streetAddress;
  String city;
  String state;
  String zipcode;
  String eventTagline;
  String details;
  String startDate;
  String startTime;
  String endTime;
  List<Attendees> attendees;

  Events(
      {this.id,
      this.eventName,
      this.eventPhoto,
      this.vendorName,
      this.refundAvailable,
      this.website,
      this.shareCount,
      this.checkInCount,
      this.streetAddress,
      this.city,
      this.state,
      this.zipcode,
      this.eventTagline,
      this.details,
      this.startDate,
      this.startTime,
      this.endTime,
      this.attendees});

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventName = json['event_name'];
    eventPhoto = json['event_photo'];
    vendorName = json['vendor_name'] != null
        ? new VendorName.fromJson(json['vendor_name'])
        : null;
    refundAvailable = json['refund_available'];
    website = json['website'];
    shareCount = json['share_count'];
    checkInCount = json['check_in_count'];
    streetAddress = json['street_address'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    eventTagline = json['event_tagline'];
    details = json['details'];
    startDate = json['start_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    if (json['attendees'] != null) {
      attendees = new List<Attendees>();
      json['attendees'].forEach((v) {
        attendees.add(new Attendees.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['event_name'] = this.eventName;
    data['event_photo'] = this.eventPhoto;
    if (this.vendorName != null) {
      data['vendor_name'] = this.vendorName.toJson();
    }
    data['refund_available'] = this.refundAvailable;
    data['website'] = this.website;
    data['share_count'] = this.shareCount;
    data['check_in_count'] = this.checkInCount;
    data['street_address'] = this.streetAddress;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zipcode'] = this.zipcode;
    data['event_tagline'] = this.eventTagline;
    data['details'] = this.details;
    data['start_date'] = this.startDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    if (this.attendees != null) {
      data['attendees'] = this.attendees.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VendorName {
  int id;
  String vendor;

  VendorName({this.id, this.vendor});

  VendorName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendor = json['vendor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor'] = this.vendor;
    return data;
  }
}

class Attendees {
  int id;
  String name;
  String currentSelfie;

  Attendees({this.id, this.name, this.currentSelfie});

  Attendees.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    currentSelfie = json['current_selfie'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['current_selfie'] = this.currentSelfie;
    return data;
  }
}
