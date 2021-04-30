class NormalUser {
  String uid;
  String name;
  String email;
  String username;
  String status;
  int state;
  String profilePhoto;

  NormalUser({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.profilePhoto,
    this.state,
    this.status,
  });

  Map toMap(NormalUser normalUser) {
    var data = Map<String, dynamic>();
    data['uid'] = normalUser.uid;
    data['name'] = normalUser.name;
    data['email'] = normalUser.email;
    data['username'] = normalUser.username;
    data['status'] = normalUser.status;
    data['state'] = normalUser.state;
    data['profilePhoto'] = normalUser.profilePhoto;
    return data;
  }

  NormalUser.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profilePhoto'];
  }
}
