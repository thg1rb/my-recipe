import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe/core/theme/custom_theme/color_scheme.dart';
import 'package:my_recipe/providers/drop_down_state_provider.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.height,
    required this.controller,
    required this.validator,
  });
  final String label;
  final double height;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          height: height,
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              hintText: '',
              helperText: '',
              errorStyle: TextStyle(fontSize: 14),
              label: Text(label),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            textAlignVertical: TextAlignVertical.top,
            maxLines: null,
            expands: true,
            style: TextStyle(fontSize: 14),
          ),
    );
  }
}

class FineDropDownBox extends ConsumerStatefulWidget {
  const FineDropDownBox({
    super.key,
    required this.title,
    required this.items,
    required this.colors,
    required this.id,
    required this.onSelected,
    this.selectedItem, // Add selectedItem parameter
  });

  final String title;
  final List<String> items;
  final List<Color> colors;
  final String id;
  final Function(String) onSelected;
  final String? selectedItem; // Selected item from Firebase

  @override
  ConsumerState<FineDropDownBox> createState() => _FineDropDownBoxState();
}

class _FineDropDownBoxState extends ConsumerState<FineDropDownBox> {
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    // Initialize selectedItem with the value from Firebase
    selectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    bool showDropDown = ref.watch(dropDownStateProvider(widget.id));
    return Stack(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: 400,
          height: showDropDown ? 60 * widget.items.length.toDouble() + 60 : 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: CustomColorScheme.yellowColor,
          ),
          child: Column(
            children: [
              SizedBox(height: 60),
              Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedItem = widget.items[index];
                        });
                        ref
                            .read(dropDownStateProvider(widget.id).notifier)
                            .state = !showDropDown;
                        widget.onSelected(widget.items[index]);
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius:
                              index == (widget.items.length - 1)
                                  ? BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  )
                                  : BorderRadius.all(Radius.zero),
                          color: widget.colors[index],
                        ),
                        child: Center(
                          child: Text(
                            widget.items[index],
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(dropDownStateProvider(widget.id).notifier).state =
                !showDropDown;
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            fixedSize: Size(400, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                selectedItem ?? widget.title,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(width: 10),
              Icon(Icons.arrow_drop_down, color: Colors.white, size: 40),
            ],
          ),
        ),
      ],
    );
  }
}
