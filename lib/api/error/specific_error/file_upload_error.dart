import '../../../constants/string_constants.dart';
import '../api_error.dart';

class FileUploadError extends ApiError {
  const FileUploadError(super.description);

  static FileUploadError badImageFormat() {
    return FileUploadError(StringConstants().badImageFormat);
  }
}
