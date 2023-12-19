#!/bin/bash

# Function to display help
function display_help() {
    echo "Usage: internsctl [OPTIONS]"
    echo "This is a custom command for operations."
    echo "Options:"
    echo "--help      Display this help message"
    echo "--version   Display the version of the command"
    echo "cpu getinfo Display CPU information"
    echo "memory getinfo Display memory information"
    echo "user create <username> Create a new user"
    echo "user list List all regular users"
    echo "user list --sudo-only List all users with sudo permissions"
    echo "file getinfo <file-name> Display information about a file"
}

# Function to display version
function display_version() {
    echo "internsctl version v0.1.0"
}

# Function to get CPU info
function get_cpu_info() {
    lscpu
}

# Function to get memory info
function get_memory_info() {
    free
}

# Function to create a new user
function create_user() {
    sudo useradd -m $1
}

# Function to list all regular users
function list_users() {
    cut -d: -f1 /etc/passwd
}

# Function to list all users with sudo permissions
function list_sudo_users() {
    getent group sudo | cut -d: -f4
}

# Function to get file info
function get_file_info() {
    stat $1
}

# Check if no arguments were passed
if [ $# -eq 0 ]; then
    echo "No arguments provided. Use --help for usage information."
    exit 1
fi

# Parse command line arguments
while (( "$#" )); do
    case "$1" in
        --help)
            display_help
            exit 0
            ;;
        --version)
            display_version
            exit 0
            ;;
        cpu)
            shift
            case "$1" in
                getinfo)
                    get_cpu_info
                    exit 0
                    ;;
                *)
                    echo "Unknown option: $1. Use --help for usage information."
                    exit 1
                    ;;
            esac
            ;;
        memory)
            shift
            case "$1" in
                getinfo)
                    get_memory_info
                    exit 0
                    ;;
                *)
                    echo "Unknown option: $1. Use --help for usage information."
                    exit 1
                    ;;
            esac
            ;;
        user)
            shift
            case "$1" in
                create)
                    shift
                    create_user $1
                    exit 0
                    ;;
                list)
                    shift
                    if [ "$1" == "--sudo-only" ]; then
                        list_sudo_users
                    else
                        list_users
                    fi
                    exit 0
                    ;;
                *)
                    echo "Unknown option: $1. Use --help for usage information."
                    exit 1
                    ;;
            esac
            ;;
        file)
            shift
            case "$1" in
                getinfo)
                    shift
                    get_file_info $1
                    exit 0
                    ;;
                *)
                    echo "Unknown option: $1. Use --help for usage information."
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo "Unknown option: $1. Use --help for usage information."
            exit 1
            ;;
    esac
done
