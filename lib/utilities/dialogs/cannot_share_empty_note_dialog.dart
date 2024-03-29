import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(
  BuildContext context,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'you cannot share empty note',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
