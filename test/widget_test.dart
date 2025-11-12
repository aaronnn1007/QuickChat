// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quickchat/main.dart';
import 'package:quickchat/pages/settings_page.dart';
import 'package:quickchat/pages/add_contact_page.dart';
import 'package:quickchat/pages/chat_page.dart';

void main() {
  testWidgets('Home page shows greeting', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('QuickChat'), findsOneWidget); // AppBar title
    // Greeting removed; verify seeded chat is visible
    expect(find.text('Alice Johnson'), findsOneWidget);
  });

  testWidgets('Navigate to settings page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Open drawer
    ScaffoldState scaffoldState = tester.firstState(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
    expect(find.text('Dark mode'), findsOneWidget);
  });

  testWidgets('Navigate to add contact page and validate form', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Use FAB (+) instead of drawer now
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.byType(AddContactPage), findsOneWidget);
  await tester.enterText(find.byType(TextFormField).at(0), 'New Friend');
  await tester.enterText(find.byType(TextFormField).at(1), '@newfriend');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    // After saving we pop back to home - new contact should now appear
    expect(find.text('New Friend'), findsOneWidget);
  });

  testWidgets('Send a chat message', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Open via seeded chat item
    await tester.tap(find.text('Alice Johnson'));
    await tester.pumpAndSettle();
    expect(find.byType(ChatPage), findsOneWidget);
    // Title should reflect contact name
    expect(find.text('Alice Johnson'), findsWidgets);
    await tester.enterText(find.byType(TextField), 'Hello world');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();
    expect(find.text('Hello world'), findsOneWidget);
    // Return to home and ensure updated preview shows latest message
    await tester.pageBack();
    await tester.pumpAndSettle();
    // First ListTile should contain the new message
    // Expect 'Hello world' now visible somewhere on home list
    expect(find.text('Hello world'), findsOneWidget);
  });
}
