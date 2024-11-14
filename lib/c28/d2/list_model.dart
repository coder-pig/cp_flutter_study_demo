class ListReq {
  int sortType = 0; // 排序类型，0：综合排序，1：销量优先，2：价格升序，3：价格降序
  String? searchKey = ''; // 搜索关键字

  ListReq({this.sortType = -1, this.searchKey});

  Map<String, dynamic> toJson() {
    return {
      'sortType': sortType,
      'searchKey': searchKey,
    };
  }
}

class ListRes {
  String? sortTypeStr;
  String? searchKey;

  ListRes();

  ListRes.fromJson(Map<String, dynamic> json) {
    sortTypeStr = json['sortTypeStr'];
    searchKey = json['searchKey'];
  }

  @override
  String toString() {
    return '排序类型：$sortTypeStr\n搜索关键字：$searchKey';
  }
}
