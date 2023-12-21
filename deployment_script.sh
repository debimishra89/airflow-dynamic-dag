#!/bin/bash

# Check if the input directory exists
if [ ! -d "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Get the absolute path of the input directory
input_dir=$(cd "$1" && pwd)

# Get the directory name
dir_name=$(basename "$input_dir")


# Define the zip file name (using the directory name and optional timestamp)
zip_file="$dir_name.zip"

# Change to the input directory
cd "$input_dir" || exit 1


# Define the name of your virtual environment
venv_name="/opt/venvs/""$dir_name""_env"

# Create the virtual environment
python3 -m venv "$venv_name"

# Install packages from the requirements.txt file
"$venv_name/bin/pip" install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org -r requirements.txt

echo "Virtual environment '$venv_name' created, and packages installed."


# Define the Python script file
python_script="test_df.py"


# Define the lines you want to insert
line1="PYTHONPATH=/root/airflow/dags/""$zip_file"
line2="PYTHON_ENV=""$venv_name""/bin/python"

sed -i "1s|^|$line1\n|" $python_script
sed -i "1s|^|$line2\n|" $python_script

echo "Lines inserted successfully."


# Create the zip file
zip -r "$zip_file" .

# Move the zip file to the DAG directory
dag_dir=/root/airflow/dags
mv "$zip_file" $dag_dir

# Return to the original working directory
cd - || exit 1

echo "Zip file '$zip_file' created in the current directory."
echo "Zip file '$zip_file' moved to the DAG directory."