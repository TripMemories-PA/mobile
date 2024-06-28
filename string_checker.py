import os
import re

def scan_for_hardcoded_strings(directory):
    string_pattern = re.compile(r'["\']([^"\']+)["\']')
    extensions = ['.dart', '.py', '.java', '.js', '.ts', '.html', '.css']

    for root, _, files in os.walk(directory):
        for file in files:
            if any(file.endswith(ext) for ext in extensions):
                if "freezed" in file or ".g." in file or "string_constants" in file:
                    continue
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                    for line_number, line in enumerate(f, 1):
                        if line.strip().startswith('import'):
                            continue
                        matches = string_pattern.findall(line)
                        if matches:
                            for match in matches:
                                print(f'{file_path}:{line_number}: {match}')

if __name__ == "__main__":
    project_directory = 'lib'
    scan_for_hardcoded_strings(project_directory)
