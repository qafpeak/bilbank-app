
import 'package:bilbank_app/presentation/components/main/custom_gradient_scaffold.dart';
import 'package:flutter/material.dart';

import '../../../components/common/custom_dropdown.dart';
import 'report_issue_mixin.dart';
import 'report_issue_view_components/custom_textfield.dart';
import 'report_issue_view_components/footer_info.dart';
import 'report_issue_view_components/report_view_header.dart';
import 'report_issue_view_components/report_view_info_card.dart';
import 'report_issue_view_components/submit_button.dart';
import 'report_issue_view_components/success_card.dart';
import 'report_issue_view_components/summary_container.dart';

class ReportIssueView extends StatefulWidget {
  const ReportIssueView({Key? key}) : super(key: key);

  @override
  _ReportIssueViewState createState() => _ReportIssueViewState();
}

class _ReportIssueViewState extends State<ReportIssueView> with ReportIssueMixin{
  
  @override
  Widget build(BuildContext context) {
    if (isSubmitted) {
      return buildSuccessPage();
    }

    return CustomGradientScaffold(
      appBar: AppBar(
        title: Text('Sorun Bildirimi'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReportViewHeader(
              title: 'Sorun Bildirimi',
              subtitle:
                  'Karşılaştığınız sorunları bize bildirin, en kısa sürede çözüme kavuşturalım.',
              icon: Icons.warning,
            ),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ReportViewInfoCard(
                    title: 'Bilgilendirme',
                    items: [
                      'Sorun bildiriminiz 24 saat içerisinde değerlendirilecektir',
                      'Detaylı açıklama yapmanız sorunun daha hızlı çözülmesine yardımcı olacaktır',
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropdown(
                          label: 'Sorun Kategorisi *',
                          value: selectedCategory,
                          hint: 'Kategori seçiniz',
                          items: categories,
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value ?? '';
                            });
                            clearError('category');
                          },
                          errorText: errors['category'],
                        ),
                        SizedBox(height: 24),
                        CustomTextField(
                          label: 'Konu Başlığı *',
                          hintText: 'Sorununuzu kısaca özetleyin',
                          controller: subjectController,
                          onChanged: (value) => clearError('subject'),
                          errorText: errors['subject'],
                        ),
                        SizedBox(height: 24),
                        CustomTextField(
                          label: 'Detaylı Açıklama *',
                          hintText:
                              'Sorununuzu detaylarıyla açıklayın. Ne zaman başladığını, hangi adımlarda karşılaştığınızı ve hata mesajlarını belirtirseniz daha hızlı yardımcı olabiliriz.',
                          controller: descriptionController,
                          maxLines: 6,
                          maxLength: 500,
                          onChanged: (value) => clearError('description'),
                          errorText: errors['description'],
                        ),
                        SizedBox(height: 32),
                        SubmitButton(
                          text: 'Sorun Bildirimini Gönder',
                          icon: Icons.send,
                          onPressed: submitForm,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FooterInfo(
              emergencyText: 'Acil durumlar için: ',
              email: 'destek@example.com',
              phone: '0555 123 45 67',
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget buildSuccessPage() {
    {
    return CustomGradientScaffold(
      appBar: AppBar(
        title: Text('Sorun Bildirimi'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 50),
            SuccessCard(
              title: 'Sorun Bildiriminiz Alındı',
              message:
                  'Sorun bildiriminiz başarıyla gönderildi. En kısa sürede size geri dönüş yapacağız.',
              summaryContent: SummaryContainer(
                items: [
                  SummaryItem(
                    label: 'Kategori:',
                    value: categories.firstWhere(
                      (cat) => cat['value'] == selectedCategory,
                    )['label']!,
                  ),
                  SummaryItem(label: 'Konu:', value: subjectController.text),
                  SummaryItem(
                    label: 'Açıklama:',
                    value: descriptionController.text,
                    isDescription: true,
                    isLast: true,
                  ),
                ],
              ),
              onNewReport: resetForm,
            ),
          ],
        ),
      ),
    );
  }
  }
}
