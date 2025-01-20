# Password Manager

## Overview

This script is a simple password manager implemented in Bash. It allows users to securely store, retrieve, import, export, and manage passwords for various accounts. The script encrypts passwords using OpenSSL with AES-256 encryption, ensuring that your sensitive data is protected.

## Features

- Add a new password for an account.
- Retrieve a stored password by account name.
- List all stored account names.
- Import passwords from a file.
- Export all stored passwords to a decrypted file.
- Prevent duplicate account names.
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
4. **Import passwords**: Import passwords from a file. Each line in the file must follow the format:
   ```
   account:password
   ```
   Invalid or duplicate entries will be skipped.
5. **Export passwords**: Export all stored passwords in decrypted form to a specified file.
6. **Help**: View a help message explaining the functionality of the script.
7. **Exit**: Exit the password manager.

### Example Workflow

1. Run the script:
   ```bash
   ./passwordManager.sh
   ```
2. Enter the master password. If it’s your first time, the script will prompt you to set a master password.
3. Choose an option from the menu to perform the desired action.

## Security Notes

- The master password is required to decrypt the stored passwords. Choose a strong master password and keep it private.
- The encrypted password file is stored as `passwords.enc`. Without the master password, the data cannot be decrypted.
- Use the `chmod` command to restrict access to sensitive files:
  ```bash
  chmod 600 passwords.enc
  ```

## Troubleshooting

### Common Issues

- **Incorrect master password**: Ensure you’re entering the correct master password.
- **File not found errors during import/export**: Double-check the file path and permissions.

