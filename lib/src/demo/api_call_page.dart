import 'package:flutter/material.dart';

import 'models/user_list_dto.dart';
import 'repository/demo_repository.dart';

class DemoApiCallPage extends StatefulWidget {
  const DemoApiCallPage({super.key});

  @override
  State<DemoApiCallPage> createState() => _DemoApiCallPageState();
}

class _DemoApiCallPageState extends State<DemoApiCallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<UserListDto>(
        future: DemoRepository.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.data == null) {
            return const Center(
              child: Text('No data available'),
            );
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Page ${snapshot.data!.page} of ${snapshot.data!.totalPages}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.data!.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data!.data![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.avatar ?? ''),
                          ),
                          title: Text('${user.firstName} ${user.lastName}'),
                          subtitle: Text(user.email ?? ''),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Selected user: ${user.firstName}')),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (snapshot.data!.support != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data!.support!.text ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
