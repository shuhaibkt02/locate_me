import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_me/data/model/user_model.dart';

typedef FutureUserList = FutureProviderFamily<List<UserModel>, int>;

@immutable
class UserApi {
  final FutureProvider<int> totalPageProvider;
  final FutureUserList fetchApiProvider;

  static String baseUri = 'https://reqres.in/api/users';

  UserApi(ProviderRef ref)
      : totalPageProvider = FutureProvider<int>((ref) async {
          return ref.watch(dioProvider).get(baseUri).then((response) {
            final totalPages = response.data['total_pages'] as int;
            return totalPages;
          }).catchError((error) {
            throw Exception('Error fetching page count $error');
          });
        }),
        fetchApiProvider =
            FutureProvider.family<List<UserModel>, int>((ref, page) {
          return ref
              .watch(dioProvider)
              .get('$baseUri?page=$page')
              .then((response) {
            final userList = (response.data['data'] as List)
                .map((json) => UserModel.fromJson(json))
                .toList();
            return userList;
          }).catchError((error) {
            throw Exception("Error fetching user data: $error");
          });
        });
}

final dioProvider = Provider<Dio>((ref) => Dio());
final userApiProvider = Provider<UserApi>((ref) => UserApi(ref));
