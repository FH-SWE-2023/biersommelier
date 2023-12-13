import 'package:biersommelier/components/ExploreTabList.dart';
import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/components/MapWidget.dart';
import 'package:biersommelier/database/entities/Bar.dart';
import 'package:biersommelier/theme/theme.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final ValueNotifier<bool> _tabListExpanded = ValueNotifier<bool>(false);
  Future<List<Bar>>? _bars;

  @override
  void initState() {
    super.initState();
    _bars = Bar.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Header(
                  title: "Entdecken",
                  backgroundColor: Colors.white,
                  icon: HeaderIcon.add),
              Expanded(
                  child: FutureBuilder<List<Bar>>(
                    future: _bars,
                    builder: (BuildContext context, AsyncSnapshot<List<Bar>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final bars = snapshot.data!;
                        return MapWidget(
                          bars: bars,
                        );
                      } else {
                        return const MapWidget(bars: [],);
                      }
                    })),
              const SizedBox(height: 55,)
            ],
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _tabListExpanded,
          builder: (BuildContext context, bool value, Widget? child) => Positioned(
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: _tabListExpanded.value ? MediaQuery.of(context).size.height * 0.7 : 55,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                      clipBehavior: Clip.none,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: const ExploreBar()),
                  Positioned.fill(
                    top: -20,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              _tabListExpanded.value = !_tabListExpanded.value;
                            });
                          },
                          elevation: 1,
                          fillColor: Theme.of(context).colorScheme.white,
                          padding: const EdgeInsets.all(3.0),
                          shape: const CircleBorder(),
                          child: Icon(
                            _tabListExpanded.value
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 40.0,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          )
        )
      ],
    );
  }
}
