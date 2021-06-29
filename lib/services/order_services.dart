

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_boy_app/services/firebase_services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:map_launcher/map_launcher.dart';

import 'package:url_launcher/url_launcher.dart';

class OrderServices{

  FirebaseServices _services=FirebaseServices();
  Color statusColor(document){
    if(document.data()['orderStatus']== 'Rejected'){
      return Colors.red;
    }
     if(document.data()['orderStatus']== 'Accepted'){
      return Colors.blueGrey[400];
    }
     if(document.data()['orderStatus']== 'Picked Up'){
      return Colors.pink[900];
    }
     if(document.data()['orderStatus']== 'On the way'){
      return Colors.deepPurpleAccent;
    }
     if(document.data()['orderStatus']== 'Delivered'){
      return Colors.green;
    }
    return Colors.orange;
  }
 


 Icon statusIcon(document){
    
     if(document.data()['orderStatus']== 'Accepted'){
      return Icon(Icons.assignment_turned_in_outlined,color: statusColor(document),);
    }
     if(document.data()['orderStatus']== 'Picked Up'){
      return Icon(Icons.cases,color: statusColor(document),);
    }
     if(document.data()['orderStatus']== 'On the way'){
     return Icon(Icons.delivery_dining,color: statusColor(document),);
    }
     if(document.data()['orderStatus']== 'Delivered'){
      return Icon(Icons.shopping_bag_outlined,color: statusColor(document),);
    }
   return Icon(Icons.assignment_turned_in_outlined,color: statusColor(document),);
  }


