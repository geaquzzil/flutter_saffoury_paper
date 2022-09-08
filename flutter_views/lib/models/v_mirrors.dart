import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:reflectable/reflectable.dart';

@GlobalQuantifyCapability(r"^.(SomeClass|SomeEnum)", reflector)
class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, declarationsCapability,
            typeRelationsCapability);
}

const reflector = Reflector();

class VMirrors<T> {
  InstanceMirror getInstanceMirror() {
    return reflector.reflect(this);
  }

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

  ClassMirror getInstanceMirrorField(Type type) {
    return reflector.reflectType(type) as ClassMirror;
  }

  String? getViewAbstractLabelText(BuildContext context, String field) {
    return getNewInstanceMirror(field: field)
            ?.getMainHeaderLabelTextOnly(context) ??
        "not found for $field";
  }

  List<String> getFieldsDeclarations() {
    ClassMirror c = getInstanceMirror().type;
    return c.declarations.entries.map((e) => e.key).toList();
  }

  ViewAbstractEnum? getNewInstanceEnum(
      {ClassMirror? classMirror, String? field}) {
    debugPrint("getNewInstanceEnum for classMirror:$field");
    if (field != null) {
      if (!getInstanceMirrorFieldName(field).isEnum) return null;
      return getNewInstanceEnum(classMirror: getInstanceMirrorFieldName(field));
    }
    return classMirror?.newInstance("", []) as ViewAbstractEnum?;
  }

  ViewAbstract? getNewInstanceMirror(
      {ClassMirror? classMirror, String? field}) {
    debugPrint("getNewInstanceMirror for classMirror:$field");
    if (field != null) {
      return getNewInstanceMirror(
          classMirror: getInstanceMirrorFieldName(field));
    }
    return classMirror?.newInstance("", []) as ViewAbstract?;
  }

  ViewAbstract? getNewInstanceMirrorFromList(
      {ClassMirror? classMirror, String? field}) {
    debugPrint("getNewInstanceMirror for classMirror:$field");
    if (field != null) {
      return getNewInstanceMirror(
          classMirror: getInstanceMirrorFieldName(field));
    }
    return classMirror?.newInstance("", []) as ViewAbstract?;
  }

  Type getFieldType(String field) {
    return getInstanceMirror().invokeGetter(field).runtimeType;
  }

  bool isViewAbstract(String field) {
    try {
      ViewAbstract? t = getNewInstanceMirror(field: field);
      bool res = t is ViewAbstract;
      debugPrint("isViewAbstract $field  res=>$res");
      return res;
    } catch (e) {
      debugPrint("isViewAbstract error=> $e");
      return false;
    }
  }

  dynamic getFieldValue(String field) {
    try {
      dynamic value = getInstanceMirror().invokeGetter(field);
      return value;
    } catch (e) {
      return "$field ${e.toString()}";
    }
  }
}
