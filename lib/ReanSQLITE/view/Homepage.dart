import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_storage11_12/ReanSQLITE/model/person_model.dart';
import 'package:flutter_local_storage11_12/ReanSQLITE/service/person_service.dart';
import 'package:image_picker/image_picker.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Person> listPerson=[];
  PersonService personService = PersonService();
  Future<void> onRefresh()async{
    final data = await personService.readPerson();
   setState((){
      listPerson = data;
   });
  }
  @override
  void initState() {
    super.initState();
    onRefresh();
  }
  void messageAlert(){
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Delete successful'
        ),
      duration: Duration(
        seconds: 2
      ),  
    ));
  }
  Future<void> deletePerson(int id)async{

    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Person'),
          content: const Text('Do you want to delete?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async{
                setState(() async{
                  await personService.deletePerson(
                    id
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  messageAlert();
                  onRefresh();
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
  }
  int inState=0;
  late int uid;
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  XFile? filepicker;
  File? fileimage;
  ImagePicker imagePicker = ImagePicker();
  String? pathImage;
  Future<void> getImage(String type)async{
   filepicker = await imagePicker.pickImage(source: type=="Camera" ? ImageSource.camera : ImageSource.gallery);
   if(filepicker!=null){
    setState(() {
      fileimage = File(filepicker!.path);
      List<int> byte = fileimage!.readAsBytesSync();
      pathImage = base64Encode(byte);
    });
   }
  }
  void clear(){
    pathImage=null;
    nameController.clear();
    genderController.clear();
    ageController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        leading: IconButton(
          onPressed: () {
            getImage('Gallery');
          },
          icon: const Icon(
            Icons.image
          ),
        ),
        centerTitle: true,
        title: const Text(
          'SQLITE'
        ),
        actions: [
          IconButton(
          onPressed: () {
            getImage('Camera');
          },
          icon: const Icon(
            Icons.camera_alt
          ),
        ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              height: 200,
              width: double.infinity,
              decoration: pathImage==null? BoxDecoration(
                borderRadius: BorderRadius.circular(
                  20
                ),
                border: Border.all(
                  width: 2,
                  color: Colors.grey
                )
               ) : BoxDecoration(
                //color: Colors.amber,
                borderRadius: BorderRadius.circular(
                  10
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(base64Decode(pathImage!))
                )
              ),
            ),
            Padding( 
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    10
                  )
                ),
                child:  TextField(
                controller: nameController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      nameController.clear();
                    }, 
                    icon: const Icon(
                      Icons.close
                    )
                    ),
                  hintText: 'Name',
                  border: InputBorder.none
                ),
              ),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    10
                  )
                ),
                child:  TextField(
                controller: genderController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      genderController.clear();
                    }, 
                    icon: const Icon(
                      Icons.close
                    )
                    ),
                  hintText: 'Gender',
                  border: InputBorder.none
                ),
              ),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    10
                  )
                ),
                child:  TextField(
                controller: ageController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      ageController.clear();
                    }, 
                    icon: const Icon(
                      Icons.close
                    )
                    ),
                  hintText: 'Age',
                  border: InputBorder.none
                ),
              ),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: List.generate(
                  listPerson.length, (index){
                    return  Card(
                    child: ListTile(
                      tileColor: Colors.pink.withOpacity(0.2),
                      leading:  CircleAvatar(
                        radius: 30,
                        backgroundImage: MemoryImage(base64Decode(listPerson[index].image)),
                      ),
                      title:  Text(
                        listPerson[index].name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      subtitle:  Text(
                        '${listPerson[index].gender}, ${listPerson[index].age}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  inState=1;
                                  uid=listPerson[index].id;
                                  pathImage=listPerson[index].image;
                                  nameController.text=listPerson[index].name;
                                  genderController.text=listPerson[index].gender;
                                  ageController.text=listPerson[index].age.toString();
                                });
                              }, 
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.amber,
                              )
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                    deletePerson(
                                      listPerson[index].id
                                    );
                                });
                              }, 
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                   );
                  }),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.redAccent
              )
            ),
            onPressed: () {
              setState(() {
                clear();
                inState=0;
              });
            }, 
            child: const Text(
              'Cancel'
            )
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.blue
              )
            ),
            onPressed: () {
              if(inState==0){ // Save
                setState(()async {
                Random random = Random();
                 await personService.createPerson(Person(
                  id: random.nextInt(500), 
                  name: nameController.text, 
                  gender: genderController.text, 
                  age: int.parse(ageController.text), 
                  image: pathImage ?? ''
                ));
                clear();
                onRefresh();
              });
              }else{ //Update
               setState(() async{
                 inState=0;
                 await personService.updatePerson(
                  Person(
                  id: uid, 
                  name: nameController.text, 
                  gender: genderController.text, 
                  age: int.parse(ageController.text), 
                  image: pathImage ?? ''
                 ));
                 onRefresh();
                 clear();
               });
              }

            }, 
            child: inState==0 ? const Text(
              ' Save '
            ) : const Text(
              'Update'
            )
          ) 
        ],
      ),
    );
  }
}