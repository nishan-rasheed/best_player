
import 'package:flutter/material.dart';
import 'package:mx_p/constants/app_images.dart';
import 'package:mx_p/constants/global_variables.dart';
import 'package:mx_p/test_folder/test_list_screen.dart';
import 'package:path/path.dart' as path;
import '../../controller/directory_controller.dart';
import '../../controller/thumbnail_controller.dart';
import 'list_detail_screen.dart';
import 'package:provider/provider.dart';

class ListDirectoryScreen extends StatefulWidget {
  const ListDirectoryScreen({Key? key}) : super(key: key);

  @override
  State<ListDirectoryScreen> createState() => _ListDirectoryScreenState();
}

class _ListDirectoryScreenState extends State<ListDirectoryScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DirectoryProvider>().loadDirectories();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Files---${appSdkVersion}'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TestListScreen(),));
      }),
      body: Selector<DirectoryProvider,({ bool first ,Map<String, List<String>> second})>(
        selector: (p0, p1) => (first: p1.isLoading,second:p1.contentFilesByFolder),
        builder: (context, directoryProvider, child) {
          if (directoryProvider.first) {
            return const Center(child: CircularProgressIndicator());
          }
    
          return ListView.builder(
            itemCount: directoryProvider.second.keys.length,
            itemBuilder: (BuildContext context, int index) {
              String folderPath = directoryProvider.second.keys.elementAt(index);
              String folderName = path.basename(folderPath);
              List<String> files = directoryProvider.second[folderPath]!;
    
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      ChangeNotifierProvider(
                        create: (context) => ThumbnailController(),
                        child: ListDetailScreen(videos: files)),
                    ),
                  );
                },
                child: ListTile(
                  leading: Image.asset(AppAssets.folderIconImage),
                  title: Text(folderName),
                  subtitle: Text('(${files.length} videos)'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}