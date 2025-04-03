import 'package:flutter/material.dart';

class StockTransactionTabs extends StatelessWidget {
  const StockTransactionTabs({
    super.key,
    required this.onFormTap,
    required this.onHideForm,
    required this.onCloseForm,
    required this.showForm,
    required this.title,
    required this.formTitle,
  });

  final Function onFormTap;
  final Function onHideForm;
  final Function onCloseForm;
  final bool showForm;
  final String title;
  final String formTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            onTap: () => onHideForm(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),

                border:
                    showForm
                        ? Border.all(width: 0, color: Colors.transparent)
                        : Border(
                          top: BorderSide(width: 1.5, color: Colors.green),
                          right: BorderSide(width: 1.5, color: Colors.green),
                          left: BorderSide(width: 1.5, color: Colors.green),
                          bottom: BorderSide.none,
                        ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),
          SizedBox(width: 4),
          InkWell(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            onTap: () => onFormTap(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),

                border:
                    !showForm
                        ? Border.all(width: 0, color: Colors.transparent)
                        : Border(
                          top: BorderSide(width: 1.5, color: Colors.green),
                          right: BorderSide(width: 1.5, color: Colors.green),
                          left: BorderSide(width: 1.5, color: Colors.green),
                          bottom: BorderSide.none,
                        ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),

                    child: Text(
                      formTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  !showForm
                      ? SizedBox()
                      : InkWell(
                        onTap: () {
                          onCloseForm();
                        },
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.cancel),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
