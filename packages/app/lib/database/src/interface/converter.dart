abstract class Converter<Type, TypeImpl> {
  Type fromImpl(TypeImpl t);
  TypeImpl toImpl(Type t);
}
