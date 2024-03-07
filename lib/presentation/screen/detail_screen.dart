import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locate_me/logic/user_provider.dart';
import 'package:locate_me/presentation/widget/detail%20page/dot_indicator.dart';

final activeIndexProvider = StateProvider<int>((ref) => 0);

class DetailScreen extends ConsumerWidget {
  final String address;
  final LatLng position;
  const DetailScreen({
    super.key,
    required this.address,
    required this.position,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int activeIndex = ref.watch(activeIndexProvider);

    final userApi = ref.watch(userApiProvider);
    final AsyncValue<int> totalPages = ref.watch(userApi.totalPageProvider);
    double width = MediaQuery.sizeOf(context).width;
    final textTheme = Theme.of(context).textTheme;

    onPageChange(WidgetRef ref, int value) {
      ref.read(activeIndexProvider.notifier).state = value;
    }

    return Scaffold(
      appBar: AppBar(
          title: Hero(
        tag: 'address',
        child: Text(
          address,
          style: textTheme.bodySmall
              ?.copyWith(fontWeight: FontWeight.w500, fontSize: 12.2),
        ),
      )),
      body: Stack(
        children: [
          totalPages.when(
            data: (totalPagesData) {
              return PageView.builder(
                onPageChanged: (value) => onPageChange(ref, value),
                itemBuilder: (context, pageIndex) {
                  final fetchApiData =
                      ref.watch(userApi.fetchApiProvider(pageIndex + 1));
                  return fetchApiData.when(
                    data: (userDataList) {
                      return ListView.builder(
                        itemCount: userDataList.length,
                        itemBuilder: (context, index) {
                          final user = userDataList[index];
                          return TweenAnimationBuilder(
                            tween: Tween(begin: 0.1, end: 1.0),
                            duration: const Duration(milliseconds: 750),
                            builder: (context, value, child) => Opacity(
                              opacity: value,
                              child: child,
                            ),
                            child: ListTile(
                              title: Text('${user.firstName} ${user.lastName}'),
                              subtitle: Text(user.email),
                              leading: CircleAvatar(
                                backgroundImage:
                                    CachedNetworkImageProvider(user.avaratUrl),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.redAccent,
                      ),
                    ),
                    error: (error, stackTrace) {
                      return Center(child: Text('Error: $error'));
                    },
                  );
                },
                itemCount: totalPagesData,
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            ),
            error: (error, stackTrace) {
              return Center(child: Text('Error: $error'));
            },
          ),
          Positioned(
            bottom: 20,
            left: width / 2.3,
            child: DotIndicator(
              activeIndex: activeIndex,
              dotCount: 2,
            ),
          ),
        ],
      ),
    );
  }
}
