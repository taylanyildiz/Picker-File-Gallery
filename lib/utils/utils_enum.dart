import 'package:bottom_sheet_picker/enums/enums.dart';

class UtilsEnum {
  UtilsEnum._();

  static indexToBottomNavigationType(int index) {
    switch (index) {
      case 0:
        return EBottomNavigationType.gallery;
      case 1:
        return EBottomNavigationType.files;
      case 2:
        return EBottomNavigationType.location;
      case 3:
        return EBottomNavigationType.constacts;
    }
  }

  static bottomNavigationTypeToIndex(EBottomNavigationType type) {
    switch (type) {
      case EBottomNavigationType.gallery:
        return 0;
      case EBottomNavigationType.files:
        return 1;
      case EBottomNavigationType.location:
        return 2;
      case EBottomNavigationType.constacts:
        return 3;
    }
  }

  static indexToImageDetailType(int index) {
    switch (index) {
      case 0:
        return EFileDetailMode.gesture;
      case 1:
        return EFileDetailMode.imageEdit;
      case 2:
        return EFileDetailMode.videoEdit;
    }
  }

  static imageDetailTypeToIndex(EFileDetailMode mode) {
    switch (mode) {
      case EFileDetailMode.gesture:
        return 0;
      case EFileDetailMode.imageEdit:
        return 1;
      case EFileDetailMode.videoEdit:
        return 2;
    }
  }
}
