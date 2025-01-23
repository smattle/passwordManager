# Password Manager

## Overview

This script is a simple password manager implemented in Bash. It allows users to securely store, retrieve, import, export, and manage passwords for various accounts. The script encrypts passwords using OpenSSL with the AES-256 encryption.

## Features

- Add a new password for an account.
- Retrieve a stored password by account name.
- List all stored account names.
- Import passwords from a file.
- Export all stored passwords to a decrypted file.
- Securely encrypt and decrypt passwords using a master password.

## Requirements

- Bash
- OpenSSL

## Installation

1. Clone or download this repository.
2. Ensure the script is executable by running:
   ```bash
   chmod +x passwordManager.sh
   ```

## Usage

Run the script:

```bash
./passwordManager.sh
```

### Options

When you run the script, you'll be prompted with the following menu:

1. **Add a new password**: Store a password for an account. You’ll be asked for an account name and a password.
2. **Retrieve a password**: Retrieve a password for a specific account by entering its name.
3. **List all accounts**: View all stored account names without showing their passwords.
4. **Delete password**: Delete a password for a specific account by entering its name.
5. **Export passwords**: Export all stored passwords in decrypted form to a specified file.
6. **Import passwords**: Import passwords from a file. Each line in the file must follow the format:
   ```
   account:password
   ```
   Invalid or duplicate entries will be skipped.
7. **Help**: View a help message explaining the functionality of the script.
8. **Exit**: Exit the password manager.

## Security Notes

- The master password is required to decrypt the stored passwords. Choose a strong master password and keep it private.
- The encrypted password file is stored as `passwords.enc`. Without the master password, the data cannot be decrypted.

## Troubleshooting

### Common Issues

- **Incorrect master password**: Ensure you’re entering the correct master password.
- **File not found errors during import/export**: Double-check the file path and permissions.
- **Import not importing last line**: Ensure the import file ends on a newline