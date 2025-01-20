#!/bin/bash

PASSWORD_STORE="passwords.enc"
TEMP_FILE="temp_passwords.txt"
CIPHER="aes-256-cbc"

# Always delete temporary file when exiting manager
trap "shred -u $TEMP_FILE" EXIT

encrypt_file() {
    openssl enc -$CIPHER -salt -in "$TEMP_FILE" -out "$PASSWORD_STORE" -pass pass:"$MASTER_PASSWORD" 2>/dev/null
}

decrypt_file() {
    openssl enc -d -$CIPHER -in "$PASSWORD_STORE" -out "$TEMP_FILE" -pass pass:"$MASTER_PASSWORD" 2>/dev/null
}

# Initialize password Manager
if [[ ! -f $PASSWORD_STORE ]]; then
    echo "No password store found. Creating a new one..."
    echo "Set a master password:"
    read -s MASTER_PASSWORD
    echo
    echo "Confirm the master password:"
    read -s MASTER_PASSWORD_CONFIRM

    if [[ "$MASTER_PASSWORD" != "$MASTER_PASSWORD_CONFIRM" ]]; then
        echo "Passwords do not match. Exiting."
        ecit 1
    fi

    touch "$TEMP_FILE"
    encrypt_file
    echo "Password store initalized successfully!"
else
    echo "Enter master password:"
    read -s MASTER_PASSWORD
fi

# Verify master password
decrypt_file
if [[ $? -ne 0 ]]; then
    echo "Incorrect master password. Exiting."
    exit 1
fi

while true; do
    echo "Password Manager Options:"
    echo "1. Add a new password"
    echo "2. Retrieve a password"
    echo "3. List all accounts"
    echo "4. Delete a password"
    echo "5. Export passwords"
    echo "6. Import passwords"
    echo "7. Show Help"
    echo "8. Exit"
    read -p "Choose an option: " choice

    case $choice in
    1)
        read -p "Enter account name: " account
        if [[ -z $account ]]; then
            echo "Account name cannot be empty."
            continue
        fi
        
        # Check if account already exists
        decrypt_file
        if grep -q "^$account:" "$TEMP_FILE"; then
            echo "An account with the name '$account' already exists. Choose a different name."
            encrypt_file
            continue
        fi

        read -s -p "Enter password: " password
        if [[ -z $password ]]; then
            echo -e "\nPassword cannot be empty."
            encrypt_file
            continue
        fi
        echo
        echo "$account:$password" >>"$TEMP_FILE"
        encrypt_file
        echo "Password saved!"
        ;;
    2)
        read -p "Enter account name to retrieve: " account
        decrypt_file
        result=$(grep "^$account:" "$TEMP_FILE" | cut -d ':' -f 2)
        if [[ -n $result ]]; then
            echo "Password for $account: $result"
        else
            echo "Account not found."
        fi
        encrypt_file
        ;;
    3)
        decrypt_file
        echo "Accounts:"
        cut -d ':' -f 1 "$TEMP_FILE"
        encrypt_file
        ;;
    4)
        read -p "Enter account name to delete: " account
        decrypt_file
        if grep -q "^$account:" "$TEMP_FILE"; then
            sed -i "/^$account:/d" "$TEMP_FILE"
            encrypt_file
            echo "Password for $account has been deleted."
        else
            echo "Account not found."
        fi
        ;;
    5)
        read -p "Enter the filename to export passwords: " export_file
        if [[ -z $export_file ]]; then
            echo "Export filename cannot be empty."
            return
        fi

        decrypt_file
        if [[ $? -ne 0 ]]; then
            echo "Failed to decrypt the password store. Check the check the master password."
            return
        fi

        cp "$TEMP_FILE" "$export_file"

        chmod 600 "$export_file"

        echo "Passwords have been exported to '$export_file'."
        echo "WARNING: The export file contains sensitive information in plaintext."
        echo "Ensure it is handled securely and deleted when no longer needed."
        ;;
    6)
        read -p "Enter the filename to import passwords from: " import_file
        if [[ -z $import_file ]]; then
            echo "Import filename cannot be empty."
            return
        fi

        if [[ ! -f $import_file ]]; then
            echo "File '$import_file' does not exist."
            return
        fi

        decrypt_file
        if [[ $? -ne 0 ]]; then
            echo "Failed to decrypt the password store. Please check your master password."
            return
        fi

        while IFS= read -r line; do
            # Skip empty lines/lines without proper format
            if [[ ! $line =~ ^[^:]+:[^:]+$ ]]; then
                echo "Skipping invalid line: $line"
                continue
            fi

            account=$(echo "$line" | cut -d ':' -f 1)
            password=$(echo "$line" | cut -d ':' -f 2)

            if grep -q "^$account:" "$TEMP_FILE"; then
                echo "Skipping duplicate account: $account"
                continue
            fi

            echo "$account:$password" >> "$TEMP_FILE"
            echo "Imported account: $account"

        done < "$import_file"

        encrypt_file
        echo "Passwod have been successfully imported."
        ;;
    7)
        if [[ -f help.txt ]]; then
            cat help.txt
        else
            echo "Help file not found. Please ensure 'help.txt' is in the same directory as the script."
        fi
        ;;
    8)
        echo "Exiting Password Manager."
        exit 0
        ;;
    *)
        echo "Invalid option. Please choose between 1-8."
        ;;
    esac
done