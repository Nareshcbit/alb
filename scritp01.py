import os
import re
import json

# Define the directory to search and the source account value
directory = "./"  # Change to your directory path
source_account = "x"  # Replace with your source account value

def update_assume_role_statements(file_content):
    # Regex pattern to find aws_iam_role resources
    role_pattern = r'resource\s+"aws_iam_role"\s+"[^"]+"\s+\{[^}]+\}'
    # Regex pattern to find assume role policy statements
    assume_role_pattern = r'("Action"\s*=\s*\"sts:AssumeRole\"[^}]*})'
    
    # Function to add the condition if it doesn't exist
    def add_condition(statement):
        condition_pattern = r'"Condition"\s*=\s*\{[^}]*\}'
        if re.search(condition_pattern, statement):
            condition_block = re.search(condition_pattern, statement).group()
            if '"aws:SourceAccount"' not in condition_block:
                updated_condition = condition_block[:-1] + f', "aws:SourceAccount" = "{source_account}"' + condition_block[-1]
                return statement.replace(condition_block, updated_condition)
        else:
            updated_statement = statement[:-1] + f',\n  "Condition" = {{\n    "aws:SourceAccount" = "{source_account}"\n  }}\n' + statement[-1]
            return updated_statement
        return statement
    
    # Find all aws_iam_role resources in the file content
    roles = re.findall(role_pattern, file_content, re.DOTALL)
    updated_content = file_content
    
    for role in roles:
        # Find all assume role statements in the role
        statements = re.findall(assume_role_pattern, role, re.DOTALL)
        updated_role = role
        
        for statement in statements:
            # Add condition to each statement
            updated_statement = add_condition(statement)
            updated_role = updated_role.replace(statement, updated_statement)
        
        updated_content = updated_content.replace(role, updated_role)
    
    return updated_content

# Walk through the directory and process each .tf file
for root, dirs, files in os.walk(directory):
    for file in files:
        if file.endswith(".tf"):
            file_path = os.path.join(root, file)
            with open(file_path, 'r') as f:
                content = f.read()
            
            updated_content = update_assume_role_statements(content)
            
            with open(file_path, 'w') as f:
                f.write(updated_content)

print("All .tf files have been processed and updated.")
