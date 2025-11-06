import 'dart:io';

// Form Validator class
class FormValidator {
  // Check if the value is empty
  static String? checkEmptyField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  static String? checkName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }

    final nameRegex = RegExp(r'^[A-Za-z ]+$');

    if (!nameRegex.hasMatch(value)) {
      return 'Please enter a valid name (letters and spaces only)';
    }

    return null;
  }

  // Age validation (Only numbers, between 18 and 150)
  static String? checkAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }

    if (age < 18 || age > 150) {
      return 'Age must be between 18 and 150';
    }

    return null;
  }

  // Phone number validation (min 5 digits, max 15 digits).
  // Accepts formatted international input (will strip non-digit characters before validating).
  static String? checkPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Remove all non-digit characters (this lets values like '+1 555 1234' pass)
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length < 5 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number (5 to 15 digits)';
    }

    return null;
  }

  // Email validation (Updated regex)
  static String? checkValidEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    // Pattern to match valid emails according to the provided rules
    const pattern =
        r"^(?!.*\.\.)(?!.*\.$)(?!.*[@.]{2})[a-zA-Z0-9](?:[a-zA-Z0-9._]*[a-zA-Z0-9])?@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}$";

    final emailRegex = RegExp(pattern);

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password match validation
  static String? checkPasswordMatch(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    // Check if password matches
    if (value != password) {
      return 'Passwords do not match';
    }

    // Regex to check password criteria:
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length > 8;
    bool hasMaxLength = password.length < 16;

    if (hasUppercase == true &&
        hasDigits == true &&
        hasLowercase == true &&
        hasSpecialCharacters == true &&
        hasMinLength == true &&
        hasMaxLength == true) {
      return null;
    } else {
      return 'Password must be between 8 and 16 characters, with at least one lowercase letter, one uppercase letter, one number, and one special character';
    }

    // Check if password matches the pattern
    // if (!passwordRegex.hasMatch(password)) {
    //   return 'Password must be between 8 and 16 characters, with at least one lowercase letter, one uppercase letter, one number, and one special character';
    // }

    // return null;
  }

  // CNIC Validator
  static String? validateCNIC(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter CNIC';
    }
    if (!RegExp(r'^[A-Za-z0-9]{13}$').hasMatch(value)) {
      return 'Invalid CNIC. It should be 13 alphanumeric characters.';
    }
    return null;
  }

  // Years of Experience Validator
  static String? validateYearsOfExperience(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter years of experience';
    }
    final experience = int.tryParse(value);
    if (experience == null || experience < 0) {
      return 'Experience should be a positive number';
    }
    return null;
  }

  // Education field validation
  static String? checkEducationField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  // Image validation (accepts png, jpeg, jpg, img, and file size < 500KB)
  static String? checkImageFile(File? imageFile) {
    if (imageFile == null) {
      return 'Please select a profile picture';
    }

    // Check image type (must be png, jpeg, jpg, or img)
    final imageExtension = imageFile.path.split('.').last.toLowerCase();
    if (!['png', 'jpeg', 'jpg', 'img'].contains(imageExtension)) {
      return 'Only PNG, JPEG, JPG, and IMG formats are allowed';
    }

    // Check image size (must be less than 500KB)
    final imageSizeInKB = imageFile.lengthSync() / 1024;
    if (imageSizeInKB > 500) {
      return 'Image must be less than 500KB';
    }

    return null;
  }
}
