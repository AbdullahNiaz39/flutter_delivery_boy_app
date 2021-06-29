import 'dart:html';

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
  OrderServices _orderServices =OrderServices();
  FirebaseServices _services =FirebaseServices();
  @override
  void initState() { 
    
    _services.getCustomerDetails(widget.document.data()['userId']).then((value){if(value!=null){
      setState(() {
        _customer=value;
      });
    }
    else{
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
             leading: CircleAvatar(
               backgroundColor: Colors.white,
               radius: 14,
               child: _orderServices.statusIcon(widget.document),
             ),
             title: Text(
               widget.document.data()['orderStatus'],
               style: TextStyle(
                 fontSize: 12,
                 fontWeight: FontWeight.bold,
                 color: _orderServices.statusColor(widget.document),
               ),
             ),
             subtitle: Text('On ${DateFormat.yMMMd().format(DateTime.parse(widget.document.data()['timestamp']))}',
             style: TextStyle(fontSize: 12),),
             trailing: Column(
               crossAxisAlignment: CrossAxisAlignment.end,
               mainAxisSize: MainAxisSize.min,
               children:[
                Text('Payment Type : ${widget.document.data()['cod']== true ? 'cash on delivery':'Paid online'}',
                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                ), 
                Text('Amount : \$${widget.document.data()['total'].toStringAsFixed(0)}',
                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                ),
               ]
             ),
          
           ),
           _customer !=null ?ListTile(
             title: Row(children: [
               Text('Customer : ',
               style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
               ),
                Text('${_customer.data()['firstName']} ${_customer.data()['lastname']}',
                style: TextStyle(fontSize: 12,),
                ),
             ],),
             subtitle: Text(
               _customer.data()['address'],
               style: TextStyle(fontSize: 12),
               maxLines: 1,
             ),
             trailing: Row(
               mainAxisSize: MainAxisSize.min,
               children: [
                 InkWell(
                    onTap:(){
                      _orderServices.launchCall('tel:${_customer.data()['number']}');
                    },
                   child: Container(
                     decoration: BoxDecoration(
                       color: Theme.of(context).primaryColor,
                       borderRadius: BorderRadius.circular(4),
                     ),
                     child: Padding(
                       padding: const EdgeInsets.only(left:8,right:8,top:2,bottom: 2),
                       child: Icon(Icons.phone_in_talk,color: Colors.white,
                               
                   ),
                     ),
                   
                   ),
                 ),
                SizedBox(width:10,),
                 InkWell(
                    onTap:(){
                      _orderServices.launchMap(
                        _customer.data()['latitude'],
                         _customer.data()['longitude'],
                      _customer.data()['firstname']
                      );
                    },
                   child: Container(
                     decoration: BoxDecoration(
                       color: Theme.of(context).primaryColor,
                       borderRadius: BorderRadius.circular(4),
                     ),
                     child: Padding(
                       padding: const EdgeInsets.only(left:8,right:8,top:2,bottom: 2),
                       child: Icon(Icons.map,color: Colors.white,
                               
                   ),
                     ),
                   
                   ),
                 ),

               ],
             )

           )
           :Container(),
           ExpansionTile(title: Text('order Detailed',
           style: TextStyle(fontSize: 10,color: Colors.black),),
           
           subtitle: Text('view order details',
           style: TextStyle(fontSize: 12,color: Colors.grey),),
           children: [ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
           itemBuilder: (BuildContext context,int index){
           return ListTile(
            leading: CircleAvatar(backgroundColor: Colors.white,),
);
           },
           
           )],
           ),
         ],
       ),
    );
  }
}