class Receipt {
  final String propertyNo;
  final String name;
  final String address;
  final List<PropertyTaxReceiptDetail> details;

  Receipt({
    required this.propertyNo,
    required this.name,
    required this.address,
    required this.details,
  });

  factory Receipt.fromString(String data) {
    List<String> dataList = data.split(r"$");

    List<PropertyTaxReceiptDetail> details = [];
    for (var row in data.split("^")[1].split("~")) {
      details.add(PropertyTaxReceiptDetail.fromString(row));
    }

    return Receipt(
      propertyNo: dataList[0],
      name: dataList[1],
      address: dataList[2].split("^")[0],
      details: details,
    );
  }
}

class PropertyTaxReceiptDetail {
  final String receiptNo;
  final String amount;
  final String date;

  PropertyTaxReceiptDetail({
    required this.receiptNo,
    required this.amount,
    required this.date,
  });

  factory PropertyTaxReceiptDetail.fromString(String row) {
    var items = row.split("|");
    return PropertyTaxReceiptDetail(
      receiptNo: items[0],
      date: items[1],
      amount: items[2],
    );
  }
}
