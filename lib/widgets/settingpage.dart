
import 'package:flutter/material.dart';
import 'package:spendhelper/handler/dbmanager.dart';
import 'package:spendhelper/drawer/mydrawer.dart';
import 'package:spendhelper/drawer/bottomnavigation.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}
 
class _SettingPageState extends State<SettingPage> {
  final DbManager dbManager = new DbManager();
 
  Model? model;
  List<Model>? modelList;
  TextEditingController nameTextController = TextEditingController();
  TextEditingController ageTextController = TextEditingController();
 
  @override
  void initState() {
    super.initState();
  }
 
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: MyDrawer("Settings"),
      bottomNavigationBar: BottomNavigation(4),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return DialogBox().dialog(
                  context: context,
                  onPressed: () async{
                    Model model = new Model(
                        key: nameTextController.text, value: ageTextController.text);
                    int? id =   await dbManager.insertData(model) ;
                    print("data inserted  ${id}" );
                    WidgetsBinding.instance.addPostFrameCallback((_){
                      setState(() {
                        nameTextController.text = "";
                        ageTextController.text = "";
                      });
                      Navigator.of(context).pop();
                    });
 
 
                  },
                  textEditingController1: nameTextController,
                  textEditingController2: ageTextController,
                 /* nameTextFocusNode: nameTextFocusNode,
                  ageTextFocusNode: ageTextFocusNode,*/
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
        future: dbManager.getDataList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            modelList = snapshot.data as List<Model>?;
            return ListView.builder(
              itemCount: modelList?.length,
              itemBuilder: (context, index) {
                Model _model = modelList![index];
                return ItemCard(
                  model: _model,
                  nameTextController: nameTextController,
                  ageTextController: ageTextController,
                  onDeletePress: () {
                    dbManager.deleteData(_model);
                    WidgetsBinding.instance.addPostFrameCallback((_){
 
                      setState(() {});
 
                    });
 
 
                  },
                  onEditPress: () {
                    nameTextController.text = _model.key??"";
                    ageTextController.text = _model.key??"";
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogBox().dialog(
                              context: context,
                              onPressed: () {
                                Model __model = Model(
                                    id: _model.id,
                                    key: nameTextController.text,
                                    value: ageTextController.text);
                                dbManager.updateData(__model);
                                WidgetsBinding.instance.addPostFrameCallback((_){
 
                                  setState(() {
                                    nameTextController.text = "";
                                    ageTextController.text = "";
                                  });
 
                                });
 
                                Navigator.of(context).pop();
                              },
                              textEditingController2: ageTextController,
                              textEditingController1: nameTextController);
                        });
                  },
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
 
class DialogBox {
  Widget dialog(
      {BuildContext? context,
        Function? onPressed,
        TextEditingController? textEditingController1,
        TextEditingController? textEditingController2,
        /*FocusNode? nameTextFocusNode,
        FocusNode? ageTextFocusNode*/}) {
    return AlertDialog(
      title: Text("Enter Keys Data"),
      content: Container(
        height: 100,
        child: Column(
          children: [
            TextFormField(
              controller: textEditingController1,
              keyboardType: TextInputType.text,
             // focusNode: nameTextFocusNode,
              decoration: InputDecoration(hintText: "Enter key name "),
              /*autofocus: true,*/
              onFieldSubmitted: (value) {
                //nameTextFocusNode?.unfocus();
                //FocusScope.of(context!).requestFocus(ageTextFocusNode);
              },
            ),
            TextFormField(
              controller: textEditingController2,
              keyboardType: TextInputType.number,
              //focusNode: ageTextFocusNode,
              decoration: InputDecoration(hintText: "enter key value"),
              onFieldSubmitted: (value) {
              //  ageTextFocusNode?.unfocus();
              },
            ),
          ],
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.of(context!).pop();
          },
          color: Colors.blue,
          child: Text(
            "Cancel",
          ),
        ),
        MaterialButton(
          onPressed:(){
            onPressed!();
          } /*onPressed!()*/,
          child: Text("Save"),
          color: Colors.blue,
        )
      ],
    );
  }
}
 
 
 
 
class ItemCard extends StatefulWidget {
  Model? model;
  TextEditingController? nameTextController;
  TextEditingController? ageTextController;
  Function? onDeletePress;
  Function? onEditPress;
 
  ItemCard(
      {this.model,
        this.nameTextController,
        this.ageTextController,
        this.onDeletePress,
        this.onEditPress});
 
  @override
  _ItemCardState createState() => _ItemCardState();
}
 
class _ItemCardState extends State<ItemCard> {
  final DbManager dbManager = new DbManager();
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Name: ${widget.model?.key}',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    'key: ${widget.model?.value}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: (){
                        widget.onEditPress!();
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: (){widget.onDeletePress!();},
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
