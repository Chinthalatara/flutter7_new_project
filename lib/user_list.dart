import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_registration/edituserscreen.dart';
import 'package:user_registration/providerfile.dart';

// class UserList extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final users = ref.watch(userProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User List'),
//       ),
//       body: users.isEmpty
//           ? Center(child: Text('No users registered'))
//           : ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 final user = users[index];
//                 return ListTile(
//                   leading: user.profilePhoto != null
//                       ? CircleAvatar(backgroundImage: MemoryImage(user.profilePhoto!))
//                       : CircleAvatar(child: Icon(Icons.person)),
//                   title: Text('${user.firstName} ${user.lastName}'),
//                   subtitle: Text(user.email),
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () {
//                       ref.read(userProvider.notifier).deleteUser(user.mobileNumber);
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Deleted')));
//                     },
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
class UserList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: users.isEmpty
          ? Center(child: Text('No users registered'))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: user.profilePhoto != null
                      ? CircleAvatar(backgroundImage: MemoryImage(user.profilePhoto!))
                      : CircleAvatar(child: Icon(Icons.person)),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Navigate to the EditUserScreen with the selected user
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditUserScreen(user: user),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          ref.read(userProvider.notifier).deleteUser(user.mobileNumber);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Deleted')));
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
