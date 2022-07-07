import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as im_;

class PdfService {
  Future<pw.Document> generatePdfFromImages(List<String> imagePaths) async {
    final pdf = pw.Document();

    for (final element in imagePaths) {
      final im_.Image image =
          im_.decodeImage(await File(element).readAsBytes())!;
      final Uint8List imageFileBytes =
          Uint8List.fromList(im_.encodeJpg(image, quality: 60));

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pw.MemoryImage(imageFileBytes),
                  fit: pw.BoxFit.contain),
            );
          },
        ),
      );
    }

    return pdf;
  }
}
