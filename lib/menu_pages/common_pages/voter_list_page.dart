import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/model/DataModel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../database/ObjectBox.dart';
import 'VoterItem.dart';
import 'detail_page.dart';

class VoterListPage extends StatefulWidget {
  final String searchType;
  final String buildingName;
  final String language;
  const VoterListPage({Key? key ,required this.searchType, required this.buildingName, required this.language}) : super(key: key);

  @override
  State<VoterListPage> createState() => _VoterListPageState();
}

class _VoterListPageState extends State<VoterListPage> {
   List<EDetails> voterList = [];
  bool isLoading = false;
  // This list holds the data for the list view
  List<EDetails> _foundUsers = [];
  TextEditingController surnameController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    setState(() => isLoading = true);
    if (widget.searchType == "BuildingWise") {
      this.voterList =
          await ObjectBox.getAllBuildingWiseData(widget.buildingName);
      isVisible = true;
    } else if (widget.searchType == "SurnameCount") {
      this.voterList =
          await ObjectBox.getSurnameCounterVoterList(widget.buildingName);
      isVisible = true;
    } else if (widget.searchType == "LanguageWise") {
      this.voterList = await ObjectBox.getLanguageWiseVoterList(
          widget.buildingName, widget.language);
      isVisible = true;
    }else if(widget.searchType == "AgeWise"){
      this.voterList = await ObjectBox.getAgeWiseVoterList(widget.buildingName, widget.language);
      isVisible = true;
    }else if(widget.searchType == "SerialWise"){
      this.voterList = await ObjectBox.getSerialWiseVoterList(widget.buildingName);
      isVisible = true;
    }else {
      this.voterList = await ObjectBox.getAll(widget.searchType);
      isVisible = false;
    }
    // at the beginning, all users are shown
    _foundUsers = voterList;
    setState(() => isLoading = false);
  }

  void search(String query) {
    final RegExp english = RegExp(r'^[a-zA-Z]+');
    if (query.isEmpty) {
      _foundUsers = voterList;
      setState(() {});
      return;
    }

    query = query.toLowerCase();
    print(query);
    List<EDetails> result = [];
    voterList.forEach((p) {
      var name = "${p.lnEnglish.toString().toLowerCase()} ${p.fnEnglish.toString().toLowerCase()}";
      var marathiName = "${p.lnMarathi.toString().toLowerCase()} ${p.fnMarathi.toString().toLowerCase()}";
      if (english.hasMatch(query)){
        if (name.contains(query)) {
          result.add(p);
        }
      }else{
        if (marathiName.contains(query)) {
          result.add(p);
        }
      }

    });

    _foundUsers = result;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async{
       Navigator.pop(context);
       return false;
    },
    child: SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(218,222,224, 1),
        body: Column(
          children: [
            CommonHeader(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            const SizedBox(
              height: 5,
            ),
           /* getSurnameInputs(),
            const SizedBox(
              height: 5,
            ),*/
            voterList.isNotEmpty?
            const AutoSizeText(
              "Please click on below voter names",
              maxLines: 1,
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ) : const SizedBox(),

            /*Expanded(
              child: _foundUsers.isNotEmpty
                  ? ListView.builder(
                itemCount: _foundUsers.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(_foundUsers[index].id),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  child: ListTile(
                    tileColor: const Color.fromRGBO(218,222,224, 1),
                    leading: getLeadingText(index),
                    minLeadingWidth : 1,
                    title: getTextViewEnglish(index, widget.searchType),
                    subtitle: getTextViewMarathi(index, widget.searchType),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) =>  DetailPage(data : _foundUsers[index], searchType: widget.searchType,)));
                    },
                  ),
                ),
              )
                  : const Text(
                'No results found',
                style: TextStyle(fontSize: 24),
              ),
            ),*/
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: voterList.isNotEmpty ?
                renderAsynchSearchableListview()
                :const CircularProgressIndicator(),
              ),
            ),
            Visibility(
              visible: isVisible,
              child: SizedBox(
                height: 40,
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: const LinearGradient(colors: [
                          Color.fromRGBO(0, 0, 0, 1),
                          Color.fromRGBO(0, 0, 0, .6),
                        ])),
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          side: const BorderSide(
                            width: 1.0,
                            color: Colors.transparent,
                          ),
                        ),
                        onPressed: () {
                            generatePDF("English");
                        },
                        child: const Text(
                          "Create PDF",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    ),
    );
  }

  Text getLeadingText(int index){
    if(widget.searchType == "AgeWise"){
      return Text( "Age\n${_foundUsers[index].age!}", style: const TextStyle(fontSize: 15, color: Colors.red),);
    }else if(widget.searchType == "SerialWise"){
      return Text( "SrNo\n${_foundUsers[index].serialNo!}", style: const TextStyle(fontSize: 15, color: Colors.red),);
    }else{
      return const Text( "", style: TextStyle(fontSize: 0),);
    }
   }

  Row getSurnameInputs(){
    return   Row(
      children: [
        const SizedBox(width: 5,),
        Flexible(
          flex: 1,
          child: TextField(
            controller: surnameController,
            onChanged: (value) => search(value),
            decoration: InputDecoration(
              hintText: 'Voter name search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5,),

      ],
    );
  }

  Widget renderAsynchSearchableListview() {
    return SearchableList<EDetails>.async(
      itemBuilder: (EDetails item) {
        return VoterItem(actor: item);
      },
      asyncListCallback: () async {
        await Future.delayed(const Duration(seconds: 0));
        return voterList;
      },
      asyncListFilter: (query, list) {
        return searchFilter(query);
      },
      seperatorBuilder: (context, index) {
        return const Divider();
      },
      style: const TextStyle(fontSize: 25),
      onItemSelected: (EDetails item) {
        Navigator.push(context,
            MaterialPageRoute(builder:
                (context) =>  DetailPage(data : item, searchType: widget.searchType,)));

      },
      emptyWidget: const EmptyView(),
      inputDecoration: InputDecoration(
        labelText: "Voter name search",
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

   List<EDetails> searchFilter(String query) {
     final RegExp english = RegExp(r'^[a-zA-Z]+');
     query = query.toLowerCase();
     List<EDetails> result = [];
     for (var p in voterList) {
      if (english.hasMatch(query)){
         var name = "${p.lnEnglish.toString().toLowerCase()} ${p.fnEnglish.toString().toLowerCase()}";
         if (name.contains(query)) {
           result.add(p);
         }
       }else{
        var marathiName = "${p.lnMarathi.toString().toLowerCase()} ${p.fnMarathi.toString().toLowerCase()}";
        if (marathiName.contains(query)) {
           result.add(p);
         }
       }

     }

     return result;
   }

   Future<void> generatePDF(String type) async {
    PdfDocument document;
    //Create a new PDF document with conformance A2B.
    document = PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);

    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219, 255)));
    //Read font file.
    List<int> fontData = await _readData('Roboto-Regular.ttf');
    if(type == "Marathi"){
      fontData = await _readData('AnnapurnaSIL-Regular.ttf');
    }
    //Create a PDF true type font.
    PdfFont contentFont = PdfTrueTypeFont(fontData, 6);
    PdfFont headerFont = PdfTrueTypeFont(fontData, 15);
    PdfFont footerFont = PdfTrueTypeFont(fontData, 18);
    //Generate PDF grid.
    final PdfGrid grid = _getGrid(contentFont, type);
    //Draw the header section by creating text element
    final PdfLayoutResult result =
    _drawHeader(page, pageSize, grid, contentFont, headerFont, footerFont, type);
    //Draw grid
    _drawGrid(page, grid, result, contentFont);
    //Add invoice footer
    //_drawFooter(page, pageSize, contentFont);
    //Save and dispose the document.
    final List<int> bytes = document.saveSync();
    document.dispose();

    //Get external storage directory
    Directory? directory = Platform.isAndroid
        ? await getTemporaryDirectory()
        : await getApplicationSupportDirectory();
    //Get directory path
    String? path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/Output.pdf');
    //Write PDF data
    await file.writeAsBytes(bytes, flush: true);
    //Open the PDF document in mobile
    OpenFile.open('$path/Output.pdf');
  }

  Future<List<int>> _readData(String name) async {
    final ByteData data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  PdfGrid _getGrid(PdfFont contentFont, String type) {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 6);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor.empty);
    headerRow.style.textBrush = PdfBrushes.black;
    headerRow.cells[0].value = 'Part';
    //headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Sr No';
    headerRow.cells[2].value = 'Voter Name';
    headerRow.cells[3].value = 'Voter Address';
    headerRow.cells[4].value = 'Gender';
    headerRow.cells[5].value = 'Age';

    for(var voter in voterList){
      if(type == "English") {
        _addProducts(
            voter.partNo!,
            voter.serialNo!,
            "${voter.lnEnglish!} ${voter.fnEnglish!}",
            "${voter.houseNoEnglish!} ${voter.buildingNameEnglish!}",
            voter.sex!,
            voter.age!,
            grid);
      }else{
        _addProducts(
            voter.partNo!,
            voter.serialNo!,
            "${voter.lnMarathi!} ${voter.fnMarathi!}",
            "${voter.houseNoMarathi!} ${voter.buildingNameMarathi!}",
            voter.sex!,
            voter.age!,
            grid);

      }
    }
    final PdfPen whitePen = PdfPen(PdfColor.empty, width: 0.5);
    PdfBorders borders = PdfBorders();
    borders.all = PdfPen(PdfColor(142, 179, 219), width: 0.5);
    grid.rows.applyStyle(PdfGridCellStyle(borders: borders));
    grid.columns[0].width = 22;
    grid.columns[1].width = 30;
    grid.columns[2].width = 140;
    grid.columns[4].width = 30;
    grid.columns[5].width = 30;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      headerRow.cells[i].style.borders.all = whitePen;
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      /*if (i % 2 == 0) {
        row.style.backgroundBrush = PdfSolidBrush(PdfColor(217, 226, 243));
      }*/
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    //Set font
    grid.style.font = contentFont;
    return grid;
  }

  void _addProducts(String partNo, String srNo, String voterName,
      String voterAdd, String sex, String age, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = partNo;
    row.cells[1].value = srNo;
    row.cells[2].value = voterName;
    row.cells[3].value = voterAdd;
    row.cells[4].value = sex;
    row.cells[5].value = age;
  }

  PdfLayoutResult _drawHeader(PdfPage page, Size pageSize, PdfGrid grid,
      PdfFont contentFont, PdfFont headerFont, PdfFont footerFont, String type) {
    //Draw rectangle
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor.empty),
        bounds: Rect.fromLTWH(0, 0, pageSize.width , 30));
    var str = "MAJREKAR'S Voters Management System";
    if(type == "Marathi"){
      str = "माजरेकर्स वोटर मॅनॅजमेन्ट सिस्टम";
    }

    return PdfTextElement(text: str, font: headerFont).draw(
        page: page,
        bounds:  Rect.fromLTWH(10, 10,
            pageSize.width , 0))!;

  }

  void _drawGrid(
      PdfPage page, PdfGrid grid, PdfLayoutResult result, PdfFont contentFont) {
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;
  }



  Widget getTextViewEnglish(int index, String searchType){
    if(searchType.contains("Name")){
      if (_foundUsers[index].sex=="D"){
        return Text("${_foundUsers[index].fnEnglish} ${_foundUsers[index].lnEnglish}",style:const TextStyle(color: Colors.red,decoration:TextDecoration.lineThrough));
      }
      return Text("${_foundUsers[index].fnEnglish} ${_foundUsers[index].lnEnglish}");
    }else{
      if (_foundUsers[index].sex=="D"){
        return Text("${_foundUsers[index].lnEnglish} ${_foundUsers[index].fnEnglish}",style:const TextStyle(color: Colors.red,decoration:TextDecoration.lineThrough));
      }
      return Text("${_foundUsers[index].lnEnglish} ${_foundUsers[index].fnEnglish}");
    }
  }
  Widget getTextViewMarathi(int index, String searchType){
    if(searchType.contains("Name")){
      return Text("${_foundUsers[index].fnMarathi} ${_foundUsers[index].lnMarathi}");
    }else{
      return Text("${_foundUsers[index].lnMarathi} ${_foundUsers[index].fnMarathi}");
    }
  }



}
