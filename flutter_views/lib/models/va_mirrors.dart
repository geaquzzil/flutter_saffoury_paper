import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
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

  ViewAbstract? getNewInstanceMirror(
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

  dynamic getFieldValue(String field) {
    try {
      dynamic value = getInstanceMirror().invokeGetter(field);
      return value;
    } catch (e) {
      return "$field ${e.toString()}";
    }
  }
}
