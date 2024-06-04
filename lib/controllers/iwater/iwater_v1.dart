class IWaterConvertor {
   OwnerDetailsConvertor ownerDetails;
   DeviceDetailsConvertor deviceDetails;
  final List<MembersConvertor> members;
  final String id;

  IWaterConvertor({
    required this.ownerDetails,
    required this.members,
    required this.deviceDetails,
    required this.id,
  });

  factory IWaterConvertor.fromJson(Map<String, dynamic> json) {
    return IWaterConvertor(
      id: json['id'],
      ownerDetails: OwnerDetailsConvertor.fromJson(json['ownerDetails']),
      deviceDetails: DeviceDetailsConvertor.fromJson(json['deviceDetails']),
      members: (json['members'] as List)
          .map((item) => MembersConvertor.fromJson(item))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerDetails': ownerDetails.toJson(),
      'deviceDetails': deviceDetails.toJson(),
      'members': members.map((member) => member.toJson()).toList(),
    };
  }

  static List<IWaterConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => IWaterConvertor.fromJson(item)).toList();
  }
}
  class StoringDataConvertor {
  final String heading,id;



  StoringDataConvertor({
    required this.heading,
    required this.id,

  });

  Map<String, dynamic> toJson() =>
      {
        "id":id,
        "heading": heading,

      };

  static StoringDataConvertor fromJson(Map<String, dynamic> json) =>
      StoringDataConvertor(
        id: json["id"],
        heading: json["heading"],
      );

  static List<StoringDataConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
class DeviceDetailsConvertor {
   String name,initialPassword,updatedPassword,dom,model;



  DeviceDetailsConvertor({
    required this.name,

    required this.dom,
    required this.initialPassword,
    required this.model,
    required this.updatedPassword,


  });

  Map<String, dynamic> toJson() =>
      {
        "name": name,
        "model": model,
        "dom": dom,
        "initialPassword": initialPassword,
        "updatedPassword": updatedPassword,

      };

  static DeviceDetailsConvertor fromJson(Map<String, dynamic> json) =>
      DeviceDetailsConvertor(
        name: json["name"],
        dom: json["dom"],
        model: json["model"],
        updatedPassword: json["updatedPassword"],
        initialPassword: json["initialPassword"],
      );

  static List<DeviceDetailsConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
class OwnerDetailsConvertor {
  final String name,id;



  OwnerDetailsConvertor({
    required this.name,
    required this.id,

  });

  Map<String, dynamic> toJson() =>
      {
        "id":id,
        "name": name,

      };

  static OwnerDetailsConvertor fromJson(Map<String, dynamic> json) =>
      OwnerDetailsConvertor(
        id: json["id"],
        name: json["name"],
      );

  static List<OwnerDetailsConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
class MembersConvertor {
  final String heading,id;



  MembersConvertor({
    required this.heading,
    required this.id,

  });

  Map<String, dynamic> toJson() =>
      {
        "id":id,
        "heading": heading,

      };

  static MembersConvertor fromJson(Map<String, dynamic> json) =>
      MembersConvertor(
        id: json["id"],
        heading: json["heading"],
      );

  static List<MembersConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
