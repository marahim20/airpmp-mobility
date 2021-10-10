import 'package:airpmp_mobility/API/ResourceClasses.dart';
import 'package:airpmp_mobility/Components/simpleTable.dart';
import 'package:airpmp_mobility/Components/tableElement.dart';
import 'package:airpmp_mobility/Constants/Classes.dart';
import 'package:airpmp_mobility/Constants/Colors.dart';
import 'package:airpmp_mobility/Constants/Enums.dart';
import 'package:airpmp_mobility/Constants/Fonts_Styles.dart';
import 'package:airpmp_mobility/Models/ProviderModel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActualResourcesPhone extends StatelessWidget {
  final Function onPush;
  final Resource resource;
  final MyJobCard jobCard;
  bool isSameResource(bool iseq) {
    if (iseq && resource == Resource.Equipment)
      return true;
    else if (!iseq && resource == Resource.Employee)
      return true;
    else
      return false;
  }

  void openPopUp(SingleEquipment singleEquipment, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 35),
            title: Text(
              resource == Resource.Equipment ? "Add Equipment" : "Add Employee",
              textAlign: TextAlign.center,
            ),
            // contentPadding: const EdgeInsets.all(15.0),
            children: [
              Text(
                singleEquipment.make + " " + singleEquipment.model,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                singleEquipment.id,
              ),
              Container(
                child: TextField(
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(hintText: "Number of Hours"),
                ),
              ),
              TextField(
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(hintText: "Remarks"),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  TextButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: CustomColors.secondary,
                    onPressed: () {
                       //TODO: PUT FUNTION HERE
                    },
                  ),
                ],
              )
            ],
          );
        });
  }

  const ActualResourcesPhone(
      {Key? key,
      required this.resource,
      required this.onPush,
      required this.jobCard})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(24)),
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/appBarBG.png",
                ),
                fit: BoxFit.cover,
              )),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(24))),
        title: Text("Job Card Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              // margin: EdgeInsets.all(20.0),
              color: Colors.white,
              child: Container(
                height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: FutureBuilder<List>(
                            future: Provider.of<ProviderModel>(context)
                                .getEquipments(resource),
                            initialData: [],
                            builder: (futcontext, snapshot) {
                              return DropdownSearch<dynamic>(
                                  mode: Mode.MENU,
                                  dropdownSearchDecoration: InputDecoration(
                                      border: InputBorder.none, enabled: true),
                                  dropDownButton: Container(),
                                  itemAsString: (se) {
                                    return "[" + se!.id + "] " + se.type;
                                  },
                                  items: snapshot.data,
                                  showSearchBox: true,
                                  maxHeight: 300,
                                  onChanged: (s) {
                                    openPopUp(s!, context);
                                  },
                                  emptyBuilder: (context, e) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  },
                                  loadingBuilder: (context, e) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  });
                            }),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: TextButton(
                          child: Icon(Icons.search, color: Colors.white),
                          onPressed: () {},
                        ),
                        decoration: BoxDecoration(
                            color: CustomColors.secondary,
                            borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(20))),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Actual Employees",
                    style: TextStyle(fontSize: 20, color: Color(0xdd7B9990))),
              ),
            ),
            Expanded(
                child: SimpleTable(
              headings: [
                TableElement("ID", flex: 2),
                TableElement("Name", flex: 3),
                TableElement("Designation", flex: 3),
                TableElement("Total Hrs", flex: 2, maxLines: 2),
                TableElement("Remarks", flex: 2),
              ],
              elements: [
                for (ActualResource resource in jobCard.actuals)
                  if (isSameResource(resource.isEquipment))
                    SimpleTableElement(
                      onTap: null,
                      datas: [
                        TableValueElement(resource.iD, maxLines: 2),
                        TableValueElement(resource.name, maxLines: 2),
                        TableValueElement(resource.designation, maxLines: 2),
                        TableValueElement(resource.actualHours, maxLines: 2),
                        TableValueElement(resource.remarks, maxLines: 2),
                      ],
                    ),
              ],
            ))
          ],
        ),
      ),
      floatingActionButton: Container(
          // width: 100,
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
              color: CustomColors.secondary,
              borderRadius: BorderRadius.circular(40)),
          child: InkWell(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Proceed",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                Icon(Icons.arrow_forward_ios, color: Colors.white)
              ],
            ),
          )),
    );
  }
}
