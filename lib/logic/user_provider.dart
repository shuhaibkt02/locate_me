import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_me/data/model/user_model.dart';

typedef FutureUserList = FutureProviderFamily<List<UserModel>, int>;

@immutable
class UserApi {
  final FutureProvider<int> totalPageProvider;
  final FutureUserList fetchApiProvider;

  UserApi(ProviderRef ref)
      : totalPageProvider = FutureProvider<int>((ref) async {
          final dio = ref.watch(dioProvider);
          final response = await dio.get('https://reqres.in/api/users');
          final totalPages = response.data['total_pages'] as int;
          return totalPages;
        }),
        fetchApiProvider =
            FutureProvider.family<List<UserModel>, int>((ref, page) {
          final url = 'https://reqres.in/api/users?page=$page';
          return ref.watch(dioProvider).get(url).then((response) {
            final userList = (response.data['data'] as List)
                .map((json) => UserModel.fromJson(json))
                .toList();
            return userList;
          });
        });
}

final dioProvider = Provider<Dio>((ref) => Dio());
final userApiProvider = Provider<UserApi>((ref) => UserApi(ref));
