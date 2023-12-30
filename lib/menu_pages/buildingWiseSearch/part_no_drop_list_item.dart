import 'package:flutter/material.dart';
import 'package:majrekar_app/menu_pages/buildingWiseSearch/partno_drop_list_model.dart';

class PartNoDropListItem extends StatefulWidget {
  final PartNo itemSelected;
  final PartNoDropListModel dropListModel;
  final Function(PartNo optionItem) onOptionSelected;

  PartNoDropListItem(this.itemSelected, this.dropListModel, this.onOptionSelected);

  @override
  _SelectDropListState createState() => _SelectDropListState(itemSelected, dropListModel);
}

class _SelectDropListState extends State<PartNoDropListItem> with SingleTickerProviderStateMixin {

  late AnimationController expandController;
  late Animation<double> animation;

  bool isShow = false;
  PartNo optionItemSelected;
  final PartNoDropListModel dropListModel;
  _SelectDropListState(this.optionItemSelected, this.dropListModel);

  @override
  void initState() {
    super.initState();
    expandController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 350)
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if(isShow) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 15, vertical: 17),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    blurRadius: 10,
                    color: Colors.black26,
                    offset: Offset(0, 2))
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.numbers, color: Color(0xFF307DF1),),
                const SizedBox(width: 10,),
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        isShow = !isShow;
                        _runExpandCheck();
                        setState(() {

                        });
                      },
                      child: Text(optionItemSelected.id, style: const TextStyle(
                          color: Color(0xFF307DF1),
                          fontSize: 16),),
                    )
                ),
                Align(
                  alignment: const Alignment(1, 0),
                  child: Icon(
                    isShow ? Icons.arrow_drop_down : Icons.arrow_right,
                    color: const Color(0xFF307DF1),
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
          SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: animation,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(0, 4))
                    ],
                  ),
                  child: _buildDropListOptions(dropListModel.listOptionItems, context)
              )
          ),
//          Divider(color: Colors.grey.shade300, height: 1,)
        ],
      ),
    );
  }

  Column _buildDropListOptions(List<PartNo> items, BuildContext context) {
    return Column(
      children: items.map((item) => _buildSubMenu(item, context)).toList(),
    );
  }

  Widget _buildSubMenu(PartNo item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 26.0, top: 5, bottom: 5),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
                ),
                child: Text(item.id,
                    style: TextStyle(
                        color: Color(0xFF307DF1),
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
        onTap: () {
          this.optionItemSelected = item;
          isShow = false;
          expandController.reverse();
          widget.onOptionSelected(item);
        },
      ),
    );
  }

}