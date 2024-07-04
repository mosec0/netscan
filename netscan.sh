#!/bin/bash

read -p "Enter the IP address or network (e.g., 192.168.1.0/24): " network

if [ -z "$network" ]; then
    echo "No IP address or network entered. Exiting."
    exit 1
fi

output_file="network_scan_results.txt"

if [ -f "$output_file" ]; then
    rm "$output_file"
fi

echo "Scanning network $network..."
nmap -sP "$network" -oN "$output_file"

echo "Initial scan completed. Starting detailed scans..."

mapfile -t ip_addresses < <(grep -oP '(?<=for )(\d{1,3}\.){3}\d{1,3}' "$output_file")

for ip in "${ip_addresses[@]}"; do
    echo "Detailed scan for $ip..."
    nmap -A "$ip" >> "$output_file"
    echo "Detailed scan for $ip completed." >> "$output_file"
done

echo "All scans completed. Results saved in $output_file."