  Widget statusContainer(document,context){

    if(document.data()['deliveryboys']['name'].length>1)
    {

if(document.data()['orderStatus']=='Accepted'){
return Container(
  color: Colors.grey[300],
  height: 50,
  width: MediaQuery.of(context).size.width,
  child: Padding(padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
  child: TextButton(
    child: Text('Update Status to Picked Up',
    style: TextStyle(color: Colors.white),
    ),
    onPressed: (){
      EasyLoading.show();
    _services.updateStatus(id: document.id,status: 'Picked Up').then((value) { 
      EasyLoading.showSuccess(
      'Order status is now Picked Up');
     }, );
    },
    style: ButtonStyle(backgroundColor: ButtonStyleButton.allOrNull<Color>(statusColor(document)),
  ),
  ),
  
),
);
    }
}


if(document.data()['orderStatus']=='Picked Up'){
return Container(
  color: Colors.grey[300],
  height: 50,
  width: MediaQuery.of(context).size.width,
  child: Padding(padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
  child: TextButton(
    child: Text('Update Status to On the way',
    style: TextStyle(color: Colors.white),
    ),
    onPressed: (){
      EasyLoading.show();
    _services.updateStatus(id: document.id,status: 'On the way').then((value) { 
      EasyLoading.showSuccess(
      'Order status is now On the way');
     }, );
    },
    style: ButtonStyle(backgroundColor: ButtonStyleButton.allOrNull<Color>(statusColor(document)),
  ),
  ),
  
),
);
    }



    if(document.data()['orderStatus']=='On the way'){
return Container(
  color: Colors.grey[300],
  height: 50,
  width: MediaQuery.of(context).size.width,
  child:Padding(padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
    child: TextButton(
      child: Text('Deliver Order',
      style: TextStyle(color: Colors.white),
      ),
      onPressed: (){
        EasyLoading.show();
       if(document.data()['cod']==true){
         return showMyDialog("Receive Payment", 'Delivered', document.id, context);
       }
       else{
_services.updateStatus(id: document.id,status: 'Delivered').then((value) { 
        EasyLoading.showSuccess(
        'Order status is now delivered');
       }, );
       }
      
      },
      style: ButtonStyle(backgroundColor: ButtonStyleButton.allOrNull<Color>(statusColor(document)),
    ),
    ),
  ),
);
    }

      
return Container(
  color: Colors.grey[300],
  height: 50,
  width: MediaQuery.of(context).size.width,
  child: TextButton(
    child: Text('Order Completed',
    style: TextStyle(color: Colors.white),
    ),
    onPressed: (){
     
    },
    style: ButtonStyle(backgroundColor: ButtonStyleButton.allOrNull<Color>(Colors.green),
  ),
  ),
);
   





//     return Container(
//       color: Colors.teal[300],
//       height: 50,
//       child: Row(children: [
//         Expanded(
//           child:Padding(
//             padding: const EdgeInsets.all(8),
//         child: FlatButton(color: Colors.blueGrey,onPressed: (){
//           showMyDialog('Accept Order', 'Accepted', document.id, context);
//         }, 
//         child:  Text('Accept',style: TextStyle(color: Colors.white),
//           ),
//           ),
          
         
      
//         ),),
//          Expanded(
//           child:Padding(
//             padding: const EdgeInsets.all(8),
//         child: AbsorbPointer(
//           absorbing: document.data()[' orderStatus'] == 'Rejected' ? true :false,
//            child: FlatButton(
//              color:  document.data()[' orderStatus'] == 'Rejected' ? Colors.grey: Colors.red ,
//              onPressed: (){
             
//           showMyDialog('Reject Order', 'Rejected', document.id, context);
//         }, 
//         child:  Text('Reject',style: TextStyle(color: Colors.white),
//           ),
//           ),
//           ),
          
         
      
//         ),),

//  Expanded(
//           child:Padding(
//             padding: const EdgeInsets.all(8),
//         child: FlatButton(color: Colors.pink[900],onPressed: (){
//           showMyDialog('Picked up', 'PickedUp', document.id, context);
//         }, 
//         child:  Text('PickedUp',style: TextStyle(color: Colors.white),
//           ),
//           )
          
         
      
//         ),),

//                 Expanded(
//           child:Padding(
//             padding: const EdgeInsets.all(8),
//         child: AbsorbPointer(
//           absorbing: document.data()[' orderStatus'] == 'On The Way' ? true :false,
//            child: FlatButton(
//              color:  document.data()[' orderStatus'] == 'On The Way' ? Colors.grey: Colors.deepPurpleAccent ,
//              onPressed: (){
             
//           showMyDialog('On The Way Order', 'On The Way', document.id, context);
//         }, 
//         child:  Text('On The Way',style: TextStyle(color: Colors.white),
//           ),
//           ),
//           ),
          
         
      
//         ),),

//          Expanded(
//           child:Padding(
//             padding: const EdgeInsets.all(8),
//         child: AbsorbPointer(
//           absorbing: document.data()[' orderStatus'] == 'Delivered' ? true :false,
//            child: FlatButton(
//              color:  document.data()[' orderStatus'] == 'Delivered' ? Colors.grey: Colors.green,
//              onPressed: (){
             
//           showMyDialog('Delivered Order', 'Delivered', document.id, context);
//         }, 
//         child:  Text('Delivered',style: TextStyle(color: Colors.white),
//           ),
//           ),
//           ),
          
         
      
//         ),),

//       ],),
//     );

    
  }


void launchCall(number) async => await canLaunch(number) ? await launch(number) :throw 'Could not launch $number';
void launchMap(lat,lng,name)async{
  
  final availableMaps =await MapLauncher.installedMaps;
  await availableMaps.first.showMarker(
    coords: Coords(lat,lng),
    title:name,
  );
}
showMyDialog(title,status,documentID,context){
 OrderServices _orderServices= OrderServices();
 showCupertinoDialog(context: context, builder:(BuildContext context){
    return CupertinoAlertDialog(
      // user must tap button!
    
        
          title: Text(title),
         content: Text('Make sure you have received payment '),
          actions: <Widget>[
            TextButton(
              child: Text('RECEIVE',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              fontWeight:FontWeight.bold
              ),
              ),
               onPressed: () {
                 EasyLoading.show();
              _services.updateStatus(id: documentID,status: 'Delivered').then((value){
                EasyLoading.showSuccess('Order status is now Delivered');
                Navigator.pop(context);
              });
                    },
              ),
              TextButton(onPressed: (){}, child: Text('Cancel',
              style: TextStyle(
color: Theme.of(context).primaryColor

              ),))
             
           
          ],
        );
      
    
 });


}

}






// return document.data()['deliveryboys']['image']==null ? Container():ListTile(
//   leading: CircleAvatar(
//     backgroundColor: Colors.white,
//     child: Image.network(document.data()['deliveryboys']['image']),
//   ),
//   title: new Text(document.data()['deliveryboys']['name']),
//   trailing: Row(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       IconButton(
//         icon: Icon(Icons.map,color: Theme.of(context).primaryColor,),
//         onPressed: (){
//           GeoPoint location=document.data()['deliveryboys']['location'];
//           launchMap(location, document.data()['deliveryboys']['name']);
//         },
//       ),
//       IconButton(
//         icon: Icon(Icons.phone,color: Theme.of(context).primaryColor,),
//         onPressed: (){
          
//           launchCall('tel:${document.data()['deliveryboys']['phone']}');
//         },
//       ),
//     ],
//   ),
// );