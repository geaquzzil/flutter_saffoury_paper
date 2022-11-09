import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:reflectable/reflectable.dart';

@GlobalQuantifyCapability(r"^.(SomeClass|SomeEnum)", reflector)
class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, declarationsCapability,
            typeRelationsCapability);
  // const Reflector()
  //     : super(
  //         // newInstanceCapability,
  //         invokingCapability,
  //         reflectedTypeCapability,
  //         typingCapability,
  //         declarationsCapability,
  //       );
}

const reflector = Reflector();

abstract class VMirrors<T> {
  Type getMirrorFieldsType(String field) {
    return getMirrorFieldsMapNewInstance()[field].runtimeType;
  }

  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {};

  InstanceMirror getInstanceMirror() {
    return reflector.reflect(this);
  }

  dynamic getFieldValue(String field) {
    try {
      dynamic value = getInstanceMirror().invokeGetter(field);
      return value;
    } catch (e) {
      debugPrint("getFieldValue $e");
      return null;
    }
  }

  dynamic castFieldValue(String field, dynamic value) {
    Type? fieldType = getMirrorFieldType(field);
    debugPrint("castFieldValue type is $fieldType");

    // value = value ?? "";
    if (fieldType == int) {
      return int.parse(value.toString());
    } else if (fieldType == num) {
      return num.parse(value.toString());
    } else if (fieldType == double) {
      return double.parse(value.toString());
    } else if (fieldType == String) {
      return value.toString();
    } else {
      return value;
    }
  }

  void setFieldValue(String field, Object? value) {
 
    try {
      getInstanceMirror().invokeSetter(field, castFieldValue(field, value));
         debugPrint("setFieldValue $T  field=$field value=$value");
    } catch (e) {
      debugPrint("setFieldValue error $T field= $field ${e.toString()}");
    }
  }

  ClassMirror getInstanceMirrorReflectField(Type type) {
    return reflector.reflectType(type) as ClassMirror;
  }

  List<String> getFieldsDeclarations() {
    ClassMirror c = getInstanceMirror().type;
    return c.declarations.entries.map((e) => e.key).toList();
  }

  /// Get the field type of the given String name
  /// throw exception if the field type is not object or if the field type is [int, float,String,...]
  ClassMirror getInstanceMirrorFieldName(String name) {
    ClassMirror c = getInstanceMirror().type;
    try {
      VariableMirror vm = c.declarations[name] as VariableMirror;
      TypeMirror nonGenericClassMirrorImpl = vm.type;
      return reflector.reflectType(nonGenericClassMirrorImpl.reflectedType)
          as ClassMirror;
    } catch (e) {
      debugPrint("getInstanceMirrorFieldName error=> $e");
      return c;
    }
  }

  ClassMirror getInstanceMirrorFieldNameFromList(String name) {
    ClassMirror c = getInstanceMirror().type;
    VariableMirror vm = c.declarations[name] as VariableMirror;
    TypeMirror nonGenericClassMirrorImpl = vm.type;
    return reflector.reflectType(nonGenericClassMirrorImpl.reflectedType)
        as ClassMirror;
  }

  String getMirrorViewAbstractLabelText(BuildContext context, String field) {
    dynamic v = getMirrorNewInstance(field);
    if (v is ViewAbstractEnum) {
      return v.getMainLabelText(context);
    } else if (v is ViewAbstract) {
      return v.getMainHeaderLabelTextOnly(context);
    } else {
      return v.toString();
    }
  }

  dynamic getMirrorNewInstance(String field) {
    try {
      return getMirrorFieldsMapNewInstance()[field];
    } catch (e) {
      throw UnimplementedError(
          "Could not get field dynamic value for $field from getMirrorFieldsMapNewInstance");
    }
  }

  ViewAbstractEnum getMirrorNewInstanceEnum(String field) {
    try {
      return getMirrorFieldsMapNewInstance()[field];
    } catch (e) {
      throw UnimplementedError(
          "Could not get field dynamic value for $field from getMirrorFieldsMapNewInstance");
    }
  }

  ViewAbstract getMirrorNewInstanceViewAbstract(String field) {
    try {
      return getMirrorFieldsMapNewInstance()[field];
    } catch (e) {
      throw UnimplementedError(
          "Could not get field dynamic value for $field from getMirrorFieldsMapNewInstance");
    }
  }

  bool isViewAbstract(String field) {
    dynamic t = getMirrorNewInstance(field);
    bool res = t is ViewAbstract;
    debugPrint("isViewAbstract $field  res=>$res");
    return res;
  }

  /// Get the type of the field based on its value
  /// if the field is null the type is null use [getMirrorFieldType] instead
  Type getFieldType(String field) {
    return getInstanceMirror().invokeGetter(field).runtimeType;
  }

  Type? getMirrorFieldType(String field) {
    try {
      return getMirrorFieldsMapNewInstance()[field].runtimeType;
    } catch (e) {
      debugPrint("getFieldTypeMirror error: $e");
      return null;
    }
  }
  // ViewAbstractEnum? getNewInstanceEnum(
  //     {ClassMirror? classMirror, String? field}) {
  //   debugPrint("getNewInstanceEnum for classMirror:$field");
  //   if (field != null) {
  //     if (!getInstanceMirrorFieldName(field).isEnum) return null;
  //     return getNewInstanceEnum(classMirror: getInstanceMirrorFieldName(field));
  //   }
  //   return classMirror?.newInstance("", []) as ViewAbstractEnum?;
  // }

  // ViewAbstract? getNewInstanceMirror(
  //     {ClassMirror? classMirror, String? field}) {
  //   debugPrint("getNewInstanceMirror for classMirror:$field");
  //   if (field != null) {
  //     return getNewInstanceMirror(
  //         classMirror: getInstanceMirrorFieldName(field));
  //   }
  //   return classMirror?.newInstance("", []) as ViewAbstract?;
  // }

  // ViewAbstract getNewInstanceMirrorNotNull(String field) {
  //   debugPrint("getNewInstanceMirrorNotNull for classMirror:$field");
  //   return getInstanceMirrorFieldName(field).newInstance("", [])
  //       as ViewAbstract;
  // }

  // ViewAbstract? getNewInstanceMirrorFromList(
  //     {ClassMirror? classMirror, String? field}) {
  //   debugPrint("getNewInstanceMirror for classMirror:$field");
  //   if (field != null) {
  //     return getMirrorNewInstanceViewAbstract(
  //         classMirror: getInstanceMirrorFieldName(field));
  //   }
  //   return classMirror?.newInstance("", []) as ViewAbstract?;
  // }

}
