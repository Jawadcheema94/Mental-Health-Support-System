import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class JournalScreen extends StatefulWidget {
  final String userId; // Pass userId to the screen

  const JournalScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _entryController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _journalEntriesFuture;
  final String _selectedMood = 'neutral'; // Default mood
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _journalEntriesFuture = _fetchJournalEntries(); // Fetch entries on init
  }

  // Fetch journal entries from the API
  Future<List<Map<String, dynamic>>> _fetchJournalEntries() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/journal/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((entry) => {
          'id': entry['_id'],
          'date': entry['entryDate'],
          'entry': entry['content'],
          'sentimentScore': entry['sentimentScore'],
        }).toList();
      } else {
        throw Exception('Failed to load journal entries: ${response.body}');
      }
    } catch (e) {
      print('Fetch Error: $e'); // Log error for debugging
      throw Exception('Error fetching entries: $e');
    }
  }

  // Create a new journal entry
  Future<void> _addJournalEntry(String content) async {
    if (content.isEmpty) return; // Prevent empty entries

    setState(() => _isLoading = true);

    try {
      final payload = {
        'userId': widget.userId,
        'date': DateTime.now().toIso8601String(),
        'sentimentScore': 0,
        'content': content,
        
      };
      print('Sending payload: $payload'); // Log payload for debugging

      final response = await http.post(
        Uri.parse('http://localhost:3000/api/journal/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print('Response: ${response.statusCode} ${response.body}'); // Log response

      if (response.statusCode == 201) {
        setState(() {
          _journalEntriesFuture = _fetchJournalEntries(); // Refresh entries
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Journal entry saved!')),
        );
      } else {
        throw Exception('Failed to save entry: ${response.body}');
      }
    } catch (e) {
      print('Save Error: $e'); // Log error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving entry: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Delete a journal entry
  Future<void> _deleteJournalEntry(String entryId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/journal/$entryId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Delete Response: ${response.statusCode} ${response.body}'); // Log response

      if (response.statusCode == 200) {
        setState(() {
          _journalEntriesFuture = _fetchJournalEntries(); // Refresh entries
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Journal entry deleted!')),
        );
      } else {
        throw Exception('Failed to delete entry: ${response.body}');
      }
    } catch (e) {
      print('Delete Error: $e'); // Log error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting entry: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journal'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _journalEntriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildNoEntriesView();
          } else {
            final journalEntries = snapshot.data!;
            return _buildJournalEntriesView(journalEntries);
          }
        },
      ),
    );
  }

  Widget _buildNoEntriesView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No journal entries yet. Start writing!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showCreateEntryDialog,
            child: const Text('Add Entry'),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalEntriesView(List<Map<String, dynamic>> journalEntries) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _showCreateEntryDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Entry'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Your Journal Entries',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: journalEntries.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final entry = journalEntries[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    DateFormat.yMMMd().format(DateTime.parse(entry['date'])),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple,
                    ),
                  ),
                  subtitle: Text(
                    entry['entry'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteJournalEntry(entry['id']),
                  ),
                  onTap: () => _viewFullEntry(context, entry),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCreateEntryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Journal Entry'),
          content: TextField(
            controller: _entryController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Write your thoughts, feelings, or experiences...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      final entry = _entryController.text;
                      if (entry.isNotEmpty) {
                        _addJournalEntry(entry);
                        _entryController.clear();
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please write something before saving.')),
                        );
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _viewFullEntry(BuildContext context, Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Journal Entry - ${DateFormat.yMMMd().format(DateTime.parse(entry['date']))}'),
          content: SingleChildScrollView(
            child: Text(
              entry['entry'],
              style: const TextStyle(fontSize: 16),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }
}

