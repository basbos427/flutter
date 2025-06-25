import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Tasks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 17, color: Color(0xFF333333)),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(),
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 17, color: Colors.white),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const TodoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Task model with type, emoji, color
class Task {
  String title;
  String type; // Work, Study, Personal, Urgent
  Color color;
  bool isDone;

  Task({
    required this.title,
    required this.type,
    required this.color,
    this.isDone = false,
  });
}

IconData getTaskIcon(String type) {
  switch (type) {
    case 'Work':
      return Icons.work_outline;
    case 'Study':
      return Icons.menu_book_outlined;
    case 'Personal':
      return Icons.person_outline;
    case 'Urgent':
      return Icons.warning_amber_outlined;
    default:
      return Icons.task_alt_outlined;
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _tasks.insert(0, Task(
          title: _controller.text.trim(),
          type: 'Work',
          color: Colors.blue,
        ));
        _controller.clear();
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _editTask(int index) async {
    final TextEditingController editController =
        TextEditingController(text: _tasks[index].title);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter new task name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, editController.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _tasks[index].title = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF8E54E9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: const Text(
            'My Tasks',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w900,
              fontSize: 30,
              letterSpacing: 1.5,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC), Color(0xFF8E54E9)],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      // Motivational subtitle
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [Color(0xFF1976D2), Color(0xFF8E54E9)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: const Text(
                          "Let's get things done!",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Glassy add task input
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.08)
                                      : Colors.white.withOpacity(0.22),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.18),
                                    width: 1.2,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _controller,
                                        decoration: const InputDecoration(
                                          hintText: 'Add a new task',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(color: Colors.black38),
                                        ),
                                        style: const TextStyle(fontSize: 17, fontFamily: 'Cairo', color: Colors.black87),
                                        onSubmitted: (_) => _addTask(),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(30),
                                        onTap: _addTask,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [Color(0xFF1976D2), Color(0xFF8E54E9)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(30),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.blue.withOpacity(0.18),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                          child: const Icon(Icons.add, color: Colors.white, size: 26),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Task list
                      Expanded(
                        child: _tasks.isEmpty
                            ? const Center(
                                child: Text(
                                  'No tasks yet',
                                  style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                              )
                            : ListView.separated(
                                itemCount: _tasks.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 18),
                                itemBuilder: (context, index) {
                                  final task = _tasks[index];
                                  return AnimatedSlide(
                                    offset: Offset(0, 0),
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.easeOut,
                                    child: AnimatedOpacity(
                                      opacity: 1,
                                      duration: const Duration(milliseconds: 350),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(24),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? Colors.white.withOpacity(0.10)
                                                  : Colors.white.withOpacity(0.22),
                                              borderRadius: BorderRadius.circular(24),
                                              border: Border.all(
                                                color: Colors.white.withOpacity(0.18),
                                                width: 1.2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.08),
                                                  blurRadius: 16,
                                                  offset: const Offset(0, 6),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            child: Row(
                                              children: [
                                                // Colored side bar
                                                Container(
                                                  width: 5,
                                                  height: 48,
                                                  decoration: BoxDecoration(
                                                    color: task.color,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                // Glassy icon
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: task.color.withOpacity(0.18),
                                                    borderRadius: BorderRadius.circular(16),
                                                    border: Border.all(
                                                      color: Colors.white.withOpacity(0.18),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.all(8),
                                                  child: Icon(
                                                    getTaskIcon(task.type),
                                                    color: task.color,
                                                    size: 22,
                                                  ),
                                                ),
                                                const SizedBox(width: 14),
                                                Checkbox(
                                                  value: task.isDone,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      task.isDone = val ?? false;
                                                    });
                                                  },
                                                  activeColor: task.color,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    task.title,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Cairo',
                                                      color: isDark ? Colors.white : Colors.black87,
                                                      decoration: task.isDone
                                                          ? TextDecoration.lineThrough
                                                          : TextDecoration.none,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                // Edit button
                                                Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.circular(20),
                                                    onTap: () => _editTask(index),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white.withOpacity(0.18),
                                                        borderRadius: BorderRadius.circular(20),
                                                        border: Border.all(
                                                          color: Colors.white.withOpacity(0.18),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      padding: const EdgeInsets.all(8),
                                                      child: Icon(Icons.edit, color: isDark ? Colors.white : Colors.blue, size: 20),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                // Delete button
                                                Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.circular(20),
                                                    onTap: () => _deleteTask(index),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white.withOpacity(0.18),
                                                        borderRadius: BorderRadius.circular(20),
                                                        border: Border.all(
                                                          color: Colors.white.withOpacity(0.18),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      padding: const EdgeInsets.all(8),
                                                      child: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: null,
      floatingActionButtonLocation: null,
    );
  }
}
