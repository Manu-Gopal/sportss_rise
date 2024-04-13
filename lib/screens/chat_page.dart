// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({Key? key}) : super(key: key);

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   dynamic userTo;
//   dynamic userFrom = Supabase.instance.client.auth.currentUser!.id;
//   final msgController = TextEditingController();
//   final supabase = Supabase.instance.client;

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       userTo = ModalRoute.of(context)?.settings.arguments as Map?;
//     });
//   }

//   @override
//   void dispose() {
//     msgController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               children: const [],
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Form(
//                 child: TextFormField(
//                   controller: msgController,
//                   decoration: InputDecoration(
//                     labelText: 'Message',
//                     suffixIcon: IconButton(
//                       onPressed: () async {
//                         String msg = msgController.text;
//                         await supabase.from('message').insert({
//                           'user_from': userFrom,
//                           'user_to': userTo['user_to'],
//                           'message' : msg
//                         });
//                         msgController.clear();
//                       },
//                       icon: const Icon(
//                         Icons.send_rounded,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
