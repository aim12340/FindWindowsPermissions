# FindWindowsPermissions

A Windows batch file to log any custom permissions within nested folders. 

Originally created to help migrate IIS websites by identifying custom access control lists (ACLs), but this tool will work with any directory structure.

---

## 🚀 Features

* **Recursive Scanning:** Checks all nested subfolders within a target directory.
* **Filter Inheritance:** Automatically filters out inherited permissions to highlight only the custom modifications that have been added.
* **Zero Setup:** No installation or complex CLI commands required.

---

## 🛠️ Instructions

Using the script is simple:
1. Locate the `FindWindowsPermissions.bat` file.
2. **Drag and drop** any folder you want to scan directly onto the batch file.

---

## 📊 Results

Once the scan is complete, the script generates a log file in the same directory:
* **Format:** `<folder_name>.permissions.log`
* **Content:** A list of folders and subfolder containing non-inherited permissions, along with the specific access rights assigned to them.
