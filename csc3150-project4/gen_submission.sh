#!/bin/bash

echo "Please enter your student ID:"
read student_id

# Check if the student ID is a nine-digit number
if [[ ! $student_id =~ ^[0-9]{9}$ ]]; then
    echo "Error: The student ID should be a nine-digit number."
    exit 1
fi

# Ask the user for the directory of the report.pdf
echo "Please enter the directory of your report.pdf (e.g. ~/csc3150-project4):"
read report_dir

report_dir="${report_dir%/Report.pdf}/Report.pdf"
report_dir="${report_dir/#\~/$HOME}"

echo $report_dir

# Check if report.pdf exists in the given directory
if ! test -f $report_dir; then
    echo "Error: Report.pdf does not exist in the given directory."
    exit 1
fi

# Define the target directory
dir_source="/home/csc3150/csc3150-project4/submission/Assignment_4_$student_id/source"
dir_report="/home/csc3150/csc3150-project4/submission/Assignment_4_$student_id/"

# Check if the target directory exists, if not, create it
if [ ! -d $dir_source ]; then
    mkdir -p "$dir_source"
fi

# Copy files from ./kernel to the target directory
cp ./kernel/{proc.c,proc.h,sysfile.c,trap.c} "$dir_source/"

# Copy report.pdf to the target directory
cp "$report_dir" "$dir_report/"

# Zip the target directory
cd /home/csc3150/csc3150-project4/submission/
zip -r "Assignment_4_$student_id.zip" "Assignment_4_$student_id/"
