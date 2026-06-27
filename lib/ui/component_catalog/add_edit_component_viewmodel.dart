class AddEditComponentViewModel {
  AddEditComponentViewModel();

  void save(String componentType, component, int quantity) {
    component.count = quantity;
    print('$componentType: $component');
  }
}
