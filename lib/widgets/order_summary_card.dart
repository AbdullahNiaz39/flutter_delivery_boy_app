import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_delivery_boy_app/services/firebase_services.dart';
import 'package:flutter_delivery_boy_app/services/order_services.dart';

class OrderSummaryCard extends StatefulWidget {
  final DocumentSnapshot document;
  OrderSummaryCard(this.document);

  @override
  _OrderSummaryCardState createState() => _OrderSummaryCardState();
}

class _OrderSummaryCardState extends State<OrderSummaryCard> {
  @override
  OrderServices _orderServices = OrderServices();
  FirebaseServices _services = FirebaseServices();
  @override
  void initState() {
    _services
        .getCustomerDetails(widget.document.data()['userId'])
        .then((value) {
      if (value != null) {
        setState(() {
          _customer = value;
        });
      } else {
        print('No Data');
      }
    });
    super.initState();
  }

  DocumentSnapshot _customer;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            horizontalTitleGap: 0,
            leading: Image.network(
              widget.document.data()['deliveryboy']['image'],
            ),
            title: Column(
              children: [
                Text(
                  widget.document.data()['deliveryboy']['name'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _orderServices.statusColor(widget.document),
                  ),
                ),
              ],
            ),
            subtitle: Center(
              child: Text(
                widget.document.data()['deliveryboy']['email'],
                style: TextStyle(fontSize: 12),
              ),
            ),
            trailing: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 14,
              child: Icon(
                Icons.delivery_dining,
                size: 18,
                color: _orderServices.statusColor(widget.document),
              ),
            ),
          ),
          ListTile(
            horizontalTitleGap: 0,
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 14,
              child: Icon(
                CupertinoIcons.square_list,
                size: 18,
                color: _orderServices.statusColor(widget.document),
              ),
            ),
            title: Text(
              widget.document.data()['orderStatus'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _orderServices.statusColor(widget.document),
              ),
            ),
            subtitle: Text(
              'On ${DateFormat.yMMMd().format(DateTime.parse(widget.document.data()['timestamp']))}',
              style: TextStyle(fontSize: 12),
            ),
            trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Payment Type : ${widget.document.data()['cod'] == true ? 'cash on delivery' : 'Paid online'}',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Amount : \$${widget.document.data()['total'].toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ]),
          ),
          _customer != null
              ? ListTile(
                  title: Row(
                    children: [
                      Text(
                        'Customer : ',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      // Text(
                      // '${_customer.data()['firstName']} ${_customer.data()['lastname']}',
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //   ),
                      // ),
                    ],
                  ),
                  subtitle: Text(
                    _customer.data()['address'],
                    style: TextStyle(fontSize: 12),
                    maxLines: 1,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          _orderServices
                              .launchCall('tel:${_customer.data()['number']}');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 2, bottom: 2),
                            child: Icon(
                              Icons.phone_in_talk,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          _orderServices.launchMap(
                              _customer.data()['latitude'],
                              _customer.data()['longitude'],
                              _customer.data()['firstname']);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 2, bottom: 2),
                            child: Icon(
                              Icons.map,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
              : Container(),
          ExpansionTile(
            title: Text(
              'order Detailed',
              style: TextStyle(fontSize: 10, color: Colors.black),
            ),
            subtitle: Text(
              'view order details',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      foregroundColor: Colors.teal,
                      backgroundColor: Colors.teal[50],
                      backgroundImage: NetworkImage(widget.document
                          .data()['products'][index]['productImage']),
                      radius: 20,
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.network(
                          widget.document.data()['products'][index]
                              ['productImage'],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    title: Text(
                      widget.document.data()['products'][index]['productName'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    trailing: Text(
                        widget.document
                            .data()['products'][index]['price']
                            .toStringAsFixed(0),
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${widget.document.data()['products'][index]['stockQuantity']} X ${widget.document.data()['products'][index]['price'].toStringAsFixed(0)} = RS ${widget.document.data()['products'][index]['total'].toStringAsFixed(0)}'),
                  );
                },
                itemCount: widget.document.data()['products'].length,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 8,
                  bottom: 8,
                ),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Seller : ',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.document.data()['seller']['shopName'],
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          _orderServices.statusContainer(widget.document, context),
        ],
      ),
    );
  }
}
