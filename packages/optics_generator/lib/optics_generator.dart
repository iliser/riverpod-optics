library optics_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:optics_annotation/optics_annotation.dart';

import 'package:source_gen/source_gen.dart';

class ProxyLensGenerator
    extends GeneratorForAnnotation<GenerateOpticsExtension> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw "GenerateLensAnnotation only allowed on classes";
    }

    final constructors = element.constructors
        .where((e) => e.isPublic && e.redirectedConstructor != null);
    final hasFreezedAnnotation = element.metadata.any(
      (e) =>
          e
              .computeConstantValue()
              ?.type
              ?.getDisplayString(withNullability: false) ==
          "Freezed",
    );
    if (!hasFreezedAnnotation) {
      throw "GenerateLensAnnotation only allowed on freezed classed";
    }
    if (constructors.length != 1) {
      throw "GenerateLensAnnotation only allowed on freezed classes with single constructor";
    }
    final constructor = constructors.first;
    final fields = constructor.parameters
        .map(
          (e) =>
              "RiverpodLens<T, ${e.type}> get ${e.name} => proxyBySymbol(#${e.name},(v) => v.${e.name},);",
        )
        .join("\n");
    return '''
extension ${element.name}LensExtension<T> on RiverpodLens<T, ${element.name} >{
  $fields
}
''';
  }
}

Builder generateLens(BuilderOptions options) => PartBuilder(
      [ProxyLensGenerator()],
      '.proxy_lens.dart',
      header: '// ignore_for_file: annotate_overrides, unused_element',
    );
