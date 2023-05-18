class Person{
  final int id;
  final String name,gender,image;
  final int age;
  static const keyid="id";
  static const keyname="name";
  static const keygender="gender";
  static const keyage="age";
  static const keyimage="image";

  Person({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.image,
  });

  Map<String,dynamic> fromJson(){
    return {
      keyid:id,
      keyname:name,
      keygender:gender,
      keyage:age,
      keyimage:image
    };
  }

  Person.toJson(Map<String,dynamic> res)
  : id = res[keyid],
    name = res[keyname],
    gender = res[keygender],
    age = res[keyage],
    image = res[keyimage];
}