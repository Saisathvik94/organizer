package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
)

func checkPathexist(arg string) bool {
	_, err := os.Stat(arg)
	return err == nil
}

func normalizePath(arg string) (string, error) {
	// 1. Clean path (removes extra slashes, dots)
	cleaned := filepath.Clean(arg)

	// 2. Convert to absolute path
	absPath, err := filepath.Abs(cleaned)
	if err != nil {
		return "", err
	}

	return absPath, nil
}

func main() {
	// HELP Flag
	flag.Usage = func() {
		fmt.Println("Organizer CLI")
		fmt.Println()
		fmt.Println("Usage:")
		fmt.Println("  organizer <path>")
		fmt.Println()
		fmt.Println("Description:")
		fmt.Println("  Organizes files into folders based on file type.")
		fmt.Println()
	}
	flag.Parse()
	args := flag.Args()

	if len(args) < 1 {
		flag.Usage()
		return
	}

	arg := args[0]

	normalizedPath, err := normalizePath(arg)
	if err != nil {
		fmt.Println("Invalid path:", err)
		log.Fatal(err)
	}

	fmt.Println("Normalized Path:", normalizedPath)

	// check existence of file
	exists := checkPathexist(normalizedPath)
	if !(exists) {
		log.Fatal("Path does not exist:", err)
	}

	info, err := os.Stat(normalizedPath)

	var files []string
	parentDir := normalizedPath

	if info.IsDir() {
		entries, err := os.ReadDir(normalizedPath)
		if err != nil {
			log.Fatal(err)
		}

		for _, entry := range entries {
			fmt.Println(entry.Name())
			if !(entry.IsDir()) {
				filePath := filepath.Join(normalizedPath, entry.Name())
				files = append(files, filePath)
			}
		}
	} else {
		fmt.Println("Input is a file")
		parentDir = filepath.Dir(normalizedPath)
		files = append(files, normalizedPath)
	}

	for _, file := range files {
		base := filepath.Base(file)
		extension := strings.ToLower(filepath.Ext(file))
		var category string

		// Map extensions to categories
		switch extension {
		case ".png", ".jpg", ".jpeg", ".gif", ".bmp", ".svg", ".tiff", ".ico":
			category = "Images"

		case ".pdf", ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".txt", ".odt":
			category = "Documents"

		case ".mp4", ".mkv", ".avi", ".mov", ".wmv", ".flv", ".webm":
			category = "Videos"

		case ".mp3", ".wav", ".aac", ".flac", ".ogg":
			category = "Audio"

		case ".zip", ".rar", ".7z", ".tar", ".gz":
			category = "Archives"

		case ".py", ".c", ".cpp", ".go", ".js", ".ts", ".java", ".html", ".css", ".rb", ".php", ".rs", ".swift":
			category = "Programs"

		case ".exe", ".msi", ".bat", ".sh", ".app":
			category = "Executables"

		default:
			category = "Others"
		}

		// Build folder path inside parentDir
		folderPath := filepath.Join(parentDir, category)

		// Create folder if it does not exist
		if _, err := os.Stat(folderPath); os.IsNotExist(err) {
			err := os.MkdirAll(folderPath, 0755)
			if err != nil {
				log.Fatal("Failed to create folder:", err)
			}
		}

		// Build destination path
		destinationPath := filepath.Join(folderPath, base)

		// Move file
		err := os.Rename(file, destinationPath)
		if err != nil {
			log.Println("Failed to move file:", file, "->", destinationPath, "Error:", err)
		} else {
			fmt.Println("Moved", file, "->", destinationPath)
		}
	}
}
