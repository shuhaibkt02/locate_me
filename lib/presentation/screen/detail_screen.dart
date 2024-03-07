import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_me/logic/user_provider.dart';

class DetailScreen extends ConsumerWidget {
  final String address;
  const DetailScreen(this.address, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userApi = ref.watch(userApiProvider);
    final AsyncValue<int> totalPages = ref.watch(userApi.totalPageProvider);

    return Scaffold(
      appBar: AppBar(title: Text(address)),
      body: Column(
        children: [
          totalPages.when(
            data: (totalPagesData) {
              return PageView.builder(
                itemBuilder: (context, pageIndex) {
                  final fetchApiData =
                      ref.watch(userApi.fetchApiProvider(pageIndex + 1));
                  return fetchApiData.when(
                    data: (userDataList) {
                      return ListView.builder(
                        itemCount: userDataList.length,
                        itemBuilder: (context, index) {
                          final user = userDataList[index];
                          return ListTile(
                            title: Text('${user.firstName} ${user.lastName}'),
                            subtitle: Text(user.email),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(user.avaratUrl),
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
        ],
      ),
    );
  }
}
