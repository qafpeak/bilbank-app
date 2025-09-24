

import 'package:flutter/material.dart';

import 'report_issue_view.dart';

mixin ReportIssueMixin on State<ReportIssueView> {
  final _subjectController = TextEditingController();
  TextEditingController get  subjectController => _subjectController;

  final _descriptionController = TextEditingController();
  TextEditingController get descriptionController => _descriptionController;



  String _selectedCategory = '';
  String get  selectedCategory => _selectedCategory;
  set selectedCategory(String value) {
    setState(() {
      _selectedCategory = value;
    });
  }


  bool _isSubmitted = false;
  bool get isSubmitted => _isSubmitted;

  List<Map<String, String>> get categories => _categories;

  Map<String, String> _errors = {};
  Map<String, String> get errors => _errors;


  final List<Map<String, String>> _categories = [
    {'value': 'withdrawal-balance', 'label': 'Çekim/Bakiye Sorunları'},
    {'value': 'room-tournament', 'label': 'Oda/Yarışma Sorunları'},
    {'value': 'cancel-refund', 'label': 'İptal/İade Sorunları'},
    {'value': 'other', 'label': 'Diğer'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool validateForm() {
    Map<String, String> newErrors = {};

    if (_selectedCategory.isEmpty) {
      newErrors['category'] = 'Lütfen bir kategori seçiniz';
    }

    if (_subjectController.text.trim().isEmpty) {
      newErrors['subject'] = 'Konu başlığı gereklidir';
    } else if (_subjectController.text.trim().length < 5) {
      newErrors['subject'] = 'Konu başlığı en az 5 karakter olmalıdır';
    }

    if (_descriptionController.text.trim().isEmpty) {
      newErrors['description'] = 'Açıklama gereklidir';
    } else if (_descriptionController.text.trim().length < 20) {
      newErrors['description'] = 'Açıklama en az 20 karakter olmalıdır';
    }

    setState(() {
      _errors = newErrors;
    });

    return newErrors.isEmpty;
  }

  void submitForm() {
    if (validateForm()) {
      setState(() {
        _isSubmitted = true;
      });
      print(
        'Form gönderildi: $_selectedCategory, ${_subjectController.text}, ${_descriptionController.text}',
      );
    }
  }

  void resetForm() {
    setState(() {
      _selectedCategory = '';
      _subjectController.clear();
      _descriptionController.clear();
      _isSubmitted = false;
      _errors = {};
    });
  }

  void clearError(String field) {
    if (_errors.containsKey(field)) {
      setState(() {
        _errors.remove(field);
      });
    }
  }

  Widget buildSuccessPage() ;

}