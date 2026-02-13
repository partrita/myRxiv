import argparse
import datetime
import os
import re
import sys

def slugify(text):
    text = text.lower()
    text = re.sub(r'[^a-z0-9]+', '_', text)
    text = text.strip('_')
    return text

def main():
    if len(sys.argv) > 1:
        parser = argparse.ArgumentParser(description="Create a new Typst document from template.")
        parser.add_argument("--title", help="The title of the document")
        parser.add_argument("--subtitle", help="The subtitle of the document")
        parser.add_argument("--author", help="The author name")
        parser.add_argument("--filename", help="The output filename (without .typ extension)")
        args = parser.parse_args()
        
        if not args.title:
            print("Error: --title is required when using command line arguments.")
            sys.exit(1)
            
        title = args.title
        subtitle = args.subtitle # None if not provided
        author = args.author or "Taeyoon Kim"
        filename_input = args.filename
    else:
        # Interactive mode
        print("Creating a new Typst document...")
        title = input("Enter document title: ")
        while not title:
            print("Title cannot be empty.")
            title = input("Enter document title: ")
            
        subtitle = input("Enter document subtitle (optional): ") or None
        author = input("Enter author name (default: Taeyoon Kim): ") or "Taeyoon Kim"
        filename_input = None

    current_date = datetime.date.today()
    date_prefix = current_date.strftime("%y%m%d")
    
    if not filename_input:
        slug = slugify(title)
        filename_input = f"{date_prefix}_{slug}"
    
    # Define directory and file paths
    # If the user provided filename input, we use that as the folder name too
    folder_name = filename_input.replace('.typ', '')
    folder_path = os.path.join("src", folder_name)
    
    # Create main folder
    if not os.path.exists(folder_path):
        os.makedirs(folder_path)
    else:
        print(f"Error: Directory '{folder_path}' already exists.")
        return

    # Create images folder
    images_path = os.path.join(folder_path, "images")
    os.makedirs(images_path)

    if not filename_input.endswith(".typ"):
        filename = f"{filename_input}.typ"
    else:
        filename = filename_input
        
    filepath = os.path.join(folder_path, filename)
    
    # Prepare template content
    # Since the file is inside a subdirectory of src, we need to go up one level to find templates
    template_path = "../templates/conf.typ"
    
    content = f"""#import "{template_path}": template

#show: template.with(
  title: "{title}",
  subtitle: {f'"{subtitle}"' if subtitle else 'none'},
  short-title: "{title}",
  // venue: [Venue Name],
  // logo: "path/to/logo.png",
  // doi: "10.1234/example",
  date: datetime(year: {current_date.year}, month: {current_date.month}, day: {current_date.day}),
  // theme: rgb("#5e81ac"),
  authors: (
    (
      name: "{author}",
      // orcid: "0000-0000-0000-0000",
      // email: "email@example.com",
      // affiliations: "1"
    ),
  ),
  // affiliations: (
  //   (id: "1", name: "Affiliation Name"),
  // ),
  abstract: (
    (title: "Abstract", content: [
      Enter your abstract here...
    ]),
  ),
  keywords: ("Key1", "Key2"),
  // open-access: true,
  // kind: "Article",
  // margin: (
  //   (
  //     title: "Key Points",
  //     content: [
  //       - Point 1
  //       - Point 2
  //     ],
  //   ),
  // ),
)

= Introduction <introduction>

Write your introduction here.

= Conclusion <conclusion>

Write your conclusion here.
"""
    
    try:
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"Successfully created '{filepath}'.")
        print(f"Images directory created at '{images_path}'.")
    except Exception as e:
        print(f"Error creating file: {e}")

if __name__ == "__main__":
    main()
