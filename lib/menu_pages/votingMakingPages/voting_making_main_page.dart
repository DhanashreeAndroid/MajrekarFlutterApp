import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/menu_pages/buildingWiseSearch/partno_drop_list_model.dart';
import 'package:majrekar_app/menu_pages/buildingWiseSearch/part_no_drop_list_item.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../CommonWidget/Constant.dart';
import '../../CommonWidget/commonButton.dart';
import '../../CommonWidget/commonButtonCustomBorder.dart';
import '../../CommonWidget/show_snak_bar.dart';
import '../../CommonWidget/utility.dart';
import '../../database/ObjectBox.dart';
import '../../model/DataModel.dart';
import '../../model/UserModel.dart';
import '../common_pages/voter_list_page.dart';

class VotingMakingMainPage extends StatefulWidget {
  const VotingMakingMainPage({Key? key}) : super(key: key);

  @override
  State<VotingMakingMainPage> createState() =>
      _VotingMakingMainPageState();
}

class _VotingMakingMainPageState extends State<VotingMakingMainPage> {
  bool isLoading = false;
  UserDetails? userDetails;
  List<EDetails> voterList = [];
  @override
  void initState() {
    super.initState();
    getUserDetails();
  }
  
  Future getUserDetails() async {
    setState(() => isLoading = true);
    List<UserDetails> users = await ObjectBox.getUserDetails();
    userDetails =  users.first;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      Navigator.pop(context);
      return false;
    }, child:
    Focus(
    autofocus: true,
    onKeyEvent: (FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
    // Mimic back button behavior
    Navigator.pop(context);
    return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
    },
    child:
    Scaffold(
          backgroundColor: const Color.fromRGBO(218,222,224, 1),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                CommonHeader(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                AutoSizeText(
                  textAlign: TextAlign.center,
                  "Please click on 'Serial wise All Names' to see voter list of part number ${userDetails?.userEmail} and do your marking here.\nClick on 'Marking Done' to see your marking report.",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Center(child: customButtons()),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
      ))
    );

  }


  Padding customButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10,),
          CustomButtonCustomBorder(
            onPressed: () {
              final partNo = userDetails?.userEmail;
              Navigator.push(context,
                  MaterialPageRoute(builder:
                      (context) =>  VoterListPage(searchType : "SerialWise" ,buildingName: partNo!, language: "" ,)));

            }, label: 'Serial wise All Names', borderColor: Colors.red,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            onPressed: () async {
              final partNo = userDetails?.userEmail;
              voterList = await ObjectBox.getPartWiseMarkingData(partNo!);
              generatePDF();
            }, label: 'Marking Done Report',
          )
        ],
      ),
    );
  }

  Future<void> generatePDF() async {
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
    //Create a PDF true type font.
    PdfFont contentFont = PdfTrueTypeFont(fontData, 6);
    PdfFont headerFont = PdfTrueTypeFont(fontData, 15);
    PdfFont footerFont = PdfTrueTypeFont(fontData, 18);
    //Generate PDF grid.
    final PdfGrid grid = _getGrid(contentFont);
    //Draw the header section by creating text element
    final PdfLayoutResult result = _drawHeader(
        page, pageSize, grid, contentFont, headerFont, footerFont);
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

  PdfGrid _getGrid(PdfFont contentFont) {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 8);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor.empty);
    headerRow.style.textBrush = PdfBrushes.black;
    headerRow.cells[0].value = 'Part';
    //headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Sr No';
    headerRow.cells[2].value = 'Voter Name';
    headerRow.cells[3].value = 'Gender';
    headerRow.cells[4].value = 'Age';
    headerRow.cells[5].value = 'Color';
    headerRow.cells[6].value = 'Shifted/Death';
    headerRow.cells[7].value = 'Voted/NonVoted';

    for (var voter in voterList) {
        _addProducts(
            voter.partNo!,
            voter.serialNo!,
            "${voter.lnEnglish!} ${voter.fnEnglish!}",
            voter.sex!,
            voter.age!,
            voter.color,
            voter.shiftedDeath,
            voter.votedNonVoted,
            grid);

    }
    final PdfPen whitePen = PdfPen(PdfColor.empty, width: 0.5);
    PdfBorders borders = PdfBorders();
    borders.all = PdfPen(PdfColor(142, 179, 219), width: 0.5);
    grid.rows.applyStyle(PdfGridCellStyle(borders: borders));
    grid.columns[0].width = 22;
    grid.columns[1].width = 30;
    grid.columns[2].width = 140;
    grid.columns[3].width = 30;
    grid.columns[4].width = 30;
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

  void _addProducts(String partNo, String srNo, String voterName, String sex, String age,String? color, String? shifted, String? voted, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = partNo;
    row.cells[1].value = srNo;
    row.cells[2].value = voterName;
    row.cells[3].value = sex;
    row.cells[4].value = age;
    row.cells[5].value = color;
    row.cells[6].value = shifted;
    row.cells[7].value = voted;
  }

  PdfLayoutResult _drawHeader(PdfPage page, Size pageSize, PdfGrid grid,
      PdfFont contentFont, PdfFont headerFont, PdfFont footerFont) {
    //Draw rectangle
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor.empty),
        bounds: Rect.fromLTWH(0, 0, pageSize.width , 30));
    var str = "MAJREKAR'S Voters Management System";
    return PdfTextElement(text: str, font: headerFont)
        .draw(page: page, bounds: Rect.fromLTWH(10, 10, pageSize.width, 0))!;
  }

  void _drawGrid(
      PdfPage page, PdfGrid grid, PdfLayoutResult result, PdfFont contentFont) {
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;
  }

}
