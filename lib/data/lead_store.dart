import 'package:flutter/foundation.dart';
import 'package:leads/models/lead.dart';

/// Simple in-memory store to share leads across screens.
class LeadStore {
  LeadStore._();

  static final LeadStore instance = LeadStore._();

  /// Notifies listeners whenever the list changes.
  final ValueNotifier<List<Lead>> leads = ValueNotifier<List<Lead>>([]);

  void addLead(Lead lead) {
    leads.value = [...leads.value, lead];
  }

  void upsertLead(Lead lead) {
    final existingIndex = leads.value.indexWhere((l) => l.id == lead.id);
    if (existingIndex == -1) {
      addLead(lead);
    } else {
      final updated = [...leads.value];
      updated[existingIndex] = lead;
      leads.value = updated;
    }
  }

  void replaceAll(List<Lead> newLeads) {
    leads.value = List<Lead>.from(newLeads);
  }
}
