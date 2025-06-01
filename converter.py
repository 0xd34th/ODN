import base64
import os
from collections import defaultdict

# Settings
input_folder = "/Combined/webp"
output_folder = os.path.join(input_folder, "b64_fixed")
max_file_size_bytes = 15.5 * 1024  # 16KB = 16384 bytes
prefix = "data:image/webp;base64,"

def get_type(name):
    return name.split('_')[0]

# Setup
os.makedirs(output_folder, exist_ok=True)
trait_groups = defaultdict(list)

# Encode all files
for filename in os.listdir(input_folder):
    if filename.lower().endswith(".webp"):
        path = os.path.join(input_folder, filename)
        with open(path, "rb") as f:
            raw_bytes = f.read()
            encoded = base64.b64encode(raw_bytes).decode("utf-8")
        trait_type = get_type(filename)
        trait_groups[trait_type].append((filename, encoded))

# Split and write
for trait_type, files in trait_groups.items():
    print(f"🧩 Processing group: {trait_type}")
    max_parts = 0
    
    # First pass: split all files and find max parts
    split_files = []
    for filename, encoded in files:
        parts = []
        idx = 0
        remaining = encoded  # Don't modify the original
        
        while remaining:
            chunk = ""
            while remaining and len((prefix if idx == 0 else "") + chunk + remaining[0]) <= max_file_size_bytes:
                chunk += remaining[0]
                remaining = remaining[1:]
            
            full_chunk = (prefix if idx == 0 else "") + chunk
            parts.append(full_chunk)
            idx += 1
        
        max_parts = max(max_parts, len(parts))
        split_files.append((filename, parts))
    
    # Second pass: write padded output
    for filename, parts in split_files:
        name_base = os.path.splitext(filename)[0]
        for i in range(max_parts):
            part_data = parts[i] if i < len(parts) else ""
            part_filename = f"{name_base}_part{i}.txt"
            out_path = os.path.join(output_folder, part_filename)
            with open(out_path, "w") as out:
                out.write(part_data)
        print(f"✓ {name_base}: padded to {max_parts} parts")