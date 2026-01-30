import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stride/UI/add_to_dialog.dart';
import 'package:stride/models/todo.dart';
import 'package:stride/providers/theme_provider.dart';
import 'package:stride/services/todo_database.dart';

class HomeScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const HomeScreen({super.key, required this.themeProvider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> _todos = [];
  bool _showCompleted = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await TodoDatabase.getAllTodos();
    setState(() {
      _todos = todos;
      _todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  List<Todo> get _filteredTodos {
    if (_showCompleted) {
      return _todos;
    }
    return _todos.where((todo) => !todo.isCompleted).toList();
  }

  int get _completedCount => _todos.where((todo) => todo.isCompleted).length;
  int get _activeCount => _todos.where((todo) => !todo.isCompleted).length;

  Future<void> _addTodo() async {
    final result = await showDialog<Todo>(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );

    if (result != null) {
      await TodoDatabase.addTodo(result);
      _loadTodos();
    }
  }

  Future<void> _toggleTodo(Todo todo) async {
    todo.toggleComplete();
    await TodoDatabase.updateTodo(todo);
    _loadTodos();
  }

  Future<void> _deleteTodo(Todo todo) async {
    await TodoDatabase.deleteTodo(todo.id);
    _loadTodos();
  }

  Future<void> _deleteCompleted() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Completed Tasks'),
        content: Text('Are you sure you want to delete $_completedCount completed task(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await TodoDatabase.deleteAllCompleted();
      _loadTodos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(widget.themeProvider.isDarkMode 
              ? Icons.light_mode 
              : Icons.dark_mode),
            onPressed: widget.themeProvider.toggleTheme,
            tooltip: 'Toggle theme',
          ),
          if (_completedCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _deleteCompleted,
              tooltip: 'Delete completed',
            ),
        ],
      ),
      body: Column(
        children: [
          // Stats Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.themeProvider.isDarkMode
                  ? [Colors.blue.shade800, Colors.blue.shade600]
                  : [Colors.blue.shade400, Colors.blue.shade600],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Active', _activeCount, Icons.pending_actions),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white30,
                ),
                _buildStatItem('Completed', _completedCount, Icons.check_circle),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white30,
                ),
                _buildStatItem('Total', _todos.length, Icons.list_alt),
              ],
            ),
          ),

          // Filter Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Show Completed',
                  style: theme.textTheme.titleMedium,
                ),
                const Spacer(),
                Switch(
                  value: _showCompleted,
                  onChanged: (value) {
                    setState(() {
                      _showCompleted = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Todo List
          Expanded(
            child: _filteredTodos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _showCompleted ? Icons.task_alt : Icons.check_circle_outline,
                          size: 80,
                          color: theme.colorScheme.primary.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _showCompleted 
                            ? 'No tasks yet!\nTap + to add one'
                            : 'All tasks completed!',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = _filteredTodos[index];
                      return _buildTodoItem(todo);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTodo,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  Widget _buildStatItem(String label, int count, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          '$count',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTodoItem(Todo todo) {
    final theme = Theme.of(context);
    
    return Dismissible(
      key: Key(todo.id),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _deleteTodo(todo),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (value) => _toggleTodo(todo),
            shape: const CircleBorder(),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isCompleted 
                ? TextDecoration.lineThrough 
                : null,
              color: todo.isCompleted 
                ? theme.colorScheme.onSurface.withOpacity(0.5)
                : null,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (todo.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  todo.description,
                  style: TextStyle(
                    decoration: todo.isCompleted 
                      ? TextDecoration.lineThrough 
                      : null,
                    color: todo.isCompleted 
                      ? theme.colorScheme.onSurface.withOpacity(0.4)
                      : null,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM d, y • h:mm a').format(todo.createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  if (todo.isCompleted && todo.completedAt != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.check_circle,
                      size: 12,
                      color: Colors.green.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM d').format(todo.completedAt!),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green.withOpacity(0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _deleteTodo(todo),
            color: Colors.red.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}