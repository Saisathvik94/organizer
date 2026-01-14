# 🗂️ Organizer CLI

A simple, fast, cross-platform command-line tool written in Go to organize files in a directory based on their file types (Images, Documents, Videos, Programs, etc.).

Just run one command and your messy  folder becomes clean ✨

## 🚀 Features

**📁 Organizes files by file extensions**

- 🖼️ Images → Images/

- 📄 Documents → Documents/

- 🎥 Videos → Videos/

- 🎵 Audio → Audio/

- 💻 Code files → Programs/

- 📦 Archives → Archives/

- 📌 Others → Others/

**👷‍♂️ Works for:**

- A single file

- A directory (like Downloads)

- Automatically creates folders if they don’t exist

- Cross-platform (Windows, macOS, Linux)

## 📦 Categories & Extensions**
**Category	Extensions**

- Images	.png, .jpg, .jpeg, .svg, .gif, .webp
- Documents	.pdf, .docx, .doc, .txt, .ppt, .pptx, .xls, .xlsx
- Videos	.mp4, .mkv, .avi, .mov, .webm
- Audio	.mp3, .wav, .flac, .aac
- Programs	.go, .py, .c, .cpp, .js, .ts, .java, .rs
- Archives	.zip, .rar, .7z, .tar, .gz
- Others	Everything else

---

## 🛠️ Installation

**For Windows:**

```
iwr https://raw.githubusercontent.com/Saisathvik94/organizer/main/scripts/install.ps1 | iex
```
> **Important :** Make sure to run the command as an `administrator` using Powershell.

**For Linux/macos:**

```
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/Saisathvik94/organizer/main/scripts/install.sh)"
```
---

## ▶️ Usage
**🔹 Organize a directory**
```
organizer ~/Downloads
```

**🔹 Dry Run ( preview changes without moving files )**
```
organizer ~/Downloads --dry-run
```

## 📁 Result:
```
Downloads/
 ├── Images/
 ├── Documents/
 ├── Videos/
 ├── Programs/
 ├── Others/
```

**🔹 Organize a single file**
```
organizer ~/Downloads/image.png
```

**🔹 Dry Run ( preview changes without moving file )**
```
organizer ~/Downloads/image.png --dry-run
```

**Result:**

Downloads/Images/image.png


## 🧠 How It Works

- Takes a file or directory path as input

- Normalizes the path

- Checks if it exists

- Reads files (ignores folders)

- Detects file extension

- Maps extension → category

- Creates category folder if missing

- Moves the file safely

## 🔐 Safety & Notes

- ❌ Does not delete files

- ❌ Does not overwrite existing files

- ✔ Only moves files inside the given directory

- ✔ Ignores sub-directories (non-recursive)

## 🧪 Development

**Clone the repo:**
```
git clone https://github.com/Saisathvik94/organizer.git
cd organizer
```

**Run locally:**

go run ./cmd/main.go


**Build binary:**
```
# Linux/macOS:
go build -o organizer ./cmd/main.go

# Windows:
go build -o organizer.exe ./cmd/main.go
```


## 🧩 Future Improvements

- --recursive flag

- Configurable categories

- Undo support


## 🤝 Contributing

Pull requests are welcome!

Fork the repo

Create a feature branch

Commit your changes

Open a PR

📜 License

## ⚖ MIT License
Free to use, modify, and distribute.

## ⭐ Support

If you found this useful, give the repo a ⭐
It helps a lot 🙌
