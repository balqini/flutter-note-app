import 'package:flutter/material.dart';
import 'package:flutter_note/model/task.model.dart';
import 'package:flutter_note/providers/user.provider.dart';
import 'package:flutter_note/screen/add-task.screen.dart';
import 'package:flutter_note/service/api.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async {
              // signOut(context);
              await AppUser.instance.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Task>>(
          stream: getTaskListStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Task> taskList = snapshot.data!;
              // taskList.sort((a,b)=>a.title.compareTo(b.title));
              return ListView(
                children: List.generate(
                  taskList.length,
                  (i) {
                    return TaskContainer(
                      task: taskList[i],
                      index: i,
                    );
                  },
                ),
              );
            } else
              return Container();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskScreen(),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TaskContainer extends StatelessWidget {
  final Task task;
  final int index;

  TaskContainer({required this.task, required this.index});

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    task.description,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    task.author,
                    style: TextStyle(fontSize: 20),
                  ),
                  task.createdDate != null
                      ? Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              task.createdDate.toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  print(task.id);
                  if (task.id != null) await deleteTask(task.id!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
