package organizer

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"time"

	"github.com/Saisathvik94/organizer/internal/fs"
	"github.com/Saisathvik94/organizer/internal/categorize"
)

func Run(path string, dryRun bool) error {
	normalizedPath, err := fs.NormalizePath(path)
	if err != nil {
		return err
	}

	if !fs.CheckPathExist(normalizedPath) {
		return fmt.Errorf("Path does not exist")
	}

	files, parentDir, err := fs.CollectFiles(normalizedPath)
	if err != nil {
		return err
	}

	// For summary 
	startTime := time.Now()
	filesScanned := 0
	filesMoved := 0
	filesSkipped := 0
	errorsCount := 0

	for _, file := range files {
		filesScanned++

		base := filepath.Base(file)
		ext := filepath.Ext(file)
		category := categorize.GetCategory(ext)

		if ext == "" {
			filesSkipped++
			continue
		}

		folderPath := filepath.Join(parentDir, category)
		dest := filepath.Join(folderPath, base)

		// Skip if file already exists
		if _, err := os.Stat(dest); err == nil {
			filesSkipped++
			continue
		}

		if dryRun {
			fmt.Println("[DRY RUN]", file, "->", dest)
			filesMoved++
			continue
		}

		if err := os.MkdirAll(folderPath, 0755); err != nil {
			log.Println("Creating Folder failed:", err)
			errorsCount++
			continue
		}

		if err := os.Rename(file, dest); err != nil {
			log.Println("Move failed:", err)
			errorsCount++
			continue
		}

		filesMoved++
	}

	duration := time.Since(startTime)

	fmt.Println()
	fmt.Println("Summary")
	fmt.Println("────────────")
	fmt.Println("✔ Files scanned:", filesScanned)
	fmt.Println("⚠ Files skipped:", filesSkipped)
	fmt.Println("✖ Errors:", errorsCount)
	if dryRun {
		fmt.Println("✔ Files that would be organized:", filesScanned-filesSkipped)
	} else {
		fmt.Println("✔ Files organized:", filesMoved)
	}
	fmt.Println("Time taken:", duration)

	return nil
}