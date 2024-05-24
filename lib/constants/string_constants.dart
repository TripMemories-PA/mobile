class StringConstants {
  // Basic
  String get yes => 'Yes';
  String get no => 'No';

  // Authentication
  String get notAuthenticated => 'Not authenticated';
  String get wrongEmailOrPassword => 'Wrong email or password';
  String get emailOrUsernameAlreadyExists => 'Email or username already used';
  String get invalidEmail => 'Invalid email';
  String get invalidPassword => 'Invalid password';
  String get passwordNotMatch => 'The passwords do not match';
  String get requiredField => 'Required field';

  // Error Messages
  String get hostUnreachable => 'Host unreachable';
  String get cannotReachLocalData => 'Cannot reach local data';
  String get unknownError => 'Unknown error';
  String get errorOccurred => 'Error occurred';
  String get errorLoadingImage => 'Error occurred while loading image';
  String get errorOccurredWhileQueryingServer =>
      'Error occurred while querying server';
  String get errorOccurredWhileParsingResponse =>
      'Error occurred while parsing response';
  String get errorWhilePostingTweet => 'Error while posting tweet';
  String get errorWhilePostingComment => 'Error while posting comment';
  String get errorAppendedWhileGettingData =>
      'An error occurred while getting data';
  String get errorOccurredWhileLoggingIn => 'Error occurred while logging in';
  String get errorHappenedWhileUpdatingTweet =>
      'Error happened while updating tweet';
  String get errorHappenedWhileDeletingTweet =>
      'Error happened while deleting tweet';
  String get errorHappenedWhileDeletingComment =>
      'Error happened while deleting comment';
  String get errorHappenedWhileUpdatingComment =>
      'Error happened while updating comment';
  String get badFileFormat => 'Bad file format';
  String get badRequest => 'Bad request';
  String get requestTimeout => 'Request timeout';
  String get unauthorized => 'Unauthorized';
  String get cannotGetUserDetails => 'Cannot get user details';
  String get cannotGetUserPosts => 'Cannot get user posts';
  String get badImageFormat =>
      "Mauvaise format d'image: seulement jpg, jpeg et png sont autorisés";

  String get confirmAction => 'Etes-vous sûr ?';

  String get profileUpdated => 'Profil modifié !';

  String get noMoreFriends => "Plus d'amis à afficher.";
  String get retry => 'Réessayer';

  String get friendRequestAccepted => "Demande d'ami acceptée";
  String get friendRequestRefused => "Demande d'ami refusée";
}
