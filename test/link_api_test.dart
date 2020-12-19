import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:restfulness/src/config/app_config.dart';
import 'package:restfulness/src/resources/link_api_provider.dart';

const fakeLinkAddSuccess = {"id": 1};
const fakeLinkAddFailed400 = {
  "msg":
      "Link is not valid. Valid link looks like:http://example.com or https://example.com"
};
const fakeLinkAddFailed500 = {"msg": "Failed to add new link"};

const fakeLinkGetSuccess = [
  {
    "categories": [
      {"id": 1, "name": "programming"}
    ],
    "id": 2,
    "url": "https://stackoverflow.com"
  }
];

const fakeLinkGetFailed404 = {"msg": "Link not found!"};

const fakeLinkDeleteSuccess = {
  "link_id": "1",
  "msg": "Link removed successfully."
};

const fakeLinkDelete403 = {
  "msg": "You don't have permission to remove this link"
};

const fakeLinkDelete404 = {"msg": "Link doesn't exists!"};

const fakeSearchLink200 = {
  "search": {
    "links": [
      {"id": 4, "url": "http://vim.org"},
      {"id": 11, "url": "https://vim-love-vim.com"}
    ],
    "pattern": "vim"
  }
};

const fakeFetchLinksByCategoryId200 = {
  "category": {
    "links": [
      {"id": 4, "url": "http://vim.org"},
      {"id": 11, "url": "https://vim-love-vim.com"}
    ],
    "name": "dev"
  }
};
const fakeFetchLinksByCategoryId404 = {"msg": "Category ID not found!"};

const fakeSearchLink404 = {"msg": "Pattern not found!"};

const fakeUpdateCategorySuccess = {"msg": "Categories updated."};
const fakeUpdateCategory404 = {"msg": "Link ID not found!"};

const fakeSocialUserLinksSuccess = [
  {
    "added_date": "2020-12-07 12:28",
    "categories": [
      {"id": 1, "name": "programming"},
      {"id": 5, "name": "searching"},
      {"id": 11, "name": "Q and A"}
    ],
    "id": 2,
    "url": "https://stackoverflow.com"
  }
];
const fakeSocialUserLinksFailed400 = {
  "msg": "Input date does not match format 'YYYY-MM-DD hh:mm'"
};
const fakeSocialUserLinksFailed403 = {"msg": "User is not public!"};
const fakeSocialUserLinksFailed404 = {"msg": "User not found!"};

void main() {
  LinkApiProvider apiProvider;

  setUp(() {
    AppConfig(
        flavor: Flavor.DEV,
        values: AppValues(apiBaseUrl: 'http://localhost:5000'));

    apiProvider = new LinkApiProvider();
  });

  test("Test add link API if everything is correct", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeLinkAddSuccess), 200);
    });

    final id = await apiProvider.insertLink(
        category: ["programming"], url: "http://github.com", token: "token");
    expect(id, 1);
  });

  test("Test add link API if URL is not correct", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeLinkAddFailed400), 400);
    });

    try {
      await apiProvider
          .insertLink(category: ["programming"], url: "github", token: "token");
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"],
          "Link is not valid. Valid link looks like:http://example.com or https://example.com");
    }
  });

  test("Test add link API if token is not correct", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeLinkAddFailed500), 500);
    });

    try {
      await apiProvider.insertLink(
          category: ["programming"], url: "github", token: "wrongToken");
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"], "Failed to add new link");
    }
  });

  test("Test get link API if everything is correct", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeLinkGetSuccess), 200);
    });

    final link = await apiProvider.fetchAllLinks(token: "token");
    expect(link.length, 1);
  });

  test("Test get link API if link id not found", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeLinkGetFailed404), 404);
    });

    try {
      await apiProvider.fetchAllLinks(token: "token");
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"], "Link not found!");
    }
  });

  test("Test delete link API if everything is correct", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeLinkDeleteSuccess), 200);
    });

    final link = await apiProvider.deleteLink(token: "token", id: 1);
    expect(link, true);
  });

  test("Test delete link API without permission", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeLinkDelete403), 403);
    });

    try {
      await apiProvider.deleteLink(token: "token1", id: 1);
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"], "You don't have permission to remove this link");
    }
  });

  test("Test delete link API if link doesn't found", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeLinkDelete404), 404);
    });

    try {
      await apiProvider.deleteLink(token: "token", id: 10);
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"], "Link doesn't exists!");
    }
  });

  test("Test search link API if found the link", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeSearchLink200), 200);
    });
    final link = await apiProvider.searchLink(token: "token", word: 'vim');

    expect(link.length, 2);
  });

  test("Test search link API if didn't found the link", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeSearchLink404), 404);
    });

    try {
      await apiProvider.searchLink(token: "token", word: 'test');
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"], "Pattern not found!");
    }
  });

  test("Test fetch links API by category id", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeFetchLinksByCategoryId200), 200);
    });
    final link =
        await apiProvider.fetchLinksByCategoryId(token: "token", id: 2);

    expect(link.length, 2);
  });

  test("Test fetch links API by category id if didn't exist any category",
      () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeFetchLinksByCategoryId404), 404);
    });

    try {
      await apiProvider.fetchLinksByCategoryId(token: "token", id: 10);
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"], "Category ID not found!");
    }
  });

  test("Test update category", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeUpdateCategorySuccess), 200);
    });

    final msg = await apiProvider
        .updateLinksCategory(token: "token", id: 1, category: ['dev']);
    expect(msg, "Categories updated.");
  });

  test("Test update category not found id", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeUpdateCategory404), 404);
    });

    try {
      await apiProvider
          .updateLinksCategory(token: "token", id: 10, category: ['dev']);
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"], "Link ID not found!");
    }
  });

  test("Test fetch social user links ", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeSocialUserLinksSuccess), 200);
    });
    final link = await apiProvider.fetchSocialUsersLinks(
        token: "token", id: 2, date: DateTime.now());

    expect(link[0].id, 2);
  });

  test("Test fetch social user links if date input does not match", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeSocialUserLinksFailed400), 400);
    });

    try {
      await apiProvider.fetchSocialUsersLinks(
          token: "token", id: 2, date: DateTime.now());
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"],
          "Input date does not match format 'YYYY-MM-DD hh:mm'");
    }
  });

  test("Test fetch social user links if user is not public", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeSocialUserLinksFailed403), 403);
    });

    try {
      await apiProvider.fetchSocialUsersLinks(
          token: "token", id: 2, date: DateTime.now());
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"], "User is not public!");
    }
  });

  test("Test fetch social user links if user not found", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeSocialUserLinksFailed404), 404);
    });

    try {
      await apiProvider.fetchSocialUsersLinks(
          token: "token", id: 2, date: DateTime.now());
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"], "User not found!");
    }
  });
}
