class Warehouse extends Object {
  String code;
  String dataId;
  int enterpriseId;
  String name;

  Warehouse(this.code, this.dataId, this.enterpriseId, this.name);

  Warehouse.fromFishBackEndApiRest(Map<String, dynamic> json){
    this.code = json['code'].toString();
    this.dataId = json['data_id'];
    this.enterpriseId = json['enterprise_id'];
    this.name = json['name'];
  }

  Warehouse.fromSimpleMap(Map<String, dynamic> json) {
    this.code = json['code'] != null ? json['code'] : '';
    this.name = json['name'] != null ? json['name'] : '';
  }

  Map<String, dynamic> toJson() => {
    'code': this.code,
    'name': this.name,
  };

  @override
  String toString() {
    return 'Warehouse{code: $code, dataId: $dataId, '
        'enterpriseId: $enterpriseId, name: $name}';
  }

}
